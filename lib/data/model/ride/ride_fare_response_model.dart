// To parse this JSON data, do
//
//     final rideFareResponseModel = rideFareResponseModelFromJson(jsonString);

import 'dart:convert';

RideFareResponseModel rideFareResponseModelFromJson(String str) => RideFareResponseModel.fromJson(json.decode(str));

String rideFareResponseModelToJson(RideFareResponseModel data) => json.encode(data.toJson());

class RideFareResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  RideFareModel? data;

  RideFareResponseModel({this.remark, this.status, this.message, this.data});

  factory RideFareResponseModel.fromJson(Map<String, dynamic> json) => RideFareResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x.toString())),
        data: json["data"] == null ? null : RideFareModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class RideFareModel {
  String? status; //
  String? distance; //
  String? duration;
  String? recommendAmount; //
  String? minAmount; //
  String? maxAmount; //
  String? intraCity; //
  List<String>? originAddresses;
  List<String>? destinationAddresses;

  RideFareModel({
    this.status,
    this.distance,
    this.duration,
    this.recommendAmount,
    this.minAmount,
    this.maxAmount,
    this.intraCity,
    this.originAddresses,
    this.destinationAddresses,
  });

  factory RideFareModel.fromJson(Map<String, dynamic> json) => RideFareModel(
        status: json["status"].toString(),
        distance: json["distance"].toString(),
        duration: json["duration"].toString(),
        recommendAmount: json["recommend_amount"].toString(),
        minAmount: json["min_amount"].toString(),
        maxAmount: json["max_amount"].toString(),
        intraCity: json["intra_city"].toString(),
        originAddresses: json["origin_addresses"] == null ? [] : List<String>.from(json["origin_addresses"]!.map((x) => x)),
        destinationAddresses: json["destination_addresses"] == null ? [] : List<String>.from(json["destination_addresses"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "distance": distance,
        "duration": duration,
        "recommend_amount": recommendAmount,
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "intra_city": intraCity,
        "origin_addresses": originAddresses == null ? [] : List<dynamic>.from(originAddresses!.map((x) => x)),
        "destination_addresses": destinationAddresses == null ? [] : List<dynamic>.from(destinationAddresses!.map((x) => x)),
      };
}
