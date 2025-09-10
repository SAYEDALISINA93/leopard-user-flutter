// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final pusherResponseModel = pusherResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovorideuser/data/model/global/app/app_service_model.dart';
import 'package:ovorideuser/data/model/global/app/ride_meassage_model.dart';
import 'package:ovorideuser/data/model/global/app/ride_model.dart';
import 'package:ovorideuser/data/model/global/bid/bid_model.dart';

PusherResponseModel pusherResponseModelFromJson(String str) => PusherResponseModel.fromJson(json.decode(str));

class PusherResponseModel {
  String? channelName;
  String? eventName;
  EventData? data;

  PusherResponseModel({this.channelName, this.eventName, this.data});

  PusherResponseModel copyWith({
    String? channelName,
    String? eventName,
    EventData? data,
  }) =>
      PusherResponseModel(
        channelName: channelName.toString(),
        eventName: eventName.toString(),
        data: data,
      );

  factory PusherResponseModel.fromJson(Map<String, dynamic> json) {
    return PusherResponseModel(
      channelName: json["channelName"].toString(),
      eventName: json["eventName"].toString(),
      data: EventData.fromJson(json["data"]),
    );
  }
}

class EventData {
  String? remark;
  String? userId;
  String? driverId;
  String? rideId;
  String? driverTotalRide;
  RideMessage? message;
  String? driverLatitude;
  String? driverLongitude;
  RideModel? ride;
  AppService? service;
  BidModel? bid;
  EventData({
    this.remark,
    this.userId,
    this.driverId,
    this.rideId,
    this.driverTotalRide,
    this.message,
    this.driverLatitude,
    this.driverLongitude,
    this.ride,
    this.service,
    this.bid,
  });

  EventData copyWith({
    String? channelName,
    String? eventName,
    String? remark,
    String? userId,
    String? driverId,
    String? rideId,
    String? driverTotalRide,
    RideMessage? message,
    String? driverLatitude,
    String? driverLongitude,
    RideModel? ride,
    AppService? service,
    BidModel? bid,
  }) =>
      EventData(
        remark: remark.toString(),
        userId: userId.toString(),
        driverId: driverId.toString(),
        rideId: rideId.toString(),
        driverTotalRide: driverTotalRide.toString(),
        message: message,
        driverLatitude: driverLatitude ?? '',
        driverLongitude: driverLongitude ?? '',
        ride: ride,
        service: service,
        bid: bid,
      );

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      remark: json["remark"].toString(),
      userId: json["userId"].toString(),
      driverId: json["driverId"].toString(),
      rideId: json["rideId"].toString(),
      driverTotalRide: json["driver_total_ride"].toString(),
      message: json["message"] != null ? RideMessage.fromJson(json["message"]) : null,
      driverLatitude: json["latitude"].toString(),
      driverLongitude: json["longitude"].toString(),
      ride: json["ride"] != null ? RideModel.fromJson(json["ride"]) : null,
      service: json["service"] != null ? AppService.fromJson(json["service"]) : null,
      bid: json["bid"] != null ? BidModel.fromJson(json["bid"]) : null,
    );
  }
}
