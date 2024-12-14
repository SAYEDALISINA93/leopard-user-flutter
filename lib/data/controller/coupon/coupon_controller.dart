import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/app/app_coupon_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/coupon/coupon_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class CouponController extends GetxController {
  CouponRepo couponRepo;
  String rideId;
  CouponController({required this.couponRepo, required this.rideId});

  bool isLoading = false;
  bool isApplyLoading = false;
  List<CouponModel> couponList = [];
  TextEditingController applyTextController = TextEditingController();
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String applyCouponId = "-1";

  CouponModel selectedCoupon = CouponModel(id: '-1');

  updateCoupon(CouponModel existingCoupon) {
    selectedCoupon = existingCoupon;
    update();
  }

  Future<void> getCouponList(List<CouponModel> list) async {
    isLoading = true;
    applyCouponId = "-1";
    selectedCoupon = CouponModel(id: '-1');
    couponList.clear();
    defaultCurrency = couponRepo.apiClient.getCurrencyOrUsername();
    defaultCurrencySymbol =
        couponRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    update();
    couponList.addAll(list);
    isLoading = false;
    update();
  }

  Future<void> applyCoupon(CouponModel coupon) async {
    applyCouponId = coupon.id.toString();
    update();
    printx(coupon.code);
    try {
      ResponseModel responseModel = await couponRepo.applyCoupon(
        code: coupon.code.toString(),
        rideId: rideId,
      );
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          selectedCoupon = coupon;
          update();

          Get.back();
          CustomSnackBar.success(
              successList: model.message ?? [MyStrings.succeed]);
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

  Future<void> apply() async {
    applyCouponId = '-1';
    selectedCoupon = CouponModel(id: '-1');
    isApplyLoading = true;
    update();

    try {
      ResponseModel responseModel = await couponRepo.applyCoupon(
        code: applyTextController.text,
        rideId: rideId,
      );
      if (responseModel.statusCode == 200) {
        //changed: need coupon from response
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          Get.back();
          CustomSnackBar.success(
              successList: model.message ?? [MyStrings.succeed]);
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
    isApplyLoading = false;
    update();
  }

  Future<void> removeCoupon(CouponModel coupon) async {
    try {
      ResponseModel responseModel = await couponRepo.removeCoupon(
          code: coupon.code.toString(), rideId: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          selectedCoupon = CouponModel(id: '-1');

          CustomSnackBar.success(
              successList: model.message ?? [MyStrings.succeed]);
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

  ///
}
