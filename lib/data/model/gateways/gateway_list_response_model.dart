// To parse this JSON data, do
//
//     final gatewayListResponseModel = gatewayListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/app_payment_method.dart';

GatewayListResponseModel gatewayListResponseModelFromJson(String str) =>
    GatewayListResponseModel.fromJson(json.decode(str));

String gatewayListResponseModelToJson(GatewayListResponseModel data) =>
    json.encode(data.toJson());

class GatewayListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  GatewayListResponseModel({this.remark, this.status, this.message, this.data});

  factory GatewayListResponseModel.fromJson(Map<String, dynamic> json) =>
      GatewayListResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"]!.map((x) => x.toString())),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<AppPaymentMethod>? gatewayCurrency;

  Data({this.gatewayCurrency});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        gatewayCurrency: json["gateway_currency"] == null
            ? []
            : List<AppPaymentMethod>.from(
                json["gateway_currency"]!.map(
                  (x) => AppPaymentMethod.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "gateway_currency": gatewayCurrency == null
            ? []
            : List<AppPaymentMethod>.from(
                gatewayCurrency!.map((x) => x.toJson()),
              ),
      };
}
