// To parse this JSON data, do
//
//     final couponListResponseModel = couponListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/app_coupon_model.dart';

CouponListResponseModel couponListResponseModelFromJson(String str) =>
    CouponListResponseModel.fromJson(json.decode(str));

String couponListResponseModelToJson(CouponListResponseModel data) =>
    json.encode(data.toJson());

class CouponListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CouponListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CouponListResponseModel.fromJson(Map<String, dynamic> json) =>
      CouponListResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? null
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
  List<CouponModel>? coupons;

  Data({
    this.coupons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        coupons: json["coupons"] == null
            ? []
            : List<CouponModel>.from(
                json["coupons"]!.map((x) => CouponModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "coupons": coupons == null
            ? []
            : List<dynamic>.from(coupons!.map((x) => x.toJson())),
      };
}
