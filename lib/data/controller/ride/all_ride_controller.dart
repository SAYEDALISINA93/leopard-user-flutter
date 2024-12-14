import 'dart:convert';

import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/ride/all_ride_response_model.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class AllRideController extends GetxController {
  RideRepo repo;
  bool isCity;
  AllRideController({required this.repo, required this.isCity});

  bool isLoading = false;
  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  int page = 0;

  Future<void> initialData() async {
    page = 0;
    defaultCurrency = repo.apiClient.getCurrencyOrUsername();
    defaultCurrencySymbol =
        repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    username = repo.apiClient.getCurrencyOrUsername(isCurrency: false);
    rideList = [];
    update();
    await getAllRide();
  }

  List<RideModel> rideList = [];
  String? nextPageUrl;
  Future<void> getAllRide() async {
    page = page + 1;
    if (page == 1) {
      rideList.clear();
      isLoading = true;
      update();
    }

    try {
      ResponseModel responseModel = await repo.getRideList(
          page: page.toString(), rideType: isCity ? "1" : "2", status: '');
      if (responseModel.statusCode == 200) {
        AllResponseModel model =
            AllResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          printx(model.status);
          nextPageUrl = model.data?.rides?.nextPageUrl;
          rideList.addAll(model.data?.rides?.data ?? []);
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
    isLoading = false;
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
