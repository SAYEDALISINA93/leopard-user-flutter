// To parse this JSON data, do
//
//     final rideDetailsResponseModel = rideDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';

RideDetailsResponseModel rideDetailsResponseModelFromJson(String str) =>
    RideDetailsResponseModel.fromJson(json.decode(str));

String rideDetailsResponseModelToJson(RideDetailsResponseModel data) =>
    json.encode(data.toJson());

class RideDetailsResponseModel {
  String? remark;
  String? status;
  Data? data;
  List<String>? message;

  RideDetailsResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory RideDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      RideDetailsResponseModel(
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
  RideModel? ride;
  String? serviceImagePath;
  String? brandImagePath;
  String? driverImagePath;

  Data(
      {this.ride,
      this.serviceImagePath,
      this.brandImagePath,
      this.driverImagePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      ride: json["ride"] == null ? null : RideModel.fromJson(json["ride"]),
      serviceImagePath: json["service_image_path"],
      brandImagePath: json["brand_image_path"],
      driverImagePath: json["driver_image_path"]);

  Map<String, dynamic> toJson() => {"ride": ride?.toJson()};
}
