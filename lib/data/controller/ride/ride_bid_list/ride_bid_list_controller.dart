import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/bid/bid_list_response_model.dart';
import 'package:leoparduser/data/model/global/bid/bid_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class RideBidListController extends GetxController {
  RideRepo repo;
  RideBidListController({required this.repo});

  bool isLoading = false;
  TextEditingController cancelReasonController = TextEditingController();
  String userImagePath = "";
  String driverImagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  String rideId = "";

  Future<void> initialData(String id) async {
    defaultCurrency = repo.apiClient.getCurrency();
    defaultCurrencySymbol = repo.apiClient.getCurrency(isSymbol: true);
    username = repo.apiClient.getUserName();
    rideId = id;
    update();
    getRideBidList(id);
  }

  List<BidModel> bids = [];
  RideModel ride = RideModel(id: "-1");
  Future<void> getRideBidList(String id, {bool isShouldLoading = true}) async {
    isLoading = isShouldLoading;
    update();
    try {
      ResponseModel responseModel = await repo.getRideBidList(id: id);
      if (responseModel.statusCode == 200) {
        BidListResponseModel model =
            BidListResponseModel.fromJson((responseModel.responseJson));
        userImagePath =
            '${UrlContainer.domainUrl}/${model.data?.userImagePath}/';
        driverImagePath =
            '${UrlContainer.domainUrl}/${model.data?.driverImagePath}/';
        if (model.status == "success") {
          bids = model.data?.bids ?? [];
          ride = model.data?.ride ?? RideModel(id: "-1");
          update();
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
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

  bool isAcceptLoading = false;
  String selectedId = '-1';
  Future<void> acceptBid(String id, String rideId) async {
    isAcceptLoading = true;
    selectedId = id;
    update();
    try {
      ResponseModel responseModel = await repo.acceptBid(bidId: id);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          Get.toNamed(RouteHelper.rideDetailsScreen, arguments: rideId);
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    selectedId = '-1';
    isAcceptLoading = false;
    update();
  }

  bool isRejectLoading = false;

  Future<void> rejectBid(String id) async {
    isRejectLoading = true;
    selectedId = id;
    update();
    try {
      ResponseModel responseModel = await repo.rejectBid(id: id);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          bids = [];
          update();
          getRideBidList(rideId);
          CustomSnackBar.success(successList: model.message ?? ["Success"]);
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isRejectLoading = false;
    selectedId = '-1';
    update();
  }

  bool isCancelLoading = false;
  Future<void> cancelRide() async {
    isCancelLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.cancelRide(
        id: ride.id ?? "-1",
        reason: cancelReasonController.text,
      );
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson((responseModel.responseJson));
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
      printX(e);
    }
    isCancelLoading = false;
    update();
  }
}
