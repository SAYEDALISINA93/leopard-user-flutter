// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/dashboard/dashboard_response_model.dart';
import 'package:leoparduser/data/model/global/app/app_payment_method.dart';
import 'package:leoparduser/data/model/global/app/app_service_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/ride/create_ride_request_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';
import 'package:leoparduser/data/model/ride/ride_fare_response_model.dart';

import 'package:leoparduser/data/repo/home/home_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class InterCityController extends GetxController {
  HomeRepo homeRepo; // useing homRepo for similer endpoints
  HomeController homeController;
  InterCityController({required this.homeRepo, required this.homeController});

  TextEditingController amountController = TextEditingController();
  TextEditingController passengerController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  double mainAmount = 0;
  String email = "";
  bool isLoading = true;
  String username = "";
  String siteName = "";
  String imagePath = "";
  String defaultCurrency = "";
  String currentAddress = "${MyStrings.loading}...";
  String defaultCurrencySymbol = "";
  Position? currentPosition;

  clearData() {
    email = "";
    isLoading = true;
    username = "";
    siteName = "";
    imagePath = "";
    defaultCurrency = "";
    currentAddress = "${MyStrings.loading}...";
    defaultCurrencySymbol = "";
    currentPosition;
    mainAmount = 0;
    user = GlobalUser(id: '-1');
    appServices = [];
    paymentMethodList = [];
    rideFare = RideFareModel(status: '-1');
    selectedService = AppService(id: '-99');
    selectedDateTime = DateTime.now();
    passengerController.text = '';
    amountController.text = '';
    noteController.text = '';
    update();
  }

  // GeneralSettingResponseModel generalSettingResponseModel = GeneralSettingResponseModel();
  Future<void> initialData({bool shouldLoad = true}) async {
    clearData();
    // generalSettingResponseModel = homeRepo.apiClient.getGSData();
    // siteName = generalSettingResponseModel.data?.generalSetting?.siteName ?? "";
    isLoading = shouldLoad ? true : false;
    defaultCurrency = homeRepo.apiClient.getCurrencyOrUsername();
    username = homeRepo.apiClient.getCurrencyOrUsername(isCurrency: false);
    email = homeRepo.apiClient.getUserEmail();
    defaultCurrencySymbol =
        homeRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    getCurrentLocation();
    loadData();
    isLoading = false;
    update();
  }

  GlobalUser user = GlobalUser(id: '-1');
  List<AppService> appServices = [];
  List<AppPaymentMethod> paymentMethodList = [];

  Future<void> loadData() async {
    clearData();
    isLoading = true;
    update();
    try {
      ResponseModel responseModel = await homeRepo.getData();
      if (responseModel.statusCode == 200) {
        DashBoardResponseModel model = DashBoardResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          appServices.clear();
          appServices = model.data?.services ?? [];

          paymentMethodList.clear();
          paymentMethodList = model.data?.paymentMethod ?? [];

          user = model.data?.userInfo ?? GlobalUser(id: '-1');
          update();
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  bool isSubmitLoading = false;
  Future<void> createRide() async {
    isSubmitLoading = true;
    update();
    try {
      ResponseModel responseModel = await homeRepo.createRide(
        data: CreateRideRequestModel(
          serviceId: selectedService.id!,
          pickUpLocation: homeController.selectedLocations[0].city.toString(),
          pickUpLatitude:
              homeController.selectedLocations[0].latitude.toString(),
          pickUpLongitude:
              homeController.selectedLocations[0].longitude.toString(),
          destination: homeController.selectedLocations[1].city.toString(),
          destinationLatitude:
              homeController.selectedLocations[1].latitude.toString(),
          destinationLongitude:
              homeController.selectedLocations[1].longitude.toString(),
          isIntercity: '1',
          pickUpDateTime: DateConverter.formatDate(selectedDateTime),
          numberOfPassenger: '5',
          note: 'note ',
          offerAmount: mainAmount.toString(),
          paymentType: '1',
          gatewayCurrencyId: selectedPaymentMethod.id!,
        ),
      );
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          printx(model.remark);
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    } finally {
      isSubmitLoading = false;
      update();
    }
  }

  RideFareModel rideFare = RideFareModel(status: '-1');
  Future<void> getRideFare() async {
    try {
      ResponseModel responseModel = await homeRepo.getRideFare(
        data: CreateRideRequestModel(
          serviceId: selectedService.id!,
          pickUpLocation: homeController.selectedLocations[0].city.toString(),
          pickUpLatitude:
              homeController.selectedLocations[0].latitude.toString(),
          pickUpLongitude:
              homeController.selectedLocations[0].longitude.toString(),
          destination: homeController.selectedLocations[1].city.toString(),
          destinationLatitude:
              homeController.selectedLocations[1].latitude.toString(),
          destinationLongitude:
              homeController.selectedLocations[1].longitude.toString(),
          isIntercity: '1',
          pickUpDateTime: '',
          numberOfPassenger: '',
          note: '',
          offerAmount: '',
          paymentType: '',
          gatewayCurrencyId: '',
        ),
      );
      if (responseModel.statusCode == 200) {
        RideFareResponseModel model = RideFareResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          printx(model.remark);
          rideFare = model.data ?? RideFareModel(status: '-1');
          mainAmount = double.tryParse(rideFare.minAmount.toString()) ?? 0.0;
          update();
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }
  }

//changed access user location before controller initialize
  Future<void> getCurrentLocation() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      currentPosition = await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      currentAddress = "";
      currentAddress =
          "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare},${placemarks[0].subLocality},${placemarks[0].locality},${placemarks[0].country}";
      update();
    } catch (e) {
      printx("Error>>>>>>>: $e");
      CustomSnackBar.error(errorList: [MyStrings.errorLocation]);
    }
  }

  updateMainAmount(double amount) {
    mainAmount = amount;
    update();
  }

  addMainAmount(double amount) {
    mainAmount += amount;
    update();
  }

  removeMainAmount(double amount) {
    if (mainAmount > 0) {
      mainAmount -= amount;
      update();
    }
  }

  AppPaymentMethod selectedPaymentMethod = AppPaymentMethod(id: '-99');
  selectPaymentMethod(AppPaymentMethod method) {
    printx(method.id);
    selectedPaymentMethod = method;
    update();
    Get.back();
  }

  AppService selectedService = AppService(id: '-99');
  selectService(AppService service) {
    // check selectedLocations lenght >1
    // select service and hit for ride fare
    if (homeController.selectedLocations.length > 1) {
      selectedService = service;
      update();
      getRideFare();
    } else {
      CustomSnackBar.error(
          errorList: [MyStrings.pleaseSelectYourPickupAndDestinationLocation]);
    }
  }

  DateTime selectedDateTime = DateTime.now();
  selectDateTime(DateTime dateOrTime) {
    selectedDateTime = dateOrTime;
    update();
  }

  //
  bool isValidForNewRide() {
    if (homeController.selectedLocations.isEmpty) {
      return false;
    } else if (selectedService.id == "-99") {
      return false;
    } else if (selectedPaymentMethod.id == "-99") {
      return false;
    } else if (passengerController.text.isEmpty) {
      return false;
    } else if (noteController.text.isEmpty) {
      return false;
    }
    return true;
  }
}
