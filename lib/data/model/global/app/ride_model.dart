// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_null_aware_operators

import 'package:leoparduser/data/model/global/app/app_coupon_model.dart';
import 'package:leoparduser/data/model/global/app/app_service_model.dart';
import 'package:leoparduser/data/model/global/app/review_model.dart';
import 'package:leoparduser/data/model/global/user/global_driver_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';

class RideModel {
  String? id; //
  String? uid;
  String? userId; //
  String? driverId; //
  String? serviceId; //
  String? pickupLocation;
  String? pickupLatitude;
  String? pickupLongitude;
  String? destination;
  String? duration;
  String? distance;
  String? destinationLatitude;
  String? destinationLongitude;
  String? recommendAmount;
  String? minAmount;
  String? maxAmount;
  String? offerAmount;
  String? discountAmount;
  String? isIntercity;
  String? note;
  String? cancelReason;
  String? canceledUserType;
  String? cancelDate;
  String? numberOfPassenger;
  String? otp;
  String? otpAccept;
  String? completedAt;
  String? amount;
  String? rideType;
  String? charge;
  String? status;
  String? paymentType;
  String? paymentStatus;
  String? cashPayment;
  String? gatewayCurrencyId;
  String? createdAt;
  String? updatedAt;
  String? bidsCount;
  String? userReviewCount;
  String? startTime;
  String? endTime;

  GlobalUser? user;
  AppService? service;

  GlobalDriverInfo? driver;
  UserReview? userReview;
  UserReview? driverReview;
  CouponModel? coupon;

  RideModel({
    this.id,
    this.uid,
    this.userId,
    this.driverId,
    this.serviceId,
    this.pickupLocation,
    this.pickupLatitude,
    this.pickupLongitude,
    this.destination,
    this.duration,
    this.distance,
    this.destinationLatitude,
    this.destinationLongitude,
    this.recommendAmount,
    this.minAmount,
    this.maxAmount,
    this.offerAmount,
    this.note,
    this.cancelReason,
    this.canceledUserType,
    this.cancelDate,
    this.numberOfPassenger,
    this.otp,
    this.amount,
    this.discountAmount,
    this.rideType,
    this.status,
    this.paymentType,
    this.paymentStatus,
    this.gatewayCurrencyId,
    this.createdAt,
    this.updatedAt,
    this.bidsCount,
    this.userReviewCount,
    this.startTime,
    this.endTime,
    this.service,
    this.user,
    this.driver,
    this.userReview,
    this.driverReview,
    this.coupon,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        id: json["id"].toString(),
        uid: json["uid"].toString(),
        userId: json["user_id"].toString(),
        driverId: json["driver_id"].toString(),
        serviceId: json["service_id"].toString(),
        pickupLocation: json["pickup_location"].toString(),
        pickupLatitude: json["pickup_latitude"].toString(),
        pickupLongitude: json["pickup_longitude"].toString(),
        destination: json["destination"].toString(),
        duration: json["duration"].toString(),
        distance: json["distance"].toString(),
        destinationLatitude: json["destination_latitude"].toString(),
        destinationLongitude: json["destination_longitude"].toString(),
        recommendAmount: json["recommend_amount"].toString(),
        minAmount: json["min_amount"].toString(),
        maxAmount: json["max_amount"].toString(),
        offerAmount: json["amount"].toString(),
        discountAmount: json["discount_amount"].toString(),
        note: json["note"].toString(),
        cancelReason: json["cancel_reason"].toString(),
        canceledUserType: json["canceled_user_type"].toString(),
        cancelDate: json["cancelled_at"].toString(),
        numberOfPassenger: json["number_of_passenger"].toString(),
        otp: json["otp"].toString(),
        amount: json["amount"].toString(),
        rideType: json["ride_type"].toString(),
        status: json["status"].toString(),
        paymentType: json["payment_type"].toString(),
        paymentStatus: json["payment_status"].toString(),
        gatewayCurrencyId: json["gateway_currency_id"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
        bidsCount:
            json["bids_count"] == null ? '0' : json["bids_count"].toString(),
        userReviewCount: json["user_review_count"] == null
            ? '0'
            : json["user_review_count"].toString(),
        startTime:
            json["start_time"] == null ? null : json["start_time"].toString(),
        endTime: json["end_time"] == null ? null : json["end_time"].toString(),
        service: json["service"] == null
            ? null
            : AppService.fromJson(json["service"]),
        userReview: json["user_review"] == null
            ? null
            : UserReview.fromJson(json["user_review"]),
        driverReview: json["driver_review"] == null
            ? null
            : UserReview.fromJson(json["driver_review"]),
        user: json["user"] == null ? null : GlobalUser.fromJson(json["user"]),
        driver: json["driver"] == null
            ? null
            : GlobalDriverInfo.fromJson(json["driver"]),
        coupon: json["coupon"] == null
            ? null
            : CouponModel.fromJson(json["coupon"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "user_id": userId,
        "driver_id": driverId,
        "service_id": serviceId,
        "pickup_location": pickupLocation,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "destination": destination,
        "duration": duration,
        "distance": distance,
        "destination_latitude": destinationLatitude,
        "destination_longitude": destinationLongitude,
        "recommend_amount": recommendAmount,
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "offer_amount": offerAmount,
        "discount_amount": discountAmount,
        "note": note,
        "cancel_reason": cancelReason,
        "canceled_user_type": canceledUserType,
        "cancelled_at": cancelDate,
        "number_of_passenger": numberOfPassenger,
        "otp": otp,
        "amount": amount,
        "ride_type": rideType,
        "status": status,
        "payment_type": paymentType,
        "gateway_currency_id": gatewayCurrencyId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "bids_count": bidsCount,
        'user_review_count': userReviewCount,
        "user": user,
        "service": service,
        "driver": driver,
        "driver_review": driverReview,
      };

  RideModel copyWith({
    String? id,
    String? uid,
    String? userId,
    String? driverId,
    String? serviceId,
    String? pickupLocation,
    String? pickupLatitude,
    String? pickupLongitude,
    String? destination,
    String? duration,
    String? distance,
    String? destinationLatitude,
    String? destinationLongitude,
    String? recommendAmount,
    String? minAmount,
    String? maxAmount,
    String? offerAmount,
    String? isIntercity,
    String? note,
    String? cancelReason,
    String? canceledUserType,
    String? cancelDate,
    String? numberOfPassenger,
    String? otp,
    String? otpAccept,
    String? completedAt,
    String? isAccepted,
    String? isRunning,
    String? amount,
    String? charge,
    String? appliedCouponId,
    String? status,
    String? paymentType,
    String? paymentStatus,
    String? cashPayment,
    String? gatewayCurrencyId,
    String? createdAt,
    String? updatedAt,
    String? bidsCount,
    String? userReviewCount,
    GlobalUser? user,
    AppService? service,
    GlobalDriverInfo? driver,
    UserReview? userReview,
  }) {
    return RideModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      serviceId: serviceId ?? this.serviceId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      destination: destination ?? this.destination,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      recommendAmount: recommendAmount ?? this.recommendAmount,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      offerAmount: offerAmount ?? this.offerAmount,
      note: note ?? this.note,
      cancelReason: cancelReason ?? this.cancelReason,
      canceledUserType: canceledUserType ?? this.canceledUserType,
      cancelDate: cancelDate ?? this.cancelDate,
      numberOfPassenger: numberOfPassenger ?? this.numberOfPassenger,
      otp: otp ?? this.otp,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentType: paymentType ?? this.paymentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      gatewayCurrencyId: gatewayCurrencyId ?? this.gatewayCurrencyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bidsCount: bidsCount ?? this.bidsCount,
      userReviewCount: userReviewCount ?? this.userReviewCount,
      user: user ?? this.user,
      service: service ?? this.service,
      driver: driver ?? this.driver,
      userReview: userReview ?? this.userReview,
    );
  }
}

class AppliedCoupon {
  String? id;
  String? userId;
  String? couponId;
  String? rideId;
  String? amount;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  AppliedCoupon({
    this.id,
    this.userId,
    this.couponId,
    this.rideId,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory AppliedCoupon.fromJson(Map<String, dynamic> json) => AppliedCoupon(
        id: json["id"].toString(),
        userId: json["user_id"].toString(),
        couponId: json["coupon_id"].toString(),
        rideId: json["ride_id"].toString(),
        amount: json["amount"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        deletedAt: json["deleted_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "coupon_id": couponId,
        "ride_id": rideId,
        "amount": amount,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
