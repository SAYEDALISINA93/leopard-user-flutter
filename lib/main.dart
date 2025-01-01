import 'dart:io';
import 'package:leoparduser/core/theme/light/light.dart';
import 'package:leoparduser/core/utils/audio_utils.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/services/unverified_service.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/firebase_options.dart';
import 'package:leoparduser/data/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/messages.dart';
import 'package:leoparduser/data/controller/localization/localization_controller.dart';
import 'core/di_service/di_services.dart' as di_service;

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  sharedPreferences.setBool(SharedPreferenceHelper.hasNewNotificationKey, true);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di_service.init();
  MyUtils.allScreen();
  MyUtils().stopLandscape();
  AudioUtils();
  try {
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    await PushNotificationService(apiClient: Get.find()).setupInteractedMessage();
  } catch (e) {
    print(e);
  }
  HttpOverrides.global = MyHttpOverrides();
  UnverifiedService.instance.setIsUnverified(false);
  runApp(MyApp(languages: languages));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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
        fallbackLocale: Locale(localizeController.locale.languageCode, localizeController.locale.countryCode),
      ),
    );
  }
}
