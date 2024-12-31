import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class RideRepo {
  ApiClient apiClient;
  RideRepo({required this.apiClient});

  Future<ResponseModel> getRideDetails(String id) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideDetails}/$id";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getRideList(
      {required String rideType,
      required String status,
      String page = '1'}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=$rideType&status=$status";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getActiveRideList({bool isIntraCity = false}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isIntraCity ? '1' : '2'}&status=2";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCompleteRideList(String page,
      {required bool isIntraCity}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isIntraCity ? '1' : '2'}&status=1&page=$page";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCanceledRideList(String page,
      {bool isIntraCity = false}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isIntraCity ? '1' : '2'}&status=9&page=$page";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getRideMessageList({
    required String id,
    required String page,
  }) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.rideMessageList}/$id?page=$page";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getRideBidList({required String id}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideBidList}/$id";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> acceptBid({required String bidId}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.acceptBid}/$bidId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> rejectBid({required String id}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rejectBid}/$id";
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> sos({
    required String id,
    required String msg,
    required LatLng latLng,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.sosRide}/$id";
    Map<String, String> params = {
      'message': msg,
      'latitude': latLng.latitude.toString(),
      'longitude': latLng.longitude.toString()
    };
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> cancelRide({
    required String id,
    required String reason,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.cancelBid}/$id";
    Map<String, String> params = {'cancel_reason': reason};
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> reviewRide({
    required String rideId,
    required String review,
    required String rating,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reviewRide}/$rideId";
    Map<String, String> params = {'review': review, 'rating': rating};
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }
}
