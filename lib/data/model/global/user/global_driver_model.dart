// ignore_for_file: prefer_null_aware_operators

import 'package:leoparduser/data/model/global/app/vehicle_brand_model.dart';

class GlobalDriverInfo {
  String? id; //
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? avatar;
  String? countryCode;
  String? dialCode; // Not used in this model, but might be useful
  String? mobile;
  String? address;
  String? totalReviews; //
  String? avgRating;
  String? onlineStatus; //
  String? status; //
  String? licenseNumber;
  String? licenseExpire;
  String? licensePhoto;
  String? dv; //
  String? vv; //
  List<String>? riderRuleId;
  String? ev; //
  String? sv; //
  String? profileComplete; //
  String? verCodeSendAt; //
  String? tsc; //
  String? banReason; //
  String? createdAt;
  String? updatedAt;
  String? imageWithPath;
  List<String>? rules;
  Brand? brand;
  List<KycPendingData>? driverData;
  VehicleInfo? vehicleData;

  GlobalDriverInfo({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.avatar,
    this.countryCode,
    this.mobile,
    this.dialCode,
    this.address,
    this.totalReviews,
    this.avgRating,
    this.onlineStatus,
    this.status,
    this.licenseNumber,
    this.licenseExpire,
    this.licensePhoto,
    this.dv,
    this.vv,
    this.riderRuleId,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.tsc,
    this.banReason,
    this.createdAt,
    this.updatedAt,
    this.imageWithPath,
    this.rules,
    this.brand,
    this.driverData,
    this.vehicleData,
  });

  factory GlobalDriverInfo.fromJson(Map<String, dynamic> json) {
    return GlobalDriverInfo(
      id: json["id"].toString(),
      firstname: json["firstname"].toString(),
      lastname: json["lastname"].toString(),
      username: json["username"].toString(),
      email: json["email"].toString(),
      avatar: json["image"].toString(),
      countryCode: json["country_code"].toString(),
      mobile: json["mobile"].toString(),
      dialCode: json["dial_code"] == null ? "93" : json["dial_code"].toString(),
      address: json["address"].toString(),
      brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
      totalReviews: json["total_reviews"].toString(),
      avgRating: json["avg_rating"].toString(),
      onlineStatus: json["online_status"].toString(),
      status: json["status"].toString(),
      licenseNumber: json["license_number"].toString(),
      licenseExpire: json["license_expire"] == null
          ? null
          : json["license_expire"].toString().toString(),
      licensePhoto: json["license_photo"].toString(),
      dv: json["dv"].toString(),
      vv: json["vv"].toString(),
      riderRuleId: json["rider_rule_id"] == null
          ? []
          : List<String>.from(json["rider_rule_id"]!.map((x) => x)),
      ev: json["ev"].toString(),
      sv: json["sv"].toString(),
      profileComplete: json["profile_complete"].toString(),
      verCodeSendAt: json["ver_code_send_at"].toString(),
      tsc: json["tsc"].toString(),
      banReason: json["ban_reason"].toString(),
      createdAt:
          json["created_at"] == null ? null : json["created_at"].toString(),
      updatedAt:
          json["updated_at"] == null ? null : json["updated_at"].toString(),
      imageWithPath: json["image_with_path"] == null
          ? null
          : json["image_with_path"].toString(),
      rules: json["rules"] == null
          ? []
          : List<String>.from(json["rules"]!.map((x) => x)),
      driverData: json["driver_data"] == null
          ? []
          : List<KycPendingData>.from(
              json["driver_data"]!.map((x) => KycPendingData.fromJson(x)),
            ),
      vehicleData: json["vehicle"] == null
          ? null
          : VehicleInfo.fromJson(json["vehicle"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "avatar": avatar,
        "country_code": countryCode,
        "mobile": mobile,
        "dial_code": dialCode,
        "address": address,
        "total_reviews": totalReviews,
        "avg_rating": avgRating,
        "online_status": onlineStatus,
        "status": status,
        "license_number": licenseNumber,
        "license_expire": licenseExpire,
        "license_photo": licensePhoto,
        "dv": dv,
        "vv": vv,
        "rider_rule_id": riderRuleId == null
            ? []
            : List<dynamic>.from(riderRuleId!.map((x) => x)),
        "ev": ev,
        "sv": sv,
        "profile_complete": profileComplete,
        "ver_code_send_at": verCodeSendAt,
        "tsc": tsc,
        "ban_reason": banReason,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_with_path": imageWithPath,
        "rules": rules,
        "brand": brand?.toJson(),
        "vehicle": vehicleData?.toJson(),
      };
  String getFullName() {
    return "${firstname ?? ""} ${lastname ?? ""}".trim();
  }
}

class Rule {
  String? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  Rule({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        id: json["id"].toString(),
        name: json["name"],
        status: json["status"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class KycPendingData {
  String? name;
  String? type;
  String? value;

  KycPendingData({this.name, this.type, this.value});

  factory KycPendingData.fromJson(Map<String, dynamic> json) => KycPendingData(
        name: json["name"],
        type: json["type"],
        value: json["value"] != null ? json["value"].toString() : "",
      );

  Map<String, dynamic> toJson() => {"name": name, "type": type, "value": value};
}

class VehicleInfo {
  final String? id;
  final String? driverId;
  final String? serviceId;
  final String? brandId;
  final String? colorId;
  final String? yearId;
  final String? modelId;
  final String? image;
  final String? vehicleNumber;
  final List<KycPendingData>? formData;
  final String? createdAt;
  final String? updatedAt;
  final String? imageSrc;
  final VerifyElement? model;
  final VerifyElement? color;
  final VerifyElement? year;

  VehicleInfo({
    this.id,
    this.driverId,
    this.serviceId,
    this.brandId,
    this.colorId,
    this.yearId,
    this.modelId,
    this.image,
    this.vehicleNumber,
    this.formData,
    this.createdAt,
    this.updatedAt,
    this.imageSrc,
    this.model,
    this.color,
    this.year,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => VehicleInfo(
        id: json["id"].toString(),
        driverId: json["driver_id"].toString(),
        serviceId: json["service_id"].toString(),
        brandId: json["brand_id"].toString(),
        colorId: json["color_id"].toString(),
        yearId: json["year_id"].toString(),
        modelId: json["model_id"].toString(),
        image: json["image"].toString(),
        vehicleNumber: json["vehicle_number"].toString(),
        formData: json["form_data"] == null
            ? []
            : List<KycPendingData>.from(
                json["form_data"]!.map((x) => KycPendingData.fromJson(x)),
              ),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
        imageSrc: json["image_src"].toString(),
        model: json["model"] == null
            ? null
            : VerifyElement.fromJson(json["model"]),
        color: json["color"] == null
            ? null
            : VerifyElement.fromJson(json["color"]),
        year:
            json["year"] == null ? null : VerifyElement.fromJson(json["year"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "service_id": serviceId,
        "brand_id": brandId,
        "color_id": colorId,
        "year_id": yearId,
        "model_id": modelId,
        "image": image,
        "vehicle_number": vehicleNumber,
        "form_data": formData == null
            ? []
            : List<dynamic>.from(formData!.map((x) => x.toJson())),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_src": imageSrc,
        "model": model?.toJson(),
        "color": color?.toJson(),
        "year": year?.toJson(),
      };
}

class VerifyElement {
  final String? id;
  final String? name;
  final String? status;
  final String? brandId;
  final String? createdAt;
  final String? updatedAt;

  VerifyElement({
    this.id,
    this.name,
    this.status,
    this.brandId,
    this.createdAt,
    this.updatedAt,
  });

  factory VerifyElement.fromJson(Map<String, dynamic> json) => VerifyElement(
        id: json["id"].toString(),
        name: json["name"].toString(),
        status: json["status"].toString(),
        brandId: json["brand_id"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "brand_id": brandId,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}
