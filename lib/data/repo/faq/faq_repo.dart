import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class FaqRepo {
  ApiClient apiClient;
  FaqRepo({required this.apiClient});

  Future<ResponseModel> getFaqData() async {
    String url = UrlContainer.baseUrl + UrlContainer.faq;
    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }
}
