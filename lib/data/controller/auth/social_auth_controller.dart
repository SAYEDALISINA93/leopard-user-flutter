import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/auth/login/login_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/socail_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthController extends GetxController {
  SocialAuthRepo authRepo;
  SocialAuthController({required this.authRepo});

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );
  bool isGoogleSignInLoading = false;
  Future<void> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      update();

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        return;
      }

      final String token = googleAuth.accessToken ?? googleAuth.idToken ?? '';

      printX(token);

      await socialLoginUser(
        provider: 'google',
        accessToken: token,
      );
    } catch (e) {
      printX(e.toString());
      // CustomSnackBar.error(errorList: [e.toString()]);
    } finally {
      isGoogleSignInLoading = false;
      update();
    }
  }

  bool isAppleSignInLoading = false;
  Future signInWithApple() async {
    isAppleSignInLoading = true;
    update();
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      printX(credential.email);
      printX(credential.givenName);
      printX(credential.familyName);
      printX(credential.authorizationCode);
      printX(credential.identityToken);
      socialLoginUser(
        provider: 'apple',
        accessToken: credential.identityToken ?? '',
      );
    } catch (e) {
      printX(e.toString());
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    } finally {
      isAppleSignInLoading = false;
      update();
    }
  }

  Future socialLoginUser({String accessToken = '', String? provider}) async {
    try {
      ResponseModel responseModel = await authRepo.socialLoginUser(
        accessToken: accessToken,
        provider: provider,
      );
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel =
            LoginResponseModel.fromJson((responseModel.responseJson));
        if (loginModel.status.toString().toLowerCase() ==
            MyStrings.success.toLowerCase()) {
          RouteMiddleware.checkNGotoNext(
            user: loginModel.data?.user,
            accessToken: loginModel.data?.accessToken ?? '',
            tokenType: loginModel.data?.tokenType ?? '',
          );
        } else {
          CustomSnackBar.error(
            errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain.tr],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e.toString());
    }
  }
}
