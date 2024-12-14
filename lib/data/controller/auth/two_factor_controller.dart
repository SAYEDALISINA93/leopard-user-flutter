import 'dart:convert';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/two_factor_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class TwoFactorController extends GetxController {
  TwoFactorRepo repo;
  TwoFactorController({required this.repo});

  bool submitLoading = false;
  String currentText = '';

  bool isProfileCompleteEnable = false;

  verifyYourSms(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.verify(currentText);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));

      if (model.status == MyStrings.success) {
        CustomSnackBar.success(
            successList: model.message ?? [MyStrings.requestSuccess]);
        Get.offAndToNamed(isProfileCompleteEnable
            ? RouteHelper.profileCompleteScreen
            : RouteHelper.dashboard);
      } else {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }
}
