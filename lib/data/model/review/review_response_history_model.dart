import 'dart:convert';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';

ReviewHistoryResponseModel reviewHistoryResponseModelFromJson(String str) =>
    ReviewHistoryResponseModel.fromJson(json.decode(str));

String reviewHistoryResponseModelToJson(ReviewHistoryResponseModel data) =>
    json.encode(data.toJson());

class ReviewHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  ReviewHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory ReviewHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      ReviewHistoryResponseModel(
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
  List<Review>? reviews;
  String? userImagePath;

  Data({
    this.reviews,
    this.userImagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
        userImagePath: json["user_image_path"],
      );

  Map<String, dynamic> toJson() => {
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "user_image_path": userImagePath,
      };
}

class Review {
  String? id;
  String? userId;
  String? driverId;
  String? rideId;
  String? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  GlobalUser? user;

  Review({
    this.id,
    this.userId,
    this.driverId,
    this.rideId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"].toString(),
        userId: json["user_id"].toString(),
        driverId: json["driver_id"].toString(),
        rideId: json["ride_id"].toString(),
        rating: json["rating"].toString(),
        review: json["review"].toString(),
        user: json['user'] == null ? null : GlobalUser.fromJson(json['user']),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "driver_id": driverId,
        "ride_id": rideId,
        "rating": rating,
        "review": review,
        "user": user,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
