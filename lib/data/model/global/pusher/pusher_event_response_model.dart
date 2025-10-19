// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final pusherResponseModel = pusherResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:leoparduser/data/model/global/app/ride_meassage_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/bid/bid_model.dart';

PusherResponseModel pusherResponseModelFromJson(String str) =>
    PusherResponseModel.fromJson(json.decode(str));

class PusherResponseModel {
  String? channelName;
  String? eventName;
  Data? data;

  PusherResponseModel({this.channelName, this.eventName, this.data});

  PusherResponseModel copyWith({
    String? channelName,
    String? eventName,
    Data? data,
  }) =>
      PusherResponseModel(
        channelName: channelName.toString(),
        eventName: eventName.toString(),
        data: data,
      );

  factory PusherResponseModel.fromJson(Map<String, dynamic> json) {
    return PusherResponseModel(
      channelName: json["channelName"]?.toString(),
      eventName: json["eventName"]?.toString(),
      data: json["data"] is Map<String, dynamic>
          ? Data.fromJson(json["data"] as Map<String, dynamic>)
          : null,
    );
  }
}

class Data {
  String? remark;
  String? userId;
  String? driverId;
  String? rideId;
  RideMessage? message;
  String? driverLatitude;
  String? driverLongitude;
  RideModel? ride;
  BidModel? bid;
  Data({
    this.remark,
    this.userId,
    this.driverId,
    this.rideId,
    this.message,
    this.driverLatitude,
    this.driverLongitude,
    this.ride,
    this.bid,
  });

  Data copyWith({
    String? channelName,
    String? eventName,
    String? remark,
    String? userId,
    String? driverId,
    String? rideId,
    RideMessage? message,
    String? driverLatitude,
    String? driverLongitude,
    RideModel? ride,
    BidModel? bid,
  }) =>
      Data(
        remark: remark.toString(),
        userId: userId.toString(),
        driverId: driverId.toString(),
        rideId: rideId.toString(),
        message: message,
        driverLatitude: driverLatitude ?? '',
        driverLongitude: driverLongitude ?? '',
        ride: ride,
        bid: bid,
      );

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      remark: json["remark"]?.toString(),
      userId: json["userId"]?.toString(),
      driverId: json["driverId"]?.toString(),
      rideId: json["rideId"]?.toString(),
      message: json["message"] is Map<String, dynamic>
          ? RideMessage.fromJson(json["message"] as Map<String, dynamic>)
          : null,
      driverLatitude: json["latitude"]?.toString(),
      driverLongitude: json["longitude"]?.toString(),
      ride: json["ride"] is Map<String, dynamic>
          ? RideModel.fromJson(json["ride"] as Map<String, dynamic>)
          : null,
      bid: json["bid"] is Map<String, dynamic>
          ? BidModel.fromJson(json["bid"] as Map<String, dynamic>)
          : null,
    );
  }
}
