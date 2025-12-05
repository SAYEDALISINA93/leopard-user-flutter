// To parse this JSON data, do
//
//     final allResponseModel = allResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_model.dart';

AllResponseModel allResponseModelFromJson(String str) =>
    AllResponseModel.fromJson(json.decode(str));

String allResponseModelToJson(AllResponseModel data) =>
    json.encode(data.toJson());

class AllResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  AllResponseModel({this.remark, this.status, this.message, this.data});

  factory AllResponseModel.fromJson(Map<String, dynamic> json) =>
      AllResponseModel(
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
  Rides? rides;

  Data({this.rides});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(rides: json["rides"] == null ? null : Rides.fromJson(json["rides"]));

  Map<String, dynamic> toJson() => {"rides": rides?.toJson()};
}

class Rides {
  int? currentPage;
  List<RideModel>? data;
  String? nextPageUrl;

  Rides({this.currentPage, this.data, this.nextPageUrl});

  factory Rides.fromJson(Map<String, dynamic> json) => Rides(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<RideModel>.from(
                json["data"]!.map((x) => RideModel.fromJson(x)),
              ),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
