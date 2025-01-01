import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/messages.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/controller/localization/localization_controller.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/general_setting/general_setting_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/general_setting_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SplashController extends GetxController {
  GeneralSettingRepo repo;
  LocalizationController localizationController;
  SplashController({required this.repo, required this.localizationController});

  bool isLoading = true;
  gotoNextPage() async {
    await loadLanguage();
    bool isRemember = repo.apiClient.sharedPreferences
            .getBool(SharedPreferenceHelper.rememberMeKey) ??
        false;

    noInternet = false;
    update();

    initSharedData();

    getGSData(isRemember);
  }

  bool noInternet = false;
  bool isMaintenance = false;
  void getGSData(bool isRemember) async {
    ResponseModel response = await repo.getGeneralSetting();
    bool isOnboardAlreadyDisplayed = repo.apiClient.sharedPreferences
            .getBool(SharedPreferenceHelper.onBoardKey) ??
        false;

    if (response.statusCode == 200) {
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success) {
        isMaintenance =
            model.data?.generalSetting?.maintenanceMode == "1" ? true : false;
        loggerX(isMaintenance);
        repo.apiClient.storeGeneralSetting(model);
        repo.apiClient.storePushSetting(
            model.data?.generalSetting?.pushConfig ?? PusherConfig());
        repo.apiClient.storeNotificationAudio(
            "${UrlContainer.domainUrl}/${model.data?.notificationAudioPath}/${model.data?.generalSetting?.notificationAudio ?? ""}");
      } else {
        if (model.remark == "maintenance_mode") {
          Future.delayed(const Duration(seconds: 1), () {
            Get.offAndToNamed(RouteHelper.maintenanceScreen);
          });
          return;
        } else {
          List<String> message = [MyStrings.somethingWentWrong];
          CustomSnackBar.error(errorList: model.message ?? message);
        }
      }
    } else {
      if (response.statusCode == 503) {
        noInternet = true;
        update();
      }
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
    if (noInternet == false) {
      if (isOnboardAlreadyDisplayed == false) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAndToNamed(RouteHelper.onboardScreen);
        });
      } else {
        if (isRemember) {
          Future.delayed(const Duration(seconds: 1), () {
            Get.offNamed(RouteHelper.dashboard);
          });
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            Get.offAndToNamed(RouteHelper.loginScreen);
          });
        }
      }
    }
  }

  Future<bool> initSharedData() {
    if (!repo.apiClient.sharedPreferences
        .containsKey(SharedPreferenceHelper.countryCode)) {
      return repo.apiClient.sharedPreferences.setString(
          SharedPreferenceHelper.countryCode,
          MyStrings.myLanguages[0].countryCode);
    }
    if (!repo.apiClient.sharedPreferences
        .containsKey(SharedPreferenceHelper.languageCode)) {
      return repo.apiClient.sharedPreferences.setString(
          SharedPreferenceHelper.languageCode,
          MyStrings.myLanguages[0].languageCode);
    }
    return Future.value(true);
  }

  Future<void> loadLanguage() async {
    localizationController.loadCurrentLanguage();
    String languageCode = localizationController.locale.languageCode;
    ResponseModel response = await repo.getLanguage(languageCode);

    if (response.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(response.responseJson));
      if (model.remark == "maintenance_mode") {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAndToNamed(RouteHelper.maintenanceScreen);
        });
        return;
      }
      try {
        Map<String, Map<String, String>> language = {};
        var resJson = jsonDecode(response.responseJson);
        saveLanguageList(response.responseJson);
        var value = resJson['data']['file'].toString() == '[]'
            ? {}
            : resJson['data']['file'];
        Map<String, String> json = {};
        printx(value);
        value.forEach((key, value) {
          json[key] = value.toString();
        });
        language[
                '${localizationController.locale.languageCode}_${localizationController.locale.countryCode}'] =
            json;
        Get.addTranslations(Messages(languages: language).keys);
      } catch (e) {
        if (kDebugMode) {
          CustomSnackBar.error(errorList: [e.toString()]);
        }
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }
  }

  void saveLanguageList(String languageJson) async {
    await repo.apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.languageListKey, languageJson);
    return;
  }
}
