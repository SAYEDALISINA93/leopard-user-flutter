import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/services/api_client.dart';

class PrivacyRepo {
  ApiClient apiClient;
  PrivacyRepo({required this.apiClient});

  Future<dynamic> loadAboutData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.privacyPolicyEndPoint}';

    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }
}
