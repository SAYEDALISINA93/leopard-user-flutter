import 'dart:io';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/support/new_ticket_store_model.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SupportRepo {
  ApiClient apiClient;
  SupportRepo({required this.apiClient});

  Future<ResponseModel> getSupportMethodsList() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.supportMethodsEndPoint}";
    final response = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return response;
  }

  Future<ResponseModel> getSupportTicketList(String page) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.supportListEndPoint}?page=$page";
    final response = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return response;
  }

  Future<dynamic> storeTicket(TicketStoreModel model) async {
    apiClient.initToken();

    String url = "${UrlContainer.baseUrl}${UrlContainer.storeSupportEndPoint}";

    Map<String, String> finalMap = {
      'subject': model.subject,
      'message': model.message,
      'priority': model.priority,
    };

    Map<String, File> attachmentFiles = model.fileList?.isEmpty == true
        ? {}
        : model.fileList!.asMap().map(
              (index, value) => MapEntry("attachments[$index]", value),
            );
    ResponseModel responseModel = await apiClient.multipartRequest(
      url,
      Method.postMethod,
      finalMap,
      files: attachmentFiles,
      passHeader: true,
    );
    AuthorizationResponseModel authorization =
        AuthorizationResponseModel.fromJson((responseModel.responseJson));

    if (authorization.status?.toLowerCase() ==
        MyStrings.success.toLowerCase()) {
      return true;
    } else {
      CustomSnackBar.error(
        errorList: authorization.message ?? [MyStrings.error],
      );
      return false;
    }
  }

  Future<dynamic> getSingleTicket(String ticketId) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.supportViewEndPoint}/$ticketId';
    ResponseModel response = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return response;
  }

  Future<dynamic> replyTicket(
    String message,
    List<File> fileList,
    String ticketId,
  ) async {
    apiClient.initToken();

    try {
      String url =
          "${UrlContainer.baseUrl}${UrlContainer.supportReplyEndPoint}/$ticketId";
      Map<String, String> map = {'message': message.toString()};

      Map<String, File> attachmentFiles = fileList.asMap().map(
            (index, value) => MapEntry("attachments[$index]", value),
          );

      ResponseModel responseModel = await apiClient.multipartRequest(
        url,
        Method.postMethod,
        map,
        files: attachmentFiles,
        passHeader: true,
      );
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson((responseModel.responseJson));

      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        return true;
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.error]);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> closeTicket(String ticketId) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.supportCloseEndPoint}/$ticketId';
    ResponseModel response = await apiClient.request(
      url,
      Method.postMethod,
      null,
      passHeader: true,
    );
    return response;
  }
}

class ReplyTicketModel {
  final String? message;
  final List<File>? fileList;

  ReplyTicketModel(this.message, this.fileList);
}
