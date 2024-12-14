// To parse this JSON data, do
//
//     final activeRideResponseModel = activeRideResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';

ActiveRideResponseModel activeRideResponseModelFromJson(String str) =>
    ActiveRideResponseModel.fromJson(json.decode(str));

String activeRideResponseModelToJson(ActiveRideResponseModel data) =>
    json.encode(data.toJson());

class ActiveRideResponseModel {
  String? remark;
  String? status;
  Data? data;
  List<String>? message;

  ActiveRideResponseModel({
    this.remark,
    this.status,
    this.data,
    this.message,
  });

  factory ActiveRideResponseModel.fromJson(Map<String, dynamic> json) =>
      ActiveRideResponseModel(
        remark: json["remark"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x.toString())),
        status: json["status"],
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
  RideModel? runningRide;
  List<RideModel>? acceptedRide;
  List<RideModel>? pendingRide;

  Data({
    this.runningRide,
    this.acceptedRide,
    this.pendingRide,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        runningRide: json["running_ride"] == null
            ? null
            : RideModel.fromJson(json["running_ride"]),
        acceptedRide: json["accepted_rides"] == null
            ? []
            : List<RideModel>.from(
                json["accepted_rides"]!.map((x) => RideModel.fromJson(x))),
        pendingRide: json["pending_rides"] == null
            ? []
            : List<RideModel>.from(
                json["pending_rides"]!.map((x) => RideModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "running_ride": runningRide,
        "accepted_rides": acceptedRide == null
            ? []
            : List<dynamic>.from(acceptedRide!.map((x) => x.toJson())),
        "pending_rides": pendingRide == null
            ? []
            : List<dynamic>.from(pendingRide!.map((x) => x.toJson())),
      };
}
