import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/profile/profile_response_model.dart';
import 'package:leoparduser/data/model/user_post_model/user_post_model.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<AuthorizationResponseModel> updateProfile(
      UserPostModel m, bool isProfile) async {
    try {
      apiClient.initToken();

      String url =
          '${UrlContainer.baseUrl}${isProfile ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';
      printX(url);
      var request = http.MultipartRequest('POST', Uri.parse(url));
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
      printX(m.image);
      request.headers.addAll(
        <String, String>{
          'Authorization': 'Bearer ${apiClient.token}',
          "dev-token":
              "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
        },
      );
      if (m.image != null) {
        request.files.add(http.MultipartFile(
            'image', m.image!.readAsBytes().asStream(), m.image!.lengthSync(),
            filename: m.image!.path.split('/').last));
      }
      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();

      String jsonResponse = await response.stream.bytesToString();
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        CustomSnackBar.success(
            successList: model.message ?? [MyStrings.success]);
        return model;
      } else {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.requestFail.tr]);
        return model;
      }
    } catch (e) {
      return AuthorizationResponseModel(
          status: "error", message: [MyStrings.somethingWentWrong]);
    }
  }

  Future<ProfileResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model =
          ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
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

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    await clearSharedPrefData();
    return responseModel;
  }

  Future<void> clearSharedPrefData() async {
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userNameKey, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userEmailKey, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenType, '');
    await apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenKey, '');
    await apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, false);
    return Future.value();
  }
}
