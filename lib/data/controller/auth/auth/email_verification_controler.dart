import 'dart:async';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class EmailVerificationController extends GetxController {
  SmsEmailVerificationRepo repo;
  EmailVerificationController({required this.repo});

  bool needSmsVerification = false;
  bool isProfileCompleteEnable = false;

  String currentText = "";
  String userEmail = "";

  bool needTwoFactor = false;
  bool submitLoading = false;
  bool isLoading = true;
  bool resendLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    userEmail = repo.apiClient.getUserEmail();
    update();
    await repo.sendAuthorizationRequest();
    isLoading = false;
    update();
  }

  Future<void> verifyEmail(String text) async {
    if (text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.verify(text);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson((responseModel.responseJson));

      if (model.status == MyStrings.success) {
        CustomSnackBar.success(
          successList: model.message ?? [(MyStrings.emailVerificationSuccess)],
        );
        RouteMiddleware.checkNGotoNext(user: model.data?.user);
      } else {
        CustomSnackBar.error(
          errorList: model.message ?? [(MyStrings.emailVerificationFailed)],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    submitLoading = false;
    update();
  }

  Future<void> sendCodeAgain() async {
    resendLoading = true;
    update();
    await repo.resendVerifyCode(isEmail: true);
    resendLoading = false;
    update();
  }
}
