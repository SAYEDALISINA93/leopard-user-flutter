// To parse this JSON data, do
//
//     final gatewayListResponseModel = gatewayListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_meassage_model.dart';

RideMessageListResponseModel rideMeassageListResponseModelFromJson(
        String str) =>
    RideMessageListResponseModel.fromJson(json.decode(str));

String rideMeassageListResponseModelToJson(RideMessageListResponseModel data) =>
    json.encode(data.toJson());

class RideMessageListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  RideMessageListResponseModel({
    this.remark,
    this.status,
    this.data,
    this.message,
  });

  factory RideMessageListResponseModel.fromJson(Map<String, dynamic> json) =>
      RideMessageListResponseModel(
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
  List<RideMessage>? messages;
  String? imagePath;
  Data({
    this.messages,
    this.imagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      messages: json["messages"] == null
          ? null
          : List<RideMessage>.from(
              json["messages"]!.map((x) => RideMessage.fromJson(x))),
      imagePath: json["image_path"]);

  Map<String, dynamic> toJson() => {
        "messages": messages?.map((x) => x.toJson()).toList(),
        "image_path": imagePath
      };
}

class MessageMainData {
  List<RideMessage>? data;
  String? nextPageUrl;

  MessageMainData({
    this.data,
    this.nextPageUrl,
  });

  factory MessageMainData.fromJson(Map<String, dynamic> json) =>
      MessageMainData(
        data: json["data"] == null
            ? []
            : List<RideMessage>.from(
                json["data"]!.map((x) => RideMessage.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<RideMessage>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
