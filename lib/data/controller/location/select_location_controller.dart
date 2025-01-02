import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/location/selected_location_info.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../core/helper/string_format_helper.dart';
import '../../../core/utils/my_strings.dart';
import '../../model/location/place_details.dart';
import '../../model/location/prediction.dart';
import '../../repo/location/location_search_repo.dart';
import '../home/home_controller.dart';

class SelectLocationController extends GetxController {
  LocationSearchRepo locationSearchRepo;
  int index;
  SelectLocationController(
      {required this.locationSearchRepo, required this.index});

  changeIndex(int i) {
    index = i;
    update();
  }

  Position? currentPosition;
  final currentAddress = "".obs;
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;

  bool isLoading = false;
  bool isLoadingFirstTime = false;

  HomeController homeController = Get.find();
  TextEditingController searchLocationController =
      TextEditingController(text: '');
  TextEditingController valueOfLocation = TextEditingController(text: '');
  TextEditingController destinationController = TextEditingController(text: '');
  TextEditingController pickUpController = TextEditingController(text: '');
  FocusNode searchFocus = FocusNode();
  clearTextFiled(int index) {
    if (index == 0) {
      pickUpController.text = '';
    } else {
      destinationController.text = '';
    }
  }

  void initialize() {
    loggerX(
        "homeController.selectedLocations.length ${homeController.selectedLocations.length}");
    if (homeController.selectedLocations.isNotEmpty) {
      pickUpController.text = homeController
              .getSelectedLocationInfoAtIndex(0)
              ?.getFullAddress(showFull: true) ??
          '';
      destinationController.text = homeController
              .getSelectedLocationInfoAtIndex(1)
              ?.getFullAddress(showFull: true) ??
          '';
    }
    getCurrentPosition(isLoading1stTime: true, pickupLocationForIndex: index);
  }

  Future<bool> handleLocationPermission() async {
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

  int curPosCalled = 1;
  Future<void> getCurrentPosition(
      {isLoading1stTime = false, int pickupLocationForIndex = -1}) async {
    if (isLoading1stTime) {
      isLoadingFirstTime = true;
    } else {
      isLoadingFirstTime = false;
    }
    isLoading = true;

    update();

    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      return;
    }

    var getSelectLocationData =
        homeController.getSelectedLocationInfoAtIndex(pickupLocationForIndex);
    if (getSelectLocationData == null) {
      pickupLocationForIndex = -1;
    } else {
      pickupLocationForIndex = pickupLocationForIndex;
    }

    if (pickupLocationForIndex == -1) {
      // ignore: deprecated_member_use
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        currentPosition = value;
      });
    }

    if (currentPosition != null && getSelectLocationData == null) {
      changeCurrentLatLongBasedOnCameraMove(
          currentPosition!.latitude, currentPosition!.longitude);
      update();
      animateMapCameraPosition();
    } else {
      changeCurrentLatLongBasedOnCameraMove(
          getSelectLocationData!.latitude!, getSelectLocationData.longitude!);
      update();
      animateMapCameraPosition();
    }

    isLoading = false;
    isLoadingFirstTime = false;
    update();
  }

  LatLng getInitialTargetLocationForMap({int pickupLocationForIndex = -1}) {
    var getSelectLocationData =
        homeController.getSelectedLocationInfoAtIndex(pickupLocationForIndex);
    if (getSelectLocationData == null) {
      return currentPosition != null
          ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
          : const LatLng(37.0902, 95.7129);
    } else {
      return LatLng(
          getSelectLocationData.latitude!, getSelectLocationData.longitude!);
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placeMark) {
      Placemark placemark = placeMark[0];
      loggerX(placemark.toJson());
      currentAddress.value =
          '${placemark.name ?? ''}, ${placemark.thoroughfare ?? ''}, ${placemark.subThoroughfare ?? ''}, ${placemark.locality ?? ''}, ${placemark.subAdministrativeArea ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}';
      update();
      if (index == 0) {
        pickUpController.text = selectedAddressFromSearch.isEmpty
            ? currentAddress.value
            : selectedAddressFromSearch;
      } else {
        destinationController.text = selectedAddressFromSearch.isEmpty
            ? currentAddress.value
            : selectedAddressFromSearch;
      }
      homeController.addLocationAtIndex(
          SelectedLocationInfo(
              latitude: latitude,
              longitude: longitude,
              fullAddress: selectedAddressFromSearch.isEmpty
                  ? currentAddress.value
                  : selectedAddressFromSearch),
          index);
    }).catchError((e) {
      printx(e.toString());
    });
  }

  void changeCurrentLatLongBasedOnCameraMove(
      double selectedLatitude, double selectedLongitude) {
    this.selectedLatitude = selectedLatitude;
    this.selectedLongitude = selectedLongitude;

    update();
  }

  GoogleMapController? mapController;
  animateMapCameraPosition() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedLatitude, selectedLongitude),
        zoom: Environment.mapDefaultZoom)));
  }

  Future<void> pickLocation() async {
    await openMap(selectedLatitude, selectedLongitude);
  }

  clearSearchField() {
    allPredictions = [];
    searchLocationController.clear();
    update();
  }

  //ADDRESS   search+
  String selectedAddressFromSearch = '';
  updateSelectedAddressFromSearch(String address) {
    selectedAddressFromSearch = address;
    update();
  }

  bool isSearched = false;
  List<Prediction> allPredictions = [];

  Future<void> searchYourAddress({String locationName = ''}) async {
    isSearched = true;
    update();
    try {
      ResponseModel? response;
      PlacesAutocompleteResponse? subscriptionResponse;
      if (locationName.isNotEmpty) {
        allPredictions.clear();
        response = await locationSearchRepo.searchAddressByLocationName(
            text: locationName);

        subscriptionResponse = PlacesAutocompleteResponse.fromJson(
            jsonDecode(response!.responseJson));
      } else {
        allPredictions.clear();
        return;
      }
      if (subscriptionResponse.predictions!.isNotEmpty) {
        allPredictions.clear();
        allPredictions.addAll(subscriptionResponse.predictions!);
      }
      isSearched = false;
      update();
    } catch (e) {
      printx(e.toString());
    }
  }

  Future<LatLng?> getLangAndLatFromMap(Prediction prediction) async {
    try {
      ResponseModel response =
          await locationSearchRepo.getPlaceDetailsFromPlaceId(prediction);
      final placeDetails =
          PlaceDetails.fromJson(jsonDecode(response.responseJson));

      if (placeDetails.result == null) {
        return null;
      } else {
        prediction.lat =
            placeDetails.result!.geometry!.location!.lat.toString();
        prediction.lng =
            placeDetails.result!.geometry!.location!.lng.toString();
        changeCurrentLatLongBasedOnCameraMove(
            double.parse(prediction.lat!), double.parse(prediction.lng!));

        allPredictions = [];
        update();
        return LatLng(
            double.parse(prediction.lat!), double.parse(prediction.lng!));
      }
    } catch (e) {
      printx(e.toString());
    }
    return null;
  }
}
