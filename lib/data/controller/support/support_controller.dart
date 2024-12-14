import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/support/support_ticket_response_model.dart';
import 'package:leoparduser/data/repo/support/support_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SupportController extends GetxController {
  SupportRepo repo;
  SupportController({required this.repo});

  List<FileChooserModel> attachmentList = [
    FileChooserModel(fileName: MyStrings.noFileChosen)
  ];

  String noFileChosen = MyStrings.noFileChosen;
  String chooseFile = MyStrings.chooseFile;

  final TextEditingController replyController = TextEditingController();

  bool submitLoading = false;
  bool isLoading = false;

  List<String> messageList = [];
  int page = 0;
  String? nextPageUrl;
  List<TicketData> ticketList = [];
  String imagePath = '';
  loadData() async {
    ticketList.clear();
    page = 0;
    messageList.clear();
    isLoading = true;
    update();
    await getSupportTicket();
    isLoading = false;
    update();
  }

  Future<void> getSupportTicket() async {
    page = page + 1;

    if (page == 1) {
      ticketList.clear();
      update();
    }
    isLoading = true;
    update();

    ResponseModel responseModel =
        await repo.getSupportTicketList(page.toString());
    if (responseModel.statusCode == 200) {
      SupportTicketListResponseModel model =
          SupportTicketListResponseModel.fromJson(
              jsonDecode(responseModel.responseJson));
      if (model.status == MyStrings.success) {
        nextPageUrl = model.data?.tickets?.nextPageUrl;
        List<TicketData>? tempList = model.data?.tickets?.data;
        imagePath = model.data?.tickets?.path.toString() ?? '';
        if (tempList != null && tempList.isNotEmpty) {
          ticketList.addAll(tempList);
        }
      } else {
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  Color getStatusColor(String status, {bool isPriority = false}) {
    late Color output;
    if (isPriority) {
      output = status == '1'
          ? MyColor.pendingColor
          : status == '2'
              ? MyColor.greenSuccessColor
              : status == '3'
                  ? MyColor.redCancelTextColor
                  : MyColor.pendingColor;
    } else {
      output = status == '1'
          ? MyColor.highPriorityPurpleColor
          : status == '2'
              ? MyColor.highPriorityPurpleColor
              : status == '3'
                  ? MyColor.redCancelTextColor
                  : MyColor.greenSuccessColor;
    }

    return output;
  }

  String getStatus(String status, {bool isPriority = false}) {
    String output = '';
    if (isPriority) {
      output = status == '1'
          ? MyStrings.low.tr
          : status == '2'
              ? MyStrings.medium.tr
              : status == '3'
                  ? MyStrings.high.tr
                  : '';
    } else {
      output = status == '0'
          ? MyStrings.open.tr
          : status == '1'
              ? MyStrings.answered.tr
              : status == '2'
                  ? MyStrings.customerReply.tr
                  : MyStrings.closed.tr;
    }
    return output;
  }

  String getStatusText(String priority,
      {bool isPriority = false, bool isStatus = false}) {
    String text = '';
    text = priority == '0'
        ? MyStrings.open.tr
        : priority == '1'
            ? MyStrings.answered.tr
            : priority == '2'
                ? MyStrings.replied.tr
                : priority == '3'
                    ? MyStrings.closed.tr
                    : '';
    return text;
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty ? true : false;
  }
}

class FileChooserModel {
  late String fileName;
  late File? choosenFile;
  FileChooserModel({required this.fileName, this.choosenFile});
}
