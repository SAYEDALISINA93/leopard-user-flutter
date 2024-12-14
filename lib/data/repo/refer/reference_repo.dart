import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class ReferenceRepo {
  ApiClient apiClient;
  ReferenceRepo({required this.apiClient});

  Future<ResponseModel> getReferData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reference}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
