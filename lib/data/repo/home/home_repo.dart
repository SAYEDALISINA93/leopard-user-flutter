import 'dart:convert';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/general_setting/general_setting_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/ride/create_ride_request_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class HomeRepo {
  ApiClient apiClient;
  HomeRepo({required this.apiClient});

  Future<ResponseModel> getData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.dashBoardUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createRide(
      {required CreateRideRequestModel data}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.createRide}";
    printx(data.toJson());
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, data.toMap(), passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getRideFare(
      {required CreateRideRequestModel data}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideFareAndDistance}";
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, data.toMap(), passHeader: true);
    return responseModel;
  }

  Future<dynamic> refreshGeneralSetting() async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.generalSettingEndPoint}';
    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: false);

    if (response.statusCode == 200) {
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        apiClient.storeGeneralSetting(model);
      }
    }
  }
}
