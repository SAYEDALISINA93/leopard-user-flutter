import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/auth/login/login_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class LoginController extends GetxController {
  LoginRepo loginRepo;
  LoginController({required this.loginRepo});

  final FocusNode mobileNumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  List<String> errors = [];
  bool remember = true;

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgotPasswordScreen);
  }

  void checkAndGotoNextStep(LoginResponseModel responseModel) async {
    // printx('responseModel.data?.user?.tv ${responseModel.data?.user?.tv}');
    bool needEmailVerification =
        responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification =
        responseModel.data?.user?.sv == '1' ? false : true;

    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userIdKey,
      responseModel.data?.user?.id.toString() ?? '-1',
    );
    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.accessTokenKey,
      responseModel.data?.accessToken ?? '',
    );
    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.accessTokenType,
      responseModel.data?.tokenType ?? '',
    );
    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userEmailKey,
      responseModel.data?.user?.email ?? '',
    );
    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userPhoneNumberKey,
      responseModel.data?.user?.mobile ?? '',
    );
    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userNameKey,
      responseModel.data?.user?.username ?? '',
    );

    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userProfileKey,
      responseModel.data?.user?.imageWithPath ?? '',
    );
    await loginRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userFullNameKey,
      '${responseModel.data?.user?.firstname} ${responseModel.data?.user?.lastname}',
    );

    await loginRepo.sendUserToken();
    bool needProfileCompleted =
        responseModel.data?.user?.profileComplete.toString() == '0'
            ? true
            : responseModel.data?.user?.profileComplete.toString() == 'null'
                ? true
                : false;
    printX('responseModel.data?.user?.SmsV ${responseModel.data?.user?.sv}');
    printX(
      'responseModel.data?.user?.profileCompleted ${responseModel.data?.user?.profileComplete}',
    );

    if (needSmsVerification == false && needEmailVerification == false) {
      if (needProfileCompleted) {
        Get.offAndToNamed(RouteHelper.profileCompleteScreen);
      } else {
        if (remember) {
          await loginRepo.apiClient.sharedPreferences.setBool(
            SharedPreferenceHelper.rememberMeKey,
            true,
          );
        } else {
          await loginRepo.apiClient.sharedPreferences.setBool(
            SharedPreferenceHelper.rememberMeKey,
            false,
          );
        }
        Get.offAndToNamed(RouteHelper.dashboard);
      }
    } else if (needSmsVerification == true && needEmailVerification == true) {
      Get.offAndToNamed(
        RouteHelper.emailVerificationScreen,
        arguments: [true, needProfileCompleted, false],
      );
    } else if (needSmsVerification == true && needEmailVerification == true) {
      Get.offAndToNamed(
        RouteHelper.emailVerificationScreen,
        arguments: [true, needProfileCompleted, false],
      );
    } else if (needSmsVerification) {
      Get.offAndToNamed(
        RouteHelper.smsVerificationScreen,
        arguments: [needProfileCompleted, false],
      );
    } else if (needEmailVerification) {
      Get.offAndToNamed(
        RouteHelper.emailVerificationScreen,
        arguments: [false, needProfileCompleted, false],
      );
    }

    if (remember) {
      changeRememberMe();
    }
  }

  Future<bool> checkUserHasAccount(
      String phoneNumber, String countryCode) async {
    ResponseModel responseModel =
        await loginRepo.checkUserHasAccount(phoneNumber, countryCode);
    if (responseModel.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (loginModel.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        return true;
      } else {
        CustomSnackBar.error(
            errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain]);
        return false;
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
      return false;
    }
  }

  bool isSubmitLoading = false;
  String countryCode = '93';
  void loginUser() async {
    isSubmitLoading = true;
    update();

// First Check if the user has an account or not
    if (await checkUserHasAccount(
            mobileNumberController.text.toString(), countryCode) ==
        true) {
      // Call Firebase phone authentication
      String formattedPhoneNumber = mobileNumberController.text
              .toString()
              .startsWith('+')
          ? mobileNumberController.text.toString()
          : '+$countryCode${mobileNumberController.text.toString()}'; // Ensure the phone number includes the country code

      print('formattedPhoneNumber: $formattedPhoneNumber');

      try {
        await verifyPhoneNumber(formattedPhoneNumber);
      } catch (e) {
        isSubmitLoading = false;
        update();
        CustomSnackBar.error(errorList: [e.toString()]);
      }
    } else {
      // User doesn't have an account
      isSubmitLoading = false;
      update();
    }

    // ResponseModel model = await loginRepo.loginUser(
    //     emailController.text.toString(), passwordController.text.toString());

    // if (model.statusCode == 200) {
    //   LoginResponseModel loginModel =
    //       LoginResponseModel.fromJson(jsonDecode(model.responseJson));
    //   if (loginModel.status.toString().toLowerCase() ==
    //       MyStrings.success.toLowerCase()) {
    //     // checkAndGotoNextStep(loginModel);
    //     await loginRepo.apiClient.sharedPreferences
    //         .setBool(SharedPreferenceHelper.rememberMeKey, remember);
    //     loggerI(loginModel.data?.toJson());
    //     RouteMiddleware.checkNGotoNext(
    //       accessToken: loginModel.data?.accessToken ?? '',
    //       tokenType: loginModel.data?.tokenType ?? '',
    //       user: loginModel.data?.user,
    //     );
    //   } else {
    //     CustomSnackBar.error(
    //         errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain]);
    //   }
    // } else {
    //   CustomSnackBar.error(errorList: [model.message]);
    // }
  }

  Future<void> verifyPhoneNumber(String formattedPhoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        isSubmitLoading = false;
        update();
      },
      verificationFailed: (FirebaseAuthException e) {
        isSubmitLoading = false;
        update();
        CustomSnackBar.error(
            errorList: [e.message ?? MyStrings.loginFailedTryAgain]);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent - keep loading until navigation completes
        isSubmitLoading = false;
        update();
        Get.toNamed(RouteHelper.smsVerificationScreen, arguments: [
          verificationId,
          mobileNumberController.text.toString(),
          countryCode
        ]);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        isSubmitLoading = false;
        update();
      },
    );
  }

  void changeRememberMe() {
    remember = !remember;
    update();
  }

  void clearTextField() {
    passwordController.text = '';
    emailController.text = '';

    if (remember) {
      remember = false;
    }
    update();
  }
}
