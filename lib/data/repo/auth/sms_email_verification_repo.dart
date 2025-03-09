import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SmsEmailVerificationRepo {
  ApiClient apiClient;

  SmsEmailVerificationRepo({required this.apiClient});

  Future<ResponseModel> verify(String code,
      {bool isEmail = true, bool isTFA = false}) async {
    final map = {
      'code': code,
    };
    String url =
        '${UrlContainer.baseUrl}${isEmail ? UrlContainer.verifyEmailEndPoint : UrlContainer.verifySmsEndPoint}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> verifyFirebase(
      String code, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        return ResponseModel(
          true,
          'Verification successful',
          200,
          jsonEncode({
            'message': 'Verification successful',
            'token': await userCredential.user!.getIdToken(),
          }),
        );
      } else {
        return ResponseModel(
          false,
          'Verification failed',
          400,
          jsonEncode({'message': 'Verification failed'}),
        );
      }
    } catch (e) {
      return ResponseModel(
        false,
        e.toString(),
        400,
        jsonEncode({'message': e.toString()}),
      );
    }
  }

  Future<bool> sendAuthorizationRequest() async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.authorizationCodeEndPoint}';
    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (response.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status == 'error') {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong]);
        return false;
      }

      return true;
    } else {
      CustomSnackBar.error(errorList: [response.message]);
      return false;
    }
  }

  Future<bool> resendVerifyCode({required bool isEmail}) async {
    final url =
        '${UrlContainer.baseUrl}${UrlContainer.resendVerifyCodeEndPoint}${isEmail ? 'email' : 'mobile'}';
    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (response.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));

      if (model.status == 'error') {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.resendCodeFail]);
        return false;
      } else {
        CustomSnackBar.success(
            successList: model.message ?? [MyStrings.successfullyCodeResend]);
        return true;
      }
    } else {
      return false;
    }
  }
}
