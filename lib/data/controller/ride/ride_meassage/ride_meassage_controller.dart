import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/model/global/app/ride_meassage_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/ride/ride_meassage_response_list.dart';
import 'package:leoparduser/data/repo/meassage/meassage_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class RideMessageController extends GetxController {
  MessageRepo repo;
  RideMessageController({required this.repo});

  bool isLoading = false;
  TextEditingController massageController = TextEditingController();
  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  List<RideMessage> massage = [];

  String userId = '-1';
  String rideId = '-1';

  ScrollController scrollController = ScrollController();
  String? nextPageUrl;
  int page = 0;
  File? imageFile;

  Future<void> initialData(String id) async {
    userId = repo.apiClient.sharedPreferences.getString(
          SharedPreferenceHelper.userIdKey,
        ) ??
        '-1';
    defaultCurrency = repo.apiClient.getCurrency();
    defaultCurrencySymbol = repo.apiClient.getCurrency(isSymbol: true);
    username = repo.apiClient.getUserName();
    massage = [];
    rideId = id;
    page = 0;
    imageFile = null;
    update();
    printX(userId);
    getRideMessage(id);
  }

  Future<void> getRideMessage(
    String id, {
    int? p,
    bool shouldLoading = true,
  }) async {
    page = p ?? (page + 1);
    if (page == 1 && shouldLoading != false) {
      isLoading = shouldLoading;
      massage.clear();
    }
    isLoading = shouldLoading;
    update();
    try {
      ResponseModel responseModel = await repo.getRideMessageList(
        id: id,
        page: page.toString(),
      );
      if (responseModel.statusCode == 200) {
        RideMessageListResponseModel model =
            RideMessageListResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          imagePath = '${UrlContainer.domainUrl}/${model.data?.imagePath}';
          List<RideMessage>? tempMsgList = model.data?.messages ?? [];
          if (tempMsgList.isNotEmpty) {
            if (shouldLoading == false) {
              massage.clear();
            }
            massage.addAll(tempMsgList);
          }

          update();
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }

    isLoading = false;
    update();
  }

  bool isSubmitLoading = false;
  Future<void> sendMessage() async {
    isSubmitLoading = true;
    String msg = massageController.text;
    massageController.text = "";
    update();
    try {
      bool response = await repo.sendMessage(
        id: rideId,
        txt: msg,
        file: imageFile,
      );
      if (response == true) {
        isSubmitLoading = false;
        msg = '';
        massageController.text = '';
        imageFile = null;
        update();
        await getRideMessage(rideId, p: 1, shouldLoading: false);
      } else {
        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      }
    } catch (e) {
      printX(e);
    }
    isSubmitLoading = false;
    update();
  }

  void addEventMessage(RideMessage rideMessage) {
    userId = repo.apiClient.sharedPreferences.getString(
          SharedPreferenceHelper.userIdKey,
        ) ??
        '-1';
    printX("$userId ${rideMessage.rideId}");
    massage.insert(0, rideMessage);
    updateCount(unreadMsg + 1);
    if (rideMessage.rideId != userId &&
        rideMessage.rideId != "0" &&
        Get.currentRoute == RouteHelper.rideDetailsScreen) {
      MyUtils.vibrate();
    }

    update();
  }

  bool hasNext() {
    return nextPageUrl != null &&
            nextPageUrl!.isNotEmpty &&
            nextPageUrl != 'null'
        ? true
        : false;
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result == null) return;

    imageFile = File(result.files.single.path!);

    update();
  }

  //

  int unreadMsg = 0;
  void updateCount(int c) {
    printX('Update msg Count>>$unreadMsg $c');

    if (Get.currentRoute == RouteHelper.rideMessageScreen) {
      unreadMsg = 0;
      try {
        scrollController.animateTo(
          scrollController.offset,
          duration: const Duration(microseconds: 500),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        printX("msg scroll error $e");
      }
    } else {
      unreadMsg = c;
    }
    printX('Update msg Count>>$isLoading$unreadMsg $c');

    update();
    printX('Update msg Count>>$isLoading$unreadMsg $c');
  }

  void loader() {
    printX("Loader>>>$isLoading");
    isLoading = true;
    update();
    printX("Loader>>>$isLoading");
  }
}
