import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/support/support_controller.dart';
import 'package:leoparduser/data/model/support/new_ticket_store_model.dart';
import 'package:leoparduser/data/repo/support/support_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class NewTicketController extends GetxController {
  SupportRepo repo;
  NewTicketController({required this.repo});

  bool isLoading = false;

  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode priorityFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  String noFileChosen = MyStrings.noFileChosen;
  String chooseFile = MyStrings.chooseFile;

  bool isRtl = false;

  List<File> attachmentList = [];
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx']);

    if (result == null) return;
    for (var i = 0; i < result.files.length; i++) {
      if (attachmentList.length < 5) {
        attachmentList.add(File(result.files[i].path!));
      } else {
        CustomSnackBar.error(errorList: ['Maximum file 5']);
      }
      update();
    }
    return;
  }

  removeAttachmentFromList(int index) {
    if (attachmentList.length > index) {
      attachmentList.removeAt(index);
      update();
    }
  }

  addNewAttachment() {
    if (attachmentList.length > 4) {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      return;
    }

    update();
  }

  void refreshAttachmentList() {
    attachmentList.clear();
    attachmentList = [];
    update();
  }

  List<String> priorityList = [
    MyStrings.low.tr,
    MyStrings.medium.tr,
    MyStrings.high.tr
  ];
  String? selectedPriority = MyStrings.low.tr;

  int selectedIndex = 0;
  void setPriority(String? newValue) {
    selectedPriority = newValue;
    if (newValue != null) {
      selectedIndex = priorityList.indexOf(newValue);
    }
    update();
  }

  bool isImage(String path) {
    if (path.contains('.jpg')) {
      printX("its image");
      return true;
    }
    if (path.contains('.png')) {
      return true;
    }
    if (path.contains('.jpeg')) {
      return true;
    }
    return false;
  }

  bool isXlsx(String path) {
    if (path.contains('.xlsx')) {
      return true;
    }
    if (path.contains('.xls')) {
      return true;
    }
    if (path.contains('.xlx')) {
      return true;
    }
    return false;
  }

  bool isDoc(String path) {
    if (path.contains('.doc')) {
      return true;
    }
    if (path.contains('.docs')) {
      return true;
    }
    return false;
  }

  bool submitLoading = false;
  void submit() async {
    String name = nameController.text.toString();
    String email = emailController.text.toString();
    String subject = subjectController.text.toString();
    String priority = "${selectedIndex + 1}";
    String message = messageController.text.toString();

    if (message.isEmpty) {
      CustomSnackBar.error(
        errorList: [MyStrings.messageRequired],
      );
      return;
    }

    if (message.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.subjectRequired]);
      return;
    }

    submitLoading = true;
    update();

    TicketStoreModel model = TicketStoreModel(
        name: name,
        email: email,
        subject: subject,
        priority: priority,
        message: message,
        list: attachmentList);

    bool isSuccess = await repo.storeTicket(model);

    try {
      if (isSuccess) {
        Get.find<SupportController>().loadData();
        // Get.back();
        printX(Get.previousRoute);
        Get.back();
        CustomSnackBar.success(
            successList: [MyStrings.ticketCreateSuccessfully]);
        clearSelectedData();
      }
    } catch (e) {
      printX(e);
    }

    submitLoading = false;
    update();
  }

  void clearSelectedData() {
    subjectController.text = '';
    messageController.text = '';
    refreshAttachmentList();
  }
}
