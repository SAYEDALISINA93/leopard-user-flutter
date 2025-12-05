import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/profile/profile_response_model.dart';
import 'package:leoparduser/data/model/user_post_model/user_post_model.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<AuthorizationResponseModel> updateProfile(
    UserPostModel m,
    bool isProfile,
  ) async {
    try {
      String url =
          '${UrlContainer.baseUrl}${isProfile ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';

      Map<String, String> finalMap = {
        'username': m.username,
        'firstname': m.firstname,
        'lastname': m.lastName,
        'mobile_code': m.mobileCode,
        'country_code': m.countryCode,
        'country': m.country,
        'mobile': m.mobile,
        'address': m.address ?? '',
        'zip': m.zip ?? '',
        'state': m.state ?? "",
        'city': m.city ?? '',
        'reference': m.refer ?? '',
      };

      //Attachments file list
      Map<String, File> attachmentFiles = {};
      if (m.image != null) {
        attachmentFiles = {"image": m.image!};
      }

      ResponseModel responseModel = await apiClient.multipartRequest(
        url,
        Method.postMethod,
        finalMap,
        files: attachmentFiles,
        passHeader: true,
      );

      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson((responseModel.responseJson));

      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        CustomSnackBar.success(
          successList: model.message ?? [MyStrings.success],
        );
        return model;
      } else {
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.requestFail.tr],
        );
        return model;
      }
    } catch (e) {
      return AuthorizationResponseModel(
        status: "error",
        message: [MyStrings.somethingWentWrong],
      );
    }
  }

  Future<ProfileResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model =
          ProfileResponseModel.fromJson((responseModel.responseJson));
      if (model.status == 'success') {
        return model;
      } else {
        return ProfileResponseModel();
      }
    } else {
      return ProfileResponseModel();
    }
  }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }

  //
  Future<ResponseModel> logout() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.logoutUrl}';

    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );

    // Delete Firebase messaging token
    try {
      await FirebaseMessaging.instance.deleteToken();
      await apiClient.sharedPreferences
          .remove(SharedPreferenceHelper.fcmDeviceKey);
    } catch (e) {
      // Continue logout even if Firebase token deletion fails
    }

    await clearSharedPrefData();
    return responseModel;
  }

  Future<void> clearSharedPrefData() async {
    await apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userNameKey,
      '',
    );
    await apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userEmailKey,
      '',
    );
    await apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.accessTokenType,
      '',
    );
    await apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.accessTokenKey,
      '',
    );
    await apiClient.sharedPreferences.setBool(
      SharedPreferenceHelper.rememberMeKey,
      false,
    );
    return Future.value();
  }
}
