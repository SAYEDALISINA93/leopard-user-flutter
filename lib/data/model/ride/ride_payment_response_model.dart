// To parse this JSON data, do
//
//     final ridePaymentResponseModel = ridePaymentResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/app_coupon_model.dart';
import 'package:leoparduser/data/model/global/app/app_payment_method.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';

RidePaymentResponseModel ridePaymentResponseModelFromJson(String str) =>
    RidePaymentResponseModel.fromJson(json.decode(str));

String ridePaymentResponseModelToJson(RidePaymentResponseModel data) =>
    json.encode(data.toJson());

class RidePaymentResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  RidePaymentResponseModel({this.remark, this.status, this.message, this.data});

  factory RidePaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      RidePaymentResponseModel(
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
  RideModel? ride;
  List<CouponModel>? coupons;
  List<AppPaymentMethod>? gatewayCurrency;
  String? gatewayImage;
  String? driverImage;

  Data({
    this.ride,
    this.coupons,
    this.gatewayCurrency,
    this.gatewayImage,
    this.driverImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ride: json["ride"] == null ? null : RideModel.fromJson(json["ride"]),
        coupons: json["coupons"] == null
            ? []
            : List<CouponModel>.from(
                json["coupons"]!.map((x) => CouponModel.fromJson(x)),
              ),
        gatewayCurrency: json["gateways"] == null
            ? []
            : List<AppPaymentMethod>.from(
                json["gateways"]!.map((x) => AppPaymentMethod.fromJson(x)),
              ),
        gatewayImage: json["image_path"].toString(),
        driverImage: json["driver_image_path"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "ride": ride?.toJson(),
        "coupons": coupons == null
            ? []
            : List<dynamic>.from(coupons!.map((x) => x.toJson())),
        "gateways": gatewayCurrency == null
            ? []
            : List<dynamic>.from(gatewayCurrency!.map((x) => x.toJson())),
        "driver_image_path": driverImage,
      };
}
