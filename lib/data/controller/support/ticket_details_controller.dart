import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/support/support_controller.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/support/support_ticket_view_response_model.dart';
import 'package:leoparduser/data/repo/support/support_repo.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TicketDetailsController extends GetxController {
  SupportRepo repo;
  final String ticketId;
  String username = '';
  bool isRtl = false;

  TicketDetailsController({required this.repo, required this.ticketId});

  Future<void> loadData() async {
    isLoading = true;
    update();
    String languageCode = repo.apiClient.sharedPreferences.getString(
          SharedPreferenceHelper.languageCode,
        ) ??
        'eng';
    if (languageCode == 'ar') {
      isRtl = true;
    }
    loadUserName();
    await loadTicketDetailsData();
    isLoading = false;
    update();
  }

  void loadUserName() {
    username = repo.apiClient.getUserName();
  }

  bool isLoading = false;

  final TextEditingController replyController = TextEditingController();

  MyTickets? receivedTicketModel;
  List<File> attachmentList = [];

  String noFileChosen = MyStrings.noFileChosen;
  String chooseFile = MyStrings.chooseFile;

  String ticketImagePath = "";

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );
    if (result == null) return;

    if (attachmentList.length < 5) {
      attachmentList.add(File(result.files.single.path!));
    } else {
      CustomSnackBar.error(errorList: ['Maximal 5 files']);
    }

    update();
  }

  void removeAttachmentFromList(int index) {
    if (attachmentList.length > index) {
      attachmentList.removeAt(index);
      update();
    }
  }

  SupportTicketViewResponseModel model = SupportTicketViewResponseModel();
  List<SupportMessage> messageList = [];
  String ticket = '';
  String subject = '';
  String status = '-1';
  String ticketName = '';

  Future<void> loadTicketDetailsData({bool shouldLoad = true}) async {
    isLoading = shouldLoad;
    update();
    ResponseModel response = await repo.getSingleTicket(ticketId);

    if (response.statusCode == 200) {
      model = SupportTicketViewResponseModel.fromJson((response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        ticket = model.data?.myTickets?.ticket ?? '';
        subject = model.data?.myTickets?.subject ?? '';
        status = model.data?.myTickets?.status ?? '';
        ticketName = model.data?.myTickets?.name ?? '';
        receivedTicketModel = model.data?.myTickets;
        List<SupportMessage>? tempTicketList = model.data?.myMessages ?? [];
        if (tempTicketList.isNotEmpty) {
          messageList.clear();
          messageList.addAll(tempTicketList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> uploadTicketViewReply() async {
    if (replyController.text.toString().isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.replyTicketEmptyMsg]);
      return;
    }
    submitLoading = true;
    update();

    try {
      bool b = await repo.replyTicket(
        replyController.text,
        attachmentList,
        receivedTicketModel?.id.toString() ?? "-1",
      );

      if (b) {
        await loadTicketDetailsData(shouldLoad: false);
        CustomSnackBar.success(successList: [MyStrings.repliedSuccessfully]);
        replyController.text = '';
        refreshAttachmentList();
      }
    } catch (e) {
      printE(e);
      submitLoading = false;
      update();
    } finally {
      submitLoading = false;
      update();
    }
  }

  void setTicketModel(MyTickets? ticketModel) {
    receivedTicketModel = ticketModel;
    update();
  }

  void clearAllData() {
    refreshAttachmentList();
    replyController.clear();
    messageList.clear();
  }

  void refreshAttachmentList() {
    attachmentList.clear();
    update();
  }

  bool closeLoading = false;
  void closeTicket(String supportTicketID) async {
    closeLoading = true;
    update();
    ResponseModel responseModel = await repo.closeTicket(supportTicketID);
    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson((responseModel.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        Get.find<SupportController>().loadData();
        clearAllData();
        Get.back();
        CustomSnackBar.success(
          successList: model.message ?? [MyStrings.requestSuccess],
        );
        Get.find<SupportController>().loadData();
      } else {
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.requestFail],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    closeLoading = false;
    update();
  }

  String getStatusText(
    String priority, {
    bool isPriority = false,
    bool isStatus = false,
  }) {
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

  //download pdf
  TargetPlatform? platform;
  String _localPath = '';
  String downLoadId = "";

  Future<bool> checkPermission() async {
    if (platform == TargetPlatform.android) {
      await Permission.storage.request();
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        await Permission.storage.request();
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return directory.path;
      } else {
        return (await getExternalStorageDirectory())?.path ?? "";
      }
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return null;
    }
  }

  bool isSubmitLoading = false;
  int selectedIndex = -1;

  Future<void> downloadAttachment(
    String url,
    int index,
    String extension,
  ) async {
    selectedIndex = index;
    isSubmitLoading = true;
    update();

    _prepareSaveDir();

    Dio dio = Dio();
    dio.options.headers = {
      'Authorization': "Bearer ${repo.apiClient.getToken()}",
      'content-type': "application/pdf",
      "dev-token": Environment.devToken,
    };
    String fileName = '${MyStrings.appName} ${DateTime.now()}.$extension';
    // Get the device's download directory
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$fileName";

    final response = await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          printX("${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );

    if (response.statusCode == 200) {
      // Open or handle the file
      final fileBytes = await File(filePath).readAsBytes();

      await saveAndOpenPDF(
        fileBytes,
        '${MyStrings.appName} ${DateTime.now()}.$extension',
      );
    } else {
      try {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson((response.data));
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.somethingWentWrong],
        );
      } catch (e) {
        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      }
    }
    selectedIndex = -1;
    isSubmitLoading = false;
    update();
  }

  Future<void> saveAndOpenPDF(List<int> bytes, String fileName) async {
    final path = '$_localPath/$fileName';
    final file = File(path);
    await file.writeAsBytes(bytes);
    await openPDF(path);
  }

  Future<void> openPDF(String path) async {
    final file = File(path);
    if (await file.exists()) {
      // final result = await OpenFile.open(path);
      // if (result.type == ResultType.done) {
      // } else {
      //   CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
      // }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
    }
  }
}
