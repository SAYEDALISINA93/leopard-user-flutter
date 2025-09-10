// To parse this JSON data, do
//
//     final dashBoardResponseModel = dashBoardResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/app_payment_method.dart';
import 'package:leoparduser/data/model/global/app/app_service_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';

DashBoardResponseModel dashBoardResponseModelFromJson(String str) =>
    DashBoardResponseModel.fromJson(json.decode(str));

String dashBoardResponseModelToJson(DashBoardResponseModel data) =>
    json.encode(data.toJson());

class DashBoardResponseModel {
  String? remark;
  String? status;
  Data? data;
  List<String>? message;

  DashBoardResponseModel({this.remark, this.status, this.data, this.message});

  factory DashBoardResponseModel.fromJson(Map<String, dynamic> json) =>
      DashBoardResponseModel(
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
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  List<AppPaymentMethod>? paymentMethod;
  List<AppService>? services;
  GlobalUser? userInfo;
  RideModel? runningRide;
  String? serviceImagePath;
  String? gatewayImagePath;
  String? userImagePath;

  Data({
    this.paymentMethod,
    this.services,
    this.userInfo,
    this.runningRide,
    this.serviceImagePath,
    this.gatewayImagePath,
    this.userImagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentMethod: json["payment_method"] == null
            ? []
            : List<AppPaymentMethod>.from(
                json["payment_method"]!
                    .map((x) => AppPaymentMethod.fromJson(x)),
              ),
        services: json["services"] == null
            ? []
            : List<AppService>.from(
                json["services"]!.map((x) => AppService.fromJson(x)),
              ),
        userInfo:
            json["user"] == null ? null : GlobalUser.fromJson(json["user"]),
        runningRide: json["running_ride"] == null
            ? null
            : RideModel.fromJson(json["running_ride"]),
        gatewayImagePath: json["gateway_image_path"].toString(),
        serviceImagePath: json["service_image_path"].toString(),
        userImagePath: json["user_image_path"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod == null
            ? []
            : List<dynamic>.from(paymentMethod!.map((x) => x.toJson())),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "user": userInfo?.toJson(),
        "gateway_image_path": gatewayImagePath,
        "service_image_path": serviceImagePath,
        "user_image_path": userImagePath,
      };
}
