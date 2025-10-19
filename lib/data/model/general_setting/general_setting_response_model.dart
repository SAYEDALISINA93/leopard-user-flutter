// To parse this JSON data, do
//
//     final generalSettingResponseModel = generalSettingResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/country_model/country_model.dart';

GeneralSettingResponseModel generalSettingResponseModelFromJson(String str) =>
    GeneralSettingResponseModel.fromJson(json.decode(str));

String generalSettingResponseModelToJson(GeneralSettingResponseModel data) =>
    json.encode(data.toJson());

class GeneralSettingResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  GeneralSettingResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory GeneralSettingResponseModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x.toString())),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  GeneralSetting? generalSetting;
  String? socialRedirectUrl;
  String? notificationAudioPath;

  Data({
    this.generalSetting,
    this.socialRedirectUrl,
    this.notificationAudioPath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        generalSetting: json["general_setting"] == null
            ? null
            : GeneralSetting.fromJson(json["general_setting"]),
        socialRedirectUrl: json["social_login_redirect"].toString(),
        notificationAudioPath: json["notification_audio_path"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "general_setting": generalSetting?.toJson(),
        "social_login_redirect": socialRedirectUrl,
        "notification_audio_path": notificationAudioPath,
      };
}

class GeneralSetting {
  String? id; // string
  String? siteName;
  String? curText;
  String? curSym;
  String? emailFrom;
  String? emailFromName;
  String? smsTemplate;
  String? smsBody;
  String? smsFrom;
  String? pushTitle;
  String? pushTemplate;
  String? baseColor;
  String? secondaryColor;
  String? driverReferralAmount; // string
  String? riderReferralAmount; // string
  String? extraActiveTime; // string
  PusherConfig? pushConfig;
  GlobalShortCodes? globalShortCodes;
  SocialiteCredentials? socialiteCredentials;
  String? kv; // string
  String? ev; // string
  String? en; // string
  String? sv; // string
  String? sn; // string
  String? userCancellationLimit; // string
  String? driverFreeCancel; // string
  String? rideCancelFee;
  String? neighborArea;
  String? minDistance;
  String? forceSsl; // string
  String? maintenanceMode; // string
  String? securePassword; // string
  String? agree; // string
  String? riderReferral;
  String? googleMapsApi;
  String? fixedCharge;
  String? percentageCharge;
  String? multiLanguage; // string
  String? registration; // string
  String? activeTemplate;
  dynamic lastCron;
  String? systemCustomized; // string
  String? createdAt;
  String? updatedAt;
  String? googleLogin;
  String? appleLogin;
  String? timezone;
  List<Countries>? operatingCountry;
  String? notificationAudio;
  List<String>? tipsSuggestAmount;
  Map<String, dynamic>? firebaseConfig;
  String? firebaseServices;

  GeneralSetting({
    this.id,
    this.siteName,
    this.curText,
    this.curSym,
    this.emailFrom,
    this.emailFromName,
    this.smsTemplate,
    this.smsBody,
    this.smsFrom,
    this.pushTitle,
    this.pushTemplate,
    this.baseColor,
    this.secondaryColor,
    this.driverReferralAmount,
    this.riderReferralAmount,
    this.extraActiveTime,
    this.pushConfig,
    this.globalShortCodes,
    this.socialiteCredentials,
    this.kv,
    this.ev,
    this.en,
    this.sv,
    this.sn,
    this.userCancellationLimit,
    this.driverFreeCancel,
    this.rideCancelFee,
    this.neighborArea,
    this.minDistance,
    this.forceSsl,
    this.maintenanceMode,
    this.securePassword,
    this.agree,
    this.riderReferral,
    this.googleMapsApi,
    this.fixedCharge,
    this.percentageCharge,
    this.multiLanguage,
    this.registration,
    this.activeTemplate,
    this.lastCron,
    this.systemCustomized,
    this.createdAt,
    this.updatedAt,
    this.googleLogin,
    this.appleLogin,
    this.timezone,
    this.operatingCountry,
    this.notificationAudio,
    this.tipsSuggestAmount,
    this.firebaseConfig,
    this.firebaseServices,
  });

  factory GeneralSetting.fromJson(Map<String, dynamic> json) => GeneralSetting(
        id: json["id"].toString(),
        siteName: json["site_name"],
        curText: json["cur_text"],
        curSym: json["cur_sym"],
        emailFrom: json["email_from"],
        emailFromName: json["email_from_name"],
        smsTemplate: json["sms_template"],
        pushTitle: json["push_title"],
        pushTemplate: json["push_template"],
        baseColor: json["base_color"],
        secondaryColor: json["secondary_color"],
        smsBody: json["sms_body"],
        smsFrom: json["sms_from"],
        riderReferralAmount: json["rider_referral_amount"]?.toString(),
        driverReferralAmount: json["driver_referral_amount"]?.toString(),
        extraActiveTime: json["extra_active_time"]?.toString(),
        pushConfig: json["pusher_config"] == null
            ? null
            : PusherConfig.fromJson(json["pusher_config"]),
        globalShortCodes: json["global_shortcodes"] == null
            ? null
            : GlobalShortCodes.fromJson(json["global_shortcodes"]),
        socialiteCredentials: json["socialite_credentials"] == null
            ? null
            : SocialiteCredentials.fromJson(json["socialite_credentials"]),
        kv: json["kv"]?.toString(),
        ev: json["ev"]?.toString(),
        en: json["en"]?.toString(),
        sv: json["sv"]?.toString(),
        sn: json["sn"]?.toString(),
        userCancellationLimit: json["user_cancellation_limit"]?.toString(),
        driverFreeCancel: json["driver_free_cancel"]?.toString(),
        rideCancelFee: json["ride_cancel_fee"]?.toString(),
        neighborArea: json["neighbor_area"]?.toString(),
        minDistance: json["min_distance"]?.toString(),
        forceSsl: json["force_ssl"]?.toString(),
        maintenanceMode: json["maintenance_mode"]?.toString(),
        securePassword: json["secure_password"]?.toString(),
        agree: json["agree"]?.toString(),
        riderReferral: json["rider_referral"]?.toString(),
        googleMapsApi: json["google_maps_api"],
        fixedCharge: json["fixed_charge"]?.toString(),
        percentageCharge: json["percentage_charge"]?.toString(),
        multiLanguage: json["multi_language"]?.toString(),
        registration: json["registration"]?.toString(),
        activeTemplate: json["active_template"],
        lastCron: json["last_cron"],
        systemCustomized: json["system_customized"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        googleLogin: json["google_login"]?.toString(),
        appleLogin: json["apple_login"]?.toString(),
        timezone: json["timezone"]?.toString(),
        operatingCountry: json["operating_country"] == null
            ? []
            : List<Countries>.from(
                json["operating_country"]!.map((x) => Countries.fromJson(x))),
        notificationAudio: json["notification_audio"]?.toString(),
        tipsSuggestAmount: json["tips_suggest_amount"] == null
            ? []
            : List<String>.from(
                json["tips_suggest_amount"]!.map((x) => x.toString())),
        firebaseConfig: json["firebase_config"] is Map
            ? Map<String, dynamic>.from(json["firebase_config"])
            : null,
        firebaseServices: json["firebase_services"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "site_name": siteName,
        "cur_text": curText,
        "cur_sym": curSym,
        "email_from": emailFrom,
        "email_from_name": emailFromName,
        "sms_template": smsTemplate,
        "push_title": pushTitle,
        "push_template": pushTemplate,
        "base_color": baseColor,
        "secondary_color": secondaryColor,
        "sms_body": smsBody,
        "sms_from": smsFrom,
        "driver_referral_amount": driverReferralAmount,
        "rider_referral_amount": riderReferralAmount,
        "extra_active_time": extraActiveTime,
        "pusher_config": pushConfig?.toJson(),
        "global_shortcodes": globalShortCodes?.toJson(),
        "socialite_credentials": socialiteCredentials?.toJson(),
        "kv": kv,
        "ev": ev,
        "en": en,
        "sv": sv,
        "sn": sn,
        "user_cancellation_limit": userCancellationLimit,
        "driver_free_cancel": driverFreeCancel,
        "ride_cancel_fee": rideCancelFee,
        "neighbor_area": neighborArea,
        "min_distance": minDistance,
        "force_ssl": forceSsl,
        "maintenance_mode": maintenanceMode,
        "secure_password": securePassword,
        "agree": agree,
        "google_maps_api": googleMapsApi,
        "rider_referral": riderReferral,
        "fixed_charge": fixedCharge,
        "percentage_charge": percentageCharge,
        "multi_language": multiLanguage,
        "registration": registration,
        "active_template": activeTemplate,
        "last_cron": lastCron,
        "system_customized": systemCustomized,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "google_login": googleLogin,
        "apple_login": appleLogin,
        "timezone": timezone,
        "operating_country": operatingCountry?.map((e) => e.toJson()).toList(),
        "notification_audio": notificationAudio,
        "tips_suggest_amount": tipsSuggestAmount,
        "firebase_config": firebaseConfig,
        "firebase_services": firebaseServices,
      };
}

class GlobalShortCodes {
  String? siteName;
  String? siteCurrency;
  String? currencySymbol;

  GlobalShortCodes({
    this.siteName,
    this.siteCurrency,
    this.currencySymbol,
  });

  factory GlobalShortCodes.fromJson(Map<String, dynamic> json) =>
      GlobalShortCodes(
        siteName: json["site_name"],
        siteCurrency: json["site_currency"],
        currencySymbol: json["currency_symbol"],
      );

  Map<String, dynamic> toJson() => {
        "site_name": siteName,
        "site_currency": siteCurrency,
        "currency_symbol": currencySymbol,
      };
}

class PusherConfig {
  String? appKey;
  String? appId;
  String? appSecret;
  String? cluster;

  PusherConfig({
    this.appKey,
    this.appId,
    this.appSecret,
    this.cluster,
  });

  factory PusherConfig.fromJson(Map<String, dynamic> json) => PusherConfig(
        appKey: json["app_key"],
        appId: json["app_id"],
        appSecret: json["app_secret"],
        cluster: json["cluster"],
      );

  Map<String, dynamic> toJson() => {
        "app_key": appKey,
        "app_id": appId,
        "app_secret": appSecret,
        "cluster": cluster,
      };
}

//
class SocialiteCredentials {
  SocialCredential? google;
  SocialCredential? facebook;
  SocialCredential? linkedin;

  SocialiteCredentials({
    this.google,
    this.facebook,
    this.linkedin,
  });

  factory SocialiteCredentials.fromJson(Map<String, dynamic> json) =>
      SocialiteCredentials(
        google: json["google"] == null
            ? null
            : SocialCredential.fromJson(json["google"]),
        facebook: json["facebook"] == null
            ? null
            : SocialCredential.fromJson(json["facebook"]),
        linkedin: json["linkedin"] == null
            ? null
            : SocialCredential.fromJson(json["linkedin"]),
      );

  Map<String, dynamic> toJson() => {
        "google": google?.toJson(),
        "facebook": facebook?.toJson(),
        "linkedin": linkedin?.toJson(),
      };
}

class SocialCredential {
  String? clientId;
  String? clientSecret;
  String? status;
  String? info;

  SocialCredential({
    this.clientId,
    this.clientSecret,
    this.status,
    this.info,
  });

  factory SocialCredential.fromJson(Map<String, dynamic> json) =>
      SocialCredential(
        clientId: json["client_id"],
        clientSecret: json["client_secret"],
        status: json["status"].toString(),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "status": status,
        "info": info,
      };
}
