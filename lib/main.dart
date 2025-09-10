import 'dart:io';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/theme/light/light.dart';
import 'package:leoparduser/core/utils/audio_utils.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/services/running_ride_service.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/data/services/push_notification_service.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/messages.dart';
import 'package:leoparduser/data/controller/localization/localization_controller.dart';
import 'core/di_service/di_services.dart' as di_service;
import 'data/services/api_client.dart';
import 'package:timezone/data/latest.dart' as tz;

//APP ENTRY POINT
Future<void> main() async {
  // Ensures that widget binding is initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the API client for network communication
  await ApiClient.init();

  // Load and initialize localization/language support
  Map<String, Map<String, String>> languages = await di_service.init();

  // Configure app UI to support all screen sizes
  MyUtils.allScreen();

  // Lock device orientation to portrait mode
  MyUtils().stopLandscape();

  // Initialize audio utilities (e.g., background music, sound effects)
  AudioUtils();

  try {
    // Initialize push notification service and handle interaction messages
    await PushNotificationService(apiClient: Get.find())
        .setupInteractedMessage();
  } catch (e) {
    // Print error to console if FCM setup fails
    printX(e);
  }

  // Override HTTP settings (e.g., SSL certificate handling)
  HttpOverrides.global = MyHttpOverrides();

  // Set running ride status to false at app launch
  RunningRideService.instance.setIsRunning(false);

  tz.initializeTimeZones();

  // Launch the main application with loaded languages
  runApp(MyApp(languages: languages));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) => GetMaterialApp(
        title: Environment.appName,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        initialRoute: RouteHelper.splashScreen,
        getPages: RouteHelper().routes,
        locale: localizeController.locale,
        translations: Messages(languages: widget.languages),
        fallbackLocale: Locale(
          localizeController.locale.languageCode,
          localizeController.locale.countryCode,
        ),
      ),
    );
  }
}
