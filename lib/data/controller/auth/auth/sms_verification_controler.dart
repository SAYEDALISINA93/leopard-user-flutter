import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/auth/login/login_response_model.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SmsVerificationController extends GetxController {
  // SmsEmailVerificationRepo repo;
  // SmsVerificationController({required this.repo});

  LoginRepo repo;
  SmsVerificationController({required this.repo});

  bool hasError = false;
  bool isLoading = true;
  String currentText = '';
  String userPhone = '';
  String userCompletePhone = '';
  bool isProfileCompleteEnable = false;
  String countryCode = '';
  String verificationId = '';
  String verificationToken = '';

  Future<void> loadBefore() async {
    isLoading = true;
    // userPhone = repo.apiClient.sharedPreferences
    //         .getString(SharedPreferenceHelper.userPhoneNumberKey) ??
    //     '';

    userCompletePhone = '+${countryCode + userPhone}';

    print("User Phone: $userPhone ");
    update();
    // await repo.sendAuthorizationRequest();
    isLoading = false;
    update();
    return;
  }

  bool submitLoading = false;
  verifyYourSms(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg.tr]);
      return;
    }

    submitLoading = true;
    update();

    // ResponseModel responseModel =
    //     await repo.verify(currentText, isEmail: false, isTFA: false);

    // if (responseModel.statusCode == 200) {
    //   AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
    //       jsonDecode(responseModel.responseJson));

    //   if (model.status == MyStrings.success) {
    //     CustomSnackBar.success(
    //         successList: model.message ??
    //             ['${MyStrings.sms.tr} ${MyStrings.verificationSuccess.tr}']);
    //     RouteMiddleware.checkNGotoNext(user: model.data?.user);
    //     // Get.offAndToNamed(isProfileCompleteEnable ? RouteHelper.profileCompleteScreen : RouteHelper.dashboard);
    //   } else {
    //     CustomSnackBar.error(
    //         errorList: model.message ??
    //             ['${MyStrings.sms.tr} ${MyStrings.verificationFailed}']);
    //   }
    // } else {
    //   CustomSnackBar.error(errorList: [responseModel.message]);
    // }

    // Verify Firebase OTP
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userCompletePhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        CustomSnackBar.success(successList: [
          '${MyStrings.sms.tr} ${MyStrings.verificationSuccess.tr}'
        ]);
        // RouteMiddleware.checkNGotoNext();
        callLoginApi();
      },
      verificationFailed: (FirebaseAuthException e) {
        CustomSnackBar.error(
            errorList: ['${MyStrings.sms.tr} ${MyStrings.verificationFailed}']);
      },
      codeSent: (String verificationId, int? resendToken) async {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: currentText);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential);
        verificationToken = await userCredential.user?.getIdToken() ?? '';
        CustomSnackBar.success(successList: [
          '${MyStrings.sms.tr} ${MyStrings.verificationSuccess.tr}'
        ]);
        // RouteMiddleware.checkNGotoNext();
        callLoginApi();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    submitLoading = false;
    update();
  }

  Future<void> callLoginApi() async {
    ResponseModel model =
        await repo.loginWithPhone(userPhone, countryCode, verificationToken);

    if (model.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(jsonDecode(model.responseJson));

      print("Login Model: ${model.responseJson}");
      if (loginModel.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        // checkAndGotoNextStep(loginModel);
        await repo.apiClient.sharedPreferences
            .setBool(SharedPreferenceHelper.rememberMeKey, true);
        loggerI(loginModel.data?.toJson());
        RouteMiddleware.checkNGotoNext(
          accessToken: loginModel.data?.accessToken ?? '',
          tokenType: loginModel.data?.tokenType ?? '',
          user: loginModel.data?.user,
        );
      } else {
        CustomSnackBar.error(
            errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain]);
      }
    } else {
      CustomSnackBar.error(errorList: [model.message]);
    }
  }

  bool resendLoading = false;
  Future<void> sendCodeAgain() async {
    // resendLoading = true;
    // update();
    // await repo.resendVerifyCode(isEmail: false);
    // resendLoading = false;
    // update();
  }
}
