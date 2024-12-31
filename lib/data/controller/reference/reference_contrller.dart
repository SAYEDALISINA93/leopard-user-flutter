import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';
import 'package:leoparduser/data/model/refer/reference_response_model.dart';
import 'package:leoparduser/data/repo/refer/reference_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class ReferenceController extends GetxController {
  ReferenceRepo repo;
  ReferenceController({required this.repo});

  bool isLoading = false;
  String currency = "";
  String currencySym = "";

  List<ReferenceUser> referUsers = [];
  GlobalUser user = GlobalUser();

  Future<void> getReferData() async {
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.getReferData();
      if (responseModel.statusCode == 200) {
        ReferenceResponseModel model = ReferenceResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          user = model.data?.user ?? GlobalUser();
          referUsers.clear();
          referUsers = model.data?.referenceUsers ?? [];
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

  Future<void> shareImage() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    await Share.share(
      (user.username ?? '').toUpperCase(),
      subject: MyStrings.share.tr,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
