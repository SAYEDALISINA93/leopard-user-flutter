import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/map/ride_map_controller.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/bid/bid_list_response_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/bid/bid_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/ride/ride_details_response_model.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class RideDetailsController extends GetxController {
  RideRepo repo;
  RideMapController mapController;
  RideDetailsController({required this.repo, required this.mapController});

  RideModel ride = RideModel(id: '-1');
  String currency = '';
  String currencySym = '';
  bool isLoading = true;
  bool isPaymentRequested = false;
  LatLng pickupLatLng = const LatLng(0, 0);
  LatLng destinationLatLng = const LatLng(0, 0);
  String rideId = '-1';
  String serviceImagePath = '';
  String brandImagePath = '';
  String driverImagePath = '';

  updatePaymentRequested() {
    isPaymentRequested = true;
    update();
  }

  updateRide(RideModel updatedRide) {
    ride = updatedRide;
    update();
    loggerX('Updated ride: $ride');
  }

  //
  void initialData(String id) async {
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    rideId = id;
    totalBids = 0;
    bids = [];
    cancelReasonController.text = '';
    isLoading = true;
    isPaymentRequested = false;
    update();
    await getRideDetails(id);
    await getRideBidList(id);
    isLoading = false;
    update();
  }

  //ride
  Future<void> getRideDetails(String id, {bool shouldLoading = true}) async {
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    rideId = id;

    bids = [];
    isLoading = shouldLoading;
    update();

    ResponseModel responseModel = await repo.getRideDetails(id);
    if (responseModel.statusCode == 200) {
      RideDetailsResponseModel model = RideDetailsResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status == MyStrings.success) {
        RideModel? tempRide = model.data?.ride;
        if (tempRide != null) {
          ride = tempRide;
          pickupLatLng = LatLng(
              Converter.formatDouble(tempRide.pickupLatitude.toString()),
              Converter.formatDouble(tempRide.pickupLongitude.toString()));
          destinationLatLng = LatLng(
              Converter.formatDouble(tempRide.destinationLatitude.toString()),
              Converter.formatDouble(tempRide.destinationLongitude.toString()));
        }
        serviceImagePath =
            '${UrlContainer.domainUrl}/${model.data?.serviceImagePath ?? ''}';
        brandImagePath =
            '${UrlContainer.domainUrl}/${model.data?.brandImagePath ?? ''}';
        driverImagePath =
            '${UrlContainer.domainUrl}/${model.data?.driverImagePath}';
        loggerX('Service image path : ${model.data?.serviceImagePath}');
        loggerX('Brand image path : ${model.data?.brandImagePath}');
        loggerX('User image path : ${model.data?.driverImagePath}');
        update();
        mapController.loadMap(
            pickup: pickupLatLng,
            destination: destinationLatLng,
            isRunning: ride.status == "3");
      } else {
        Get.back();
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  //bid
  List<BidModel> bids = [];
  List<BidModel> tempBids = [];
  int totalBids = 0;
  Future<void> getRideBidList(String id) async {
    isLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.getRideBidList(id: id);
      if (responseModel.statusCode == 200) {
        BidListResponseModel model = BidListResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          bids = model.data?.bids ?? [];
          totalBids = bids.length;
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [""]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }
    isLoading = false;
    update();
  }

  void updateTempBid({required BidModel bid, bool isRemoved = false}) {
    if (isRemoved) {
      tempBids.remove(bid);
    } else {
      tempBids.add(bid);
    }
    update();
  }

  updateBidCount(bool remove) {
    if (totalBids > 0 && remove) {
      totalBids--;
    } else {
      totalBids++;
    }
    update();
    printx('update total bids $totalBids');
  }

  Future<void> acceptBid(String id) async {
    try {
      ResponseModel responseModel = await repo.acceptBid(bidId: id);
      if (responseModel.statusCode == 200) {
        RideDetailsResponseModel model = RideDetailsResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          if (model.data != null && model.data!.ride != null) {
            updateRide(model.data!.ride!);
          }
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

    update();
  }

  //sos
  TextEditingController sosMsgController = TextEditingController();
  bool isSosLoading = false;
  Future<void> sos(String id) async {
    isSosLoading = true;

    update();
    Position position = await MyUtils.getCurrentPosition();
    try {
      ResponseModel responseModel = await repo.sos(
        id: ride.id ?? "-1",
        msg: sosMsgController.text,
        latLng: LatLng(position.latitude, position.longitude),
      );
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          sosMsgController.text = '';
          update();
          CustomSnackBar.success(successList: model.message ?? ["Success"]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? ["Error"]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }

    isSosLoading = false;
    update();
  }

  //cancel

  bool isCancelLoading = false;
  TextEditingController cancelReasonController = TextEditingController();
  Future<void> cancelRide() async {
    isCancelLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.cancelRide(
          id: ride.id ?? "-1", reason: cancelReasonController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          Get.offAllNamed(RouteHelper.dashboard);
          CustomSnackBar.success(successList: model.message ?? ["Success"]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? ["Error"]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }
    isCancelLoading = false;
    update();
  }

  //review
  double rating = 0.0;
  TextEditingController reviewMsgController = TextEditingController();
  bool isReviewLoading = false;
  Future<void> reviewRide(String rideId) async {
    isReviewLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.reviewRide(
          rideId: rideId,
          rating: rating.toString(),
          review: reviewMsgController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));

        if (model.status == MyStrings.success) {
          printx(model.status);
          reviewMsgController.text = '';
          rating = 0.0;
          update();
          Get.offAllNamed(RouteHelper.dashboard);
          CustomSnackBar.success(successList: model.message ?? []);
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
    isReviewLoading = false;
    update();
  }

  void updateRating(double rate) {
    rating = rate;
    update();
  }
}
