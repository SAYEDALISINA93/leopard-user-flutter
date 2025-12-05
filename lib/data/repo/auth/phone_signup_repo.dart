import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/auth/sign_up_model/registration_response_model.dart';
import 'package:leoparduser/data/model/auth/sign_up_model/sign_up_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/core/utils/my_strings.dart';

class PhoneRegistrationRepo {
  ApiClient apiClient;

  PhoneRegistrationRepo({required this.apiClient});

  Future<RegistrationResponseModel> registerUser(SignUpModel model) async {
    final map = modelToMap(model);
    String url = '${UrlContainer.baseUrl}${UrlContainer.registrationEndPoint}';
    final res = await apiClient.request(url, Method.postMethod, map,
        passHeader: true, isOnlyAcceptType: true);
    final json = res.responseJson;
    RegistrationResponseModel responseModel =
        RegistrationResponseModel.fromJson(json);
    return responseModel;
  }

  Map<String, dynamic> modelToMap(SignUpModel model) {
    Map<String, dynamic> bodyFields = {
      'firstname': model.fName,
      'lastname': model.lName,
      'mobile': model.mobile,
      'country_code': '93',
      'agree': model.agree.toString() == 'true' ? 'true' : '',
      'firebase_uid': model.firebaseToken,
      'password_confirmation': model.password,
    };
    if (model.referName != null && model.referName!.isNotEmpty) {
      bodyFields['refer_name'] = model.referName;
    }
    return bodyFields;
  }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }

  Future<bool> sendUserToken() async {
    String deviceToken;
    if (apiClient.sharedPreferences
        .containsKey(SharedPreferenceHelper.fcmDeviceKey)) {
      deviceToken = apiClient.sharedPreferences
              .getString(SharedPreferenceHelper.fcmDeviceKey) ??
          '';
    } else {
      deviceToken = '';
    }

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    bool success = false;
    if (deviceToken.isEmpty) {
      firebaseMessaging.getToken().then((fcmDeviceToken) async {
        success = await sendUpdatedToken(fcmDeviceToken ?? '');
      });
    } else {
      firebaseMessaging.onTokenRefresh.listen((fcmDeviceToken) async {
        if (deviceToken == fcmDeviceToken) {
          success = true;
        } else {
          apiClient.sharedPreferences
              .setString(SharedPreferenceHelper.fcmDeviceKey, fcmDeviceToken);
          success = await sendUpdatedToken(fcmDeviceToken);
        }
      });
    }
    return success;
  }

  Future<bool> sendUpdatedToken(String deviceToken) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deviceTokenEndPoint}';
    Map<String, String> map = deviceTokenMap(deviceToken);

    await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return true;
  }

  Map<String, String> deviceTokenMap(String deviceToken) {
    Map<String, String> map = {'token': deviceToken.toString()};
    return map;
  }

  Future<ResponseModel> socialLoginUser({
    String accessToken = '',
    String? provider,
  }) async {
    Map<String, String>? map;

    if (provider == 'google') {
      map = {'token': accessToken, 'provider': "google"};
    }

    String url = '${UrlContainer.baseUrl}${UrlContainer.socialLoginEndPoint}';

    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: false);

    return model;
  }

  Future<ResponseModel> checkUserHasAccount(
      String phoneNumber, countryCode) async {
    Map<String, String> map = {
      'phone_number': phoneNumber,
      'country_code': countryCode
    };

    String url = '${UrlContainer.baseUrl}${UrlContainer.checkUserHasAccount}';

    ResponseModel model =
        await apiClient.request(url, Method.postMethod, map, passHeader: false);

    return model;
  }

  Future<Map<String, dynamic>?> handleRequestPhoneOTP(
      String mobileNumber, String countryCode) async {
    Map<String, dynamic>? result;
    Completer<Map<String, dynamic>?> completer = Completer();

    ResponseModel responseModel =
        await checkUserHasAccount(mobileNumber, countryCode);

    final responseJSON = responseModel.responseJson;
    print("RESPONSE AUTHL $responseJSON");

    if (responseJSON['status'] != 'error') {
      String errorMessage = MyStrings.phoneAlreadyRegistered;

      CustomSnackBar.error(errorList: [errorMessage]);
      result = {'status': false, 'message': errorMessage.toString()};
      completer.complete(result);
    } else {
      String formattedPhoneNumber = mobileNumber.startsWith('+')
          ? mobileNumber
          : '+$countryCode$mobileNumber';

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: formattedPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieval or instant verification
          },
          verificationFailed: (FirebaseAuthException e) {
            CustomSnackBar.error(
                errorList: [e.message ?? 'Login failed, please try again']);
            result = {'status': false};
            completer.complete(result);
          },
          codeSent: (String verificationId, int? resendToken) {
            result = {
              'status': true,
              'verificationId': verificationId,
            };
            completer.complete(result);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            result = {
              'status': false,
              'message': 'Timeout, please try again',
            };
            completer.complete(result);
          },
        );
      } catch (e) {
        CustomSnackBar.error(errorList: [e.toString()]);
        result = {'status': false, 'message': e.toString()};
        completer.complete(result);
      }
    }
    return completer.future;
  }
}
