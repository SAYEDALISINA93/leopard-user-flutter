// To parse this JSON data, do
//
//     final bidListResponseModel = bidListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/bid/bid_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';

BidListResponseModel bidListResponseModelFromJson(String str) =>
    BidListResponseModel.fromJson(json.decode(str));

String bidListResponseModelToJson(BidListResponseModel data) =>
    json.encode(data.toJson());

class BidListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  BidListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory BidListResponseModel.fromJson(Map<String, dynamic> json) =>
      BidListResponseModel(
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
  List<BidModel>? bids;
  RideModel? ride;
  String? userImagePath;
  String? driverImagePath;
  Data({
    this.bids,
    this.ride,
    this.userImagePath,
    this.driverImagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bids: json["bids"] == null
            ? []
            : List<BidModel>.from(
                json["bids"]!.map((x) => BidModel.fromJson(x))),
        ride: json["ride"] == null ? null : RideModel.fromJson(json["ride"]),
        userImagePath: json["user_image_path"],
        driverImagePath: json["driver_image_path"],
      );

  Map<String, dynamic> toJson() => {
        "bids": bids == null
            ? []
            : List<dynamic>.from(bids!.map((x) => x.toJson())),
        "ride": ride?.toJson(),
      };
}
