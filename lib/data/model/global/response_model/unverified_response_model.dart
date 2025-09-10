// To parse this JSON data, do
//
//     final unVarifiedUserResponseModel = unVarifiedUserResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/user/global_user_model.dart';

UnVerifiedUserResponseModel unVarifiedUserResponseModelFromJson(String str) =>
    UnVerifiedUserResponseModel.fromJson(json.decode(str));

String unVarifiedUserResponseModelToJson(UnVerifiedUserResponseModel data) =>
    json.encode(data.toJson());

class UnVerifiedUserResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  UnVerifiedUserResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory UnVerifiedUserResponseModel.fromJson(Map<String, dynamic> json) =>
      UnVerifiedUserResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json['message'] != null
            ? List<String>.from(json["message"]!.map((x) => x.toString()))
            : [],
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
  String? isBan;
  String? emailVerified;
  String? mobileVerified;
  GlobalUser? user;

  Data({this.isBan, this.emailVerified, this.mobileVerified, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isBan: json["is_ban"].toString(),
        emailVerified: json["email_verified"].toString(),
        mobileVerified: json["mobile_verified"].toString(),
        user: json['user'] != null ? GlobalUser.fromJson(json['user']) : null,
      );

  Map<String, dynamic> toJson() => {
        "is_ban": isBan,
        "email_verified": emailVerified,
        "mobile_verified": mobileVerified,
      };
}
