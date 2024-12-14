import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class TwoFactorRepo {
  ApiClient apiClient;
  TwoFactorRepo({required this.apiClient});

  Future<ResponseModel> verify(String code) async {
    final map = {'code': code};

    String url = '${UrlContainer.baseUrl}${UrlContainer.verify2FAUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);

    return responseModel;
  }
}
