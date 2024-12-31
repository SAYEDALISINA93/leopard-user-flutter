import 'dart:convert';

import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class MenuRepo {
  ApiClient apiClient;

  MenuRepo({required this.apiClient});

  Future<ResponseModel> logout() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.logoutUrl}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    await clearSharedPrefData();
    return responseModel;
  }

  Future deleteAccount() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.userDeleteEndPoint}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, null, passHeader: true);
    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status == "success") {
        clearSharedPrefData();
        Get.offAllNamed(RouteHelper.loginScreen);
        CustomSnackBar.success(
            successList: model.message ?? ["Account deleted successfully"]);
      } else {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    }
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
