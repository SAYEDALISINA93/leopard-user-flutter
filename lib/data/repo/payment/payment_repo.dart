import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class PaymentRepo {
  ApiClient apiClient;
  PaymentRepo({required this.apiClient});

  Future<ResponseModel> getRideDetails(String id) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideDetails}/$id";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getRidePaymentDetails(String id) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.ridePayment}/$id";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getPaymentList() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.paymentGateways}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> submitPayment({
    required String rideId,
    required String currency,
    required String methodCode,
    required String type,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.ridePayment}/$rideId";
    Map<String, String> params = {
      'ride_id': rideId,
      'currency': currency,
      'method_code': methodCode,
      'payment_type': type,
    };
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }
}
