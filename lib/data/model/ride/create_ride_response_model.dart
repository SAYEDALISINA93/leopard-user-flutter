// To parse this JSON data, do
//
//     final createRideResponseModel = createRideResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';

CreateRideResponseModel createRideResponseModelFromJson(String str) =>
    CreateRideResponseModel.fromJson(json.decode(str));

String createRideResponseModelToJson(CreateRideResponseModel data) =>
    json.encode(data.toJson());

class CreateRideResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CreateRideResponseModel({this.remark, this.status, this.message, this.data});

  factory CreateRideResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateRideResponseModel(
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

  Data({this.ride});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ride: json["ride"] == null ? null : RideModel.fromJson(json["ride"]),
      );

  Map<String, dynamic> toJson() => {"ride": ride?.toJson()};
}
