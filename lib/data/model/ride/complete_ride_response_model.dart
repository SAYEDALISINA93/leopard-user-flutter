// To parse this JSON data, do
//
//     final completeRideResponseModel = completeRideResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';

CompleteRideResponseModel completeRideResponseModelFromJson(String str) =>
    CompleteRideResponseModel.fromJson(json.decode(str));

String completeRideResponseModelToJson(CompleteRideResponseModel data) =>
    json.encode(data.toJson());

class CompleteRideResponseModel {
  String? remark;
  String? status;
  Data? data;
  List<String>? message;

  CompleteRideResponseModel({
    this.remark,
    this.status,
    this.data,
    this.message,
  });

  factory CompleteRideResponseModel.fromJson(Map<String, dynamic> json) =>
      CompleteRideResponseModel(
        remark: json["remark"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  CompletedRides? completedRides;

  Data({
    this.completedRides,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        completedRides: json["completed_rides"] == null
            ? null
            : CompletedRides.fromJson(json["completed_rides"]),
      );

  Map<String, dynamic> toJson() => {
        "completed_rides": completedRides?.toJson(),
      };
}

class CompletedRides {
  List<RideModel>? data;

  String? nextPageUrl;

  CompletedRides({
    this.data,
    this.nextPageUrl,
  });

  factory CompletedRides.fromJson(Map<String, dynamic> json) => CompletedRides(
        data: json["data"] == null
            ? []
            : List<RideModel>.from(
                json["data"]!.map((x) => RideModel.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<RideModel>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
