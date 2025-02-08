import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/ride/complete_ride_response_model.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class CompleteRideController extends GetxController {
  RideRepo repo;
  CompleteRideController({required this.repo, required this.isInterCity});

  bool isLoading = false;

  TextEditingController reviewMsgController = TextEditingController();
  double rating = 0.0;

  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  int page = 0;
  bool isInterCity;
  Future<void> initialData() async {
    loggerX(isInterCity);
    page = 0;
    rating = 0.0;
    defaultCurrency = repo.apiClient.getCurrencyOrUsername();
    defaultCurrencySymbol =
        repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    username = repo.apiClient.getCurrencyOrUsername(isCurrency: false);
    completeRideList = [];
    isInterCity = isInterCity;
    update();
    await getCompleteRideList();
  }

  List<RideModel> completeRideList = [];
  String? nextPageUrl;
  Future<void> getCompleteRideList() async {
    page = page + 1;
    if (page == 1) {
      completeRideList.clear();
      isLoading = true;
      update();
    }

    try {
      ResponseModel responseModel = await repo.getRideList(
          page: page.toString(),
          status: "1",
          rideType: isInterCity ? "1" : "2");
      if (responseModel.statusCode == 200) {
        CompleteRideResponseModel model = CompleteRideResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          printX(model.status);
          nextPageUrl = model.data?.completedRides?.nextPageUrl;
          completeRideList.addAll(model.data?.completedRides?.data ?? []);
          update();
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isLoading = false;
    update();
  }

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
          printX(model.status);
          reviewMsgController.text = '';
          rating = 0.0;
          page = 0;
          update();
          getCompleteRideList();
          Get.back();
          CustomSnackBar.success(successList: model.message ?? []);
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isReviewLoading = false;
    update();
  }

  void updateRating(double rate) {
    rating = rate;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null &&
            nextPageUrl!.isNotEmpty &&
            nextPageUrl != 'null'
        ? true
        : false;
  }
}
