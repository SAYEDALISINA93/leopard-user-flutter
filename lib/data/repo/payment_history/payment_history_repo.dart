import 'dart:convert';

import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';
import 'package:leoparduser/data/model/profile/profile_response_model.dart';
import 'package:leoparduser/data/services/api_service.dart';

class PaymentHistoryRepo {
  ApiClient apiClient;
  PaymentHistoryRepo({required this.apiClient});

  Future<ResponseModel> getTransactionList(int page,
      {String type = "",
      String remark = "",
      String searchText = "",
      String walletType = ''}) async {
    if (type.toLowerCase() == "all" ||
        (type.toLowerCase() != 'plus' && type.toLowerCase() != 'minus')) {
      type = '';
    }

    if (remark.isEmpty || remark.toLowerCase() == "all") {
      remark = '';
    }

    String url =
        '${UrlContainer.baseUrl}${UrlContainer.paymentHistoryEndpoint}?page=$page&type=$type&remark=$remark&search=$searchText';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<GlobalUser> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model =
          ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        return model.data?.user ?? GlobalUser();
      } else {
        return GlobalUser();
      }
    } else {
      return GlobalUser();
    }
  }
}
