// To parse this JSON data, do
//
//     final cancelRideListResponseModel = cancelRideListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';

CancelRideListResponseModel cancelRideListResponseModelFromJson(String str) =>
    CancelRideListResponseModel.fromJson(json.decode(str));

String cancelRideListResponseModelToJson(CancelRideListResponseModel data) =>
    json.encode(data.toJson());

class CancelRideListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CancelRideListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CancelRideListResponseModel.fromJson(Map<String, dynamic> json) =>
      CancelRideListResponseModel(
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
  CancelRideData? cancelRides;

  Data({
    this.cancelRides,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cancelRides: json["cancel_rides"] == null
            ? null
            : CancelRideData.fromJson(json["cancel_rides"]),
      );

  Map<String, dynamic> toJson() => {
        "cancel_rides": cancelRides?.toJson(),
      };
}

class CancelRideData {
  List<RideModel>? data;
  dynamic nextPageUrl;

  CancelRideData({
    this.data,
    this.nextPageUrl,
  });

  factory CancelRideData.fromJson(Map<String, dynamic> json) => CancelRideData(
        data: json["data"] == null
            ? []
            : List<RideModel>.from(
                json["data"]!.map((x) => RideModel.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
