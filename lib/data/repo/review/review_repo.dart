import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_client.dart';

class ReviewRepo {
  ApiClient apiClient;
  ReviewRepo({required this.apiClient});

  Future<ResponseModel> getReviews({required String id}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.getDriverReview}/$id";
    final response = await apiClient.request(
      url,
      Method.getMethod,
      {},
      passHeader: true,
    );
    return response;
  }

  Future<ResponseModel> getMyReviews() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reviewRide}";
    final response = await apiClient.request(
      url,
      Method.getMethod,
      {},
      passHeader: true,
    );
    return response;
  }

  Future<ResponseModel> getRideDetails(String id) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideDetails}/$id";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> reviewRide({
    required String rideId,
    required String review,
    required String rating,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reviewRide}/$rideId";
    Map<String, String> params = {'review': review, 'rating': rating};
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.postMethod,
      params,
      passHeader: true,
    );
    return responseModel;
  }
}
