import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class ReviewRepo {
  ApiClient apiClient;
  ReviewRepo({required this.apiClient});

  Future<ResponseModel> getReviews({required String id}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.getDriverReview}/$id";
    final response =
        await apiClient.request(url, Method.getMethod, {}, passHeader: true);
    return response;
  }

  Future<ResponseModel> getMyReviews() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reviewRide}";
    final response =
        await apiClient.request(url, Method.getMethod, {}, passHeader: true);
    return response;
  }
}
