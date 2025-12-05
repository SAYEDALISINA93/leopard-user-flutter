import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class AppLocationController extends GetxController {
  Position currentPosition = MyUtils.getDefaultPosition();
  String currentAddress = "Loading...";

  Future<bool> checkPermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      var requestStatus = await Geolocator.requestPermission();
      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        getCurrentPosition();
      } else {
        CustomSnackBar.error(errorList: ["Please enable location permission"]);
      }
    } else if (status == LocationPermission.deniedForever) {
      CustomSnackBar.error(
        errorList: [
          "Location permission is permanently denied. Please enable it from settings.",
        ],
      );
      if (Platform.isAndroid) {
        await openAppSettings(); // Opens device settings
      }
    } else if (status == LocationPermission.whileInUse) {
      getCurrentPosition();
    }
    // CustomSnackBar.error(errorList: [MyStrings.locationPermissionPermanentDenied]);
    return true;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      currentPosition = await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      currentAddress = "";
      currentAddress =
          "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare},${placemarks[0].subLocality},${placemarks[0].locality},${placemarks[0].country}";
      update();
      printX('appLocations possition $currentAddress');
      return currentPosition;
    } catch (e) {
      CustomSnackBar.error(
        errorList: [MyStrings.locationPermissionPermanentDenied],
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (Platform.isAndroid) {
          openAppSettings(); // Opens device settings
        }
      });
    }
    return null;
  }
}
