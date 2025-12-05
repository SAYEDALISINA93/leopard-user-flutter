import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/data/model/country_model/country_model.dart';
import 'package:leoparduser/data/model/general_setting/general_setting_response_model.dart';

class LocalStorageService {
  final SharedPreferences sharedPreferences;

  LocalStorageService({required this.sharedPreferences});

  // Token Management
  String getToken() {
    return sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey) ??
        '';
  }

  String getTokenType() {
    return sharedPreferences
            .getString(SharedPreferenceHelper.accessTokenType) ??
        'Bearer';
  }

  void saveToken(String token, String type) {
    sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, token);
    sharedPreferences.setString(SharedPreferenceHelper.accessTokenType, type);
  }

  void removeToken() {
    sharedPreferences.remove(SharedPreferenceHelper.accessTokenKey);
  }

  // Remember Me Functionality
  void setRememberMe(bool value) {
    sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, value);
  }

  bool getRememberMe() {
    return sharedPreferences.getBool(SharedPreferenceHelper.rememberMeKey) ??
        false;
  }

  // General Settings
  void storeGeneralSetting(GeneralSettingResponseModel model) {
    String json = jsonEncode(model.toJson());
    sharedPreferences.setString(SharedPreferenceHelper.generalSettingKey, json);
  }

  GeneralSettingResponseModel getGeneralSettings() {
    String pre =
        sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey) ??
            '{}';
    try {
      return GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    } catch (e) {
      return GeneralSettingResponseModel();
    }
  }

  // Pusher Configuration
  void storePushSetting(PusherConfig pusherConfig) {
    String json = jsonEncode(pusherConfig.toJson());
    sharedPreferences.setString(
        SharedPreferenceHelper.pusherConfigSettingKey, json);
  }

  PusherConfig getPushConfig() {
    String pre = sharedPreferences
            .getString(SharedPreferenceHelper.pusherConfigSettingKey) ??
        '{}';
    try {
      return PusherConfig.fromJson(jsonDecode(pre));
    } catch (e) {
      return PusherConfig();
    }
  }

  // Notification Audio
  void storeNotificationAudio(String notificationAudioPath) {
    sharedPreferences.setString(
        SharedPreferenceHelper.notificationAudioKey, notificationAudioPath);
  }

  String getNotificationAudio() {
    return sharedPreferences
            .getString(SharedPreferenceHelper.notificationAudioKey) ??
        '';
  }

  void storeNotificationAudioEnable(bool isEnable) {
    sharedPreferences.setString(
      SharedPreferenceHelper.notificationAudioEnableKey,
      isEnable ? '1' : '0',
    );
  }

  bool isNotificationAudioEnable() {
    String pre = sharedPreferences
            .getString(SharedPreferenceHelper.notificationAudioEnableKey) ??
        '';
    return pre == '1';
  }

  // User Information
  String getUserEmail() {
    return sharedPreferences.getString(SharedPreferenceHelper.userEmailKey) ??
        '';
  }

  String getUserName() {
    return sharedPreferences.getString(SharedPreferenceHelper.userNameKey) ??
        '';
  }

  // Tab Management
  void storeCurrentTab(String tab) {
    sharedPreferences.setString(SharedPreferenceHelper.currentTabKey, tab);
  }

  String getCurrentTab() {
    return sharedPreferences.getString(SharedPreferenceHelper.currentTabKey) ??
        '1';
  }

  // Utility Methods
  List<String> getTipsList() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.tipsSuggestAmount ?? [];
  }

  bool isGoogleLoginEnabled() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.googleLogin == '1';
  }

  bool isAppleLoginEnabled() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.appleLogin == '1';
  }

  bool isReferEnabled() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.riderReferral == '1';
  }

  String getSocialCredentialsRedirectUrl() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.socialRedirectUrl ?? "";
  }

  String getReferAmount() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.riderReferralAmount ?? '';
  }

  String getCurrency({bool isSymbol = false}) {
    GeneralSettingResponseModel model = getGeneralSettings();
    return isSymbol
        ? model.data?.generalSetting?.curSym ?? ''
        : model.data?.generalSetting?.curText ?? '';
  }

  String getMinimumRideDistance() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.minDistance ?? '';
  }

  List<Countries> getOperatingCountries() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.operatingCountry ?? [];
  }

  bool getPasswordStrengthStatus() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.securePassword == '1';
  }

  bool isMultiLanguageEnabled() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.multiLanguage == '1';
  }

  String getTemplateName() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.activeTemplate ?? '';
  }

  bool isAgreePolicyEnabled() {
    GeneralSettingResponseModel model = getGeneralSettings();
    return model.data?.generalSetting?.agree == '1';
  }
}
