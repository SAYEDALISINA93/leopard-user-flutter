import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/auth/login/login_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/socail_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SocialAuthController extends GetxController {
  SocialAuthRepo authRepo;
  SocialAuthController({required this.authRepo});
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isGoogleSignInLoading = false;
  Future<void> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      update();
      googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isGoogleSignInLoading = false;
        update();
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      await socialLoginUser(
          provider: 'google', accessToken: googleAuth.accessToken ?? '');
    } catch (e) {
      printx(e.toString());
      CustomSnackBar.error(errorList: [e.toString()]);
    }

    isGoogleSignInLoading = false;
    update();
  }

  bool facebookLoginLoading = false;
  Future<void> signInWithFacebook() async {}

  //SIGN IN With LinkeDin
  bool isLinkedinLoading = false;
  Future<void> signInWithLinkedin(BuildContext context) async {}

//
  Future socialLoginUser({
    String accessToken = '',
    String? provider,
  }) async {
    try {
      ResponseModel responseModel = await authRepo.socialLoginUser(
        accessToken: accessToken,
        provider: provider,
      );
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel =
            LoginResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (loginModel.status.toString().toLowerCase() ==
            MyStrings.success.toLowerCase()) {
          RouteMiddleware.checkNGotoNext(
            user: loginModel.data?.user,
            accessToken: loginModel.data?.accessToken ?? '',
            tokenType: loginModel.data?.tokenType ?? '',
          );
        } else {
          CustomSnackBar.error(
              errorList:
                  loginModel.message ?? [MyStrings.loginFailedTryAgain.tr]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e.toString());
    }
  }
}
