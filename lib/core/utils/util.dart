import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/data/model/global/app/app_payment_method.dart';
import 'package:leoparduser/data/model/global/app/app_service_model.dart';
import 'package:leoparduser/data/model/location/selected_location_info.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;
import 'dart:math';
import '../../data/model/location/route_info_model.dart';
import 'my_strings.dart';
//import 'package:vibration/vibration.dart';

class MyUtils {
  static splashScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColor.getPrimaryColor(),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: MyColor.getPrimaryColor(),
        systemNavigationBarIconBrightness: Brightness.light));
  }

  static allScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColor.getPrimaryColor(),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: MyColor.colorWhite,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  static dynamic getShadow() {
    return [
      BoxShadow(
          blurRadius: 15.0,
          offset: const Offset(0, 25),
          color: Colors.grey.shade500.withValues(alpha: 0.6),
          spreadRadius: -35.0),
    ];
  }

  static void vibrate() async {
    print('vibrate');
    // if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 1000);
    HapticFeedback.heavyImpact();
    // }
  }

  static copy({required String text}) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      CustomSnackBar.success(
          successList: [MyStrings.successfullyCopiedToClipboard]);
    });
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withValues(alpha: 0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static dynamic getShadow2({double blurRadius = 8}) {
    return [
      BoxShadow(
        color: MyColor.getShadowColor().withValues(alpha: 0.3),
        blurRadius: blurRadius,
        spreadRadius: 3,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        color: MyColor.getShadowColor().withValues(alpha: 0.3),
        spreadRadius: 1,
        blurRadius: blurRadius,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withValues(alpha: 0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static dynamic getCardTopShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withValues(alpha: 0.05),
        offset: const Offset(0, 0),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ];
  }

  static dynamic getBottomNavShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 0),
      ),
    ];
  }

  static getOperationTitle(String value) {
    String number = value;
    RegExp regExp = RegExp(r'^(\d+)(\w+)$');
    Match? match = regExp.firstMatch(number);
    if (match != null) {
      String? num = match.group(1) ?? '';
      String? unit = match.group(2) ?? '';
      String title = '${MyStrings.last.tr} $num ${unit.capitalizeFirst}';
      return title.tr;
    } else {
      return value.tr;
    }
  }

  //Location
  RouteInfo calculateDistanceAndTime(List<LatLng> points, double speed) {
    double totalDistance = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      double lat1 = points[i].latitude;
      double lon1 = points[i].longitude;
      double lat2 = points[i + 1].latitude;
      double lon2 = points[i + 1].longitude;

      // Calculate distance between two points (Haversine formula)
      double dLat = _toRadians(lat2 - lat1);
      double dLon = _toRadians(lon2 - lon1);

      double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
          math.cos(_toRadians(lat1)) *
              math.cos(_toRadians(lat2)) *
              math.sin(dLon / 2) *
              math.sin(dLon / 2);
      double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      double distance = 6371000 * c; // Radius of the Earth in meters

      totalDistance += distance;
    }

    double timeInSeconds = totalDistance / speed;
    return RouteInfo(totalDistance, timeInSeconds);
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  double calculateDistance(
      double startLat, double startLong, double endLat, double endLong) {
    const int radiusOfEarth = 6371;
    double dLat = _degreesToRadians(endLat - startLat);
    double dLon = _degreesToRadians(endLong - startLong);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLat)) *
            cos(_degreesToRadians(endLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radiusOfEarth * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void stopLandscape() {
    //normally ride sharing app doesn't have landscape mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      CustomSnackBar.error(errorList: [MyStrings.locationServiceDisableMsg]);
      return Future.value(false);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.error(errorList: [MyStrings.locationPermissionDenied]);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      CustomSnackBar.error(
          errorList: [MyStrings.locationPermissionPermanentDenied]);
      return false;
    }

    return true;
  }

  static LatLng getDefaultLatLong() {
    return const LatLng(-1, -1);
  }

  static Position getDefaultPosition() {
    return Position(
        longitude: 0.0,
        latitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
  }

  static List<SelectedLocationInfo> getDefaultLocationInfo() {
    return [SelectedLocationInfo(id: -1), SelectedLocationInfo(id: -2)];
  }

  static Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high));
    return position;
  }

  static List<AppPaymentMethod> getDefaultPaymentMethod() {
    return [
      AppPaymentMethod(
          id: '-9',
          method: AppService(
              id: "2", image: MyImages.payable, name: MyStrings.cashPayment.tr),
          name: MyStrings.cashPayment),
      //  AppPaymentMethod(id: '-99', method: AppService(code: "3", imageWithPath: MyImages.wallet, name: MyStrings.payFromWallet), name: MyStrings.payFromWallet),
    ];
  }

  static Future<void> launchPhone(url) async {
    await launchUrl(Uri.parse("tel:$url"));
  }

  List<Row> makeSlotWidget({required List<Widget> widgets}) {
    List<Row> pairs = [];
    for (int i = 0; i < widgets.length; i += 2) {
      Widget first = widgets[i];
      Widget? second =
          (i + 1 < widgets.length) ? widgets[i + 1] : const SizedBox();

      pairs.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: first),
          const SizedBox(width: Dimensions.space15),
          Expanded(child: second)
        ]),
      );
    }
    return pairs;
  }

  static String maskSensitiveInformation(String input) {
    try {
      if (input.isEmpty) {
        return '';
      }

      final int maskLength = input.length ~/ 2; // Mask half of the characters.

      final String mask = '*' * maskLength;

      final String maskedInput = maskLength > 4
          ? input.replaceRange(5, maskLength, mask)
          : input.replaceRange(0, maskLength, mask);

      return maskedInput;
    } catch (e) {
      return input;
    }
  }

  static String maskEmail(String email) {
    try {
      if (email.isEmpty) {
        return '';
      }

      // Split the email address into parts before and after '@' symbol
      List<String> parts = email.split('@');
      String maskedPart = maskString(parts[0]);

      // Check if there are more than one '@' symbols
      if (parts.length > 2) {
        // If there are, reconstruct the email address with only the first part masked
        return "$maskedPart@${parts[1]}";
      } else {
        // Otherwise, just mask the first part and keep the domain intact
        return "$maskedPart@${parts[1]}";
      }
    } catch (e) {
      return email;
    }
  }

  static String maskString(String str) {
    // Mask the string, leaving only the first and last characters visible
    if (str.length <= 2) {
      // If the string has only 2 characters or less, keep the first character visible
      return str.substring(0, 1) + "*" * (str.length - 1);
    } else {
      // If the string has more than 2 characters, keep the first and last characters visible
      return str.substring(0, 1) +
          "*" * (str.length - 2) +
          str.substring(str.length - 1);
    }
  }

  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high));
    return position;
  }

  static String getRideStatus(String status) {
    if (status == '0') {
      return MyStrings.pending;
    } else if (status == '1') {
      return MyStrings.completed;
    } else if (status == '2') {
      return MyStrings.active;
    } else if (status == '3') {
      return MyStrings.running;
    } else if (status == '4') {
      return MyStrings.endRide;
    } else {
      return MyStrings.canceled;
    }
  }

  static Color getRideStatusColor(String status) {
    if (status == '0') {
      return MyColor.pendingColor;
    } else if (status == '1') {
      return MyColor.greenSuccessColor;
    } else if (status == '2') {
      return MyColor.greenP;
    } else if (status == '3') {
      return MyColor.colorOrange;
    } else if (status == '4') {
      return Colors.lightBlueAccent;
    } else {
      return MyColor.redCancelTextColor;
    }
  }

  static Color paymentStatusColor(String status) {
    if (status == AppStatus.PAYMENT_TYPE_CASH) {
      return MyColor.greenSuccessColor;
    } else {
      return Colors.blueAccent;
    }
  }

  static String paymentStatus(String status) {
    if (status == AppStatus.PAYMENT_TYPE_CASH) {
      return MyStrings.cashPayment;
    } else {
      return MyStrings.onlinePayment;
    }
  }

  static String rideType(String status) {
    if (status == AppStatus.RIDE_TYPE_CITY) {
      return MyStrings.city;
    } else {
      return MyStrings.interCity;
    }
  }

  static bool isImage(String path) {
    if (path.contains('.jpg')) {
      return true;
    }
    if (path.contains('.png')) {
      return true;
    }
    if (path.contains('.jpeg')) {
      return true;
    }
    return false;
  }

  static bool isXlsx(String path) {
    if (path.contains('.xlsx')) {
      return true;
    }
    if (path.contains('.xls')) {
      return true;
    }
    if (path.contains('.xlx')) {
      return true;
    }
    return false;
  }

  static bool isDoc(String path) {
    if (path.contains('.doc')) {
      return true;
    }
    if (path.contains('.docs')) {
      return true;
    }
    return false;
  }
}
//\bMyStrings\.\w+(?!\.tr)\b
