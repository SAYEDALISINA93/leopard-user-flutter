// To parse this JSON data, do
//
//     final paymentHistoryResponseModel = paymentHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/user/global_driver_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';

PaymentHistoryResponseModel paymentHistoryResponseModelFromJson(String str) =>
    PaymentHistoryResponseModel.fromJson(json.decode(str));

String paymentHistoryResponseModelToJson(PaymentHistoryResponseModel data) =>
    json.encode(data.toJson());

class PaymentHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  PaymentHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class Data {
  PaymentHistory? payments;

  Data({
    this.payments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payments: json["payments"] == null
            ? null
            : PaymentHistory.fromJson(json["payments"]),
      );

  Map<String, dynamic> toJson() => {
        "payments": payments?.toJson(),
      };
}

class PaymentHistory {
  List<PaymentHistoryData>? data;

  dynamic nextPageUrl;

  PaymentHistory({
    this.data,
    this.nextPageUrl,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        data: json["data"] == null
            ? []
            : List<PaymentHistoryData>.from(
                json["data"]!.map((x) => PaymentHistoryData.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}

class PaymentHistoryData {
  String? id; //
  String? rideId; //
  String? riderId; //
  String? driverId; //
  String? amount;
  String? paymentType; //
  String? createdAt;
  String? updatedAt;
  GlobalUser? rider;
  RideModel? ride;
  GlobalDriverInfo? driver;

  PaymentHistoryData({
    this.id,
    this.rideId,
    this.riderId,
    this.driverId,
    this.amount,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
    this.rider,
    this.ride,
    this.driver,
  });

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryData(
        id: json["id"].toString(),
        rideId: json["ride_id"].toString(),
        riderId: json["rider_id"].toString(),
        driverId: json["driver_id"].toString(),
        amount: json["amount"].toString(),
        paymentType: json["payment_type"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        rider:
            json["rider"] == null ? null : GlobalUser.fromJson(json["rider"]),
        ride: json["ride"] == null ? null : RideModel.fromJson(json["ride"]),
        driver: json["driver"] == null
            ? null
            : GlobalDriverInfo.fromJson(json["driver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ride_id": rideId,
        "rider_id": riderId,
        "driver_id": driverId,
        "amount": amount,
        "payment_type": paymentType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "rider": rider?.toJson(),
        "ride": ride,
        "driver": driver?.toJson(),
      };
}
