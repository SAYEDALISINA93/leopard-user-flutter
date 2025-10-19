// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

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
  List<KycPendingData>? vehicleData;

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
      riderRuleId: _parseStringList(json["rider_rule_id"]),
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
      rules: _parseStringList(json["rules"]),
      driverData: _parseKycList(json["driver_data"]),
      vehicleData: _parseKycList(json["vehicle_data"]),
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
      };
}

// Safely parse a list of strings that may arrive as:
// - List<dynamic>
// - JSON-encoded String (e.g. "[\"a\",\"b\"]")
// - Comma-separated String (e.g. "a,b,c")
List<String> _parseStringList(dynamic value) {
  if (value == null) return [];

  if (value is List) {
    return value
        .map((e) => e?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }

  if (value is String) {
    final v = value.trim();
    if (v.isEmpty) return [];

    // Try JSON decode if looks like JSON array
    if (v.startsWith('[') && v.endsWith(']')) {
      try {
        final decoded = jsonDecode(v);
        if (decoded is List) {
          return decoded
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } catch (_) {
        // fallthrough to comma-split
      }
    }

    // Fallback: comma-separated values or single string
    if (v.contains(',')) {
      return v
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [v];
  }

  // Unknown format
  return [];
}

// Safely parse a list of KycPendingData that may arrive as:
// - List<dynamic> of Map
// - JSON-encoded String representing a List of Map
List<KycPendingData> _parseKycList(dynamic value) {
  if (value == null) return [];

  Iterable<dynamic> items;

  if (value is List) {
    items = value;
  } else if (value is String) {
    final v = value.trim();
    if (v.isEmpty) return [];
    try {
      final decoded = jsonDecode(v);
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map<String, dynamic>) {
        items = [decoded];
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  } else {
    return [];
  }

  return items
      .where((e) => e is Map<String, dynamic>)
      .map((e) => KycPendingData.fromJson(e as Map<String, dynamic>))
      .toList();
}

class Rule {
  String? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  Rule({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

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

  KycPendingData({
    this.name,
    this.type,
    this.value,
  });

  factory KycPendingData.fromJson(Map<String, dynamic> json) => KycPendingData(
        name: json["name"],
        type: json["type"],
        value: json["value"] != null ? json["value"].toString() : "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "value": value,
      };
}
