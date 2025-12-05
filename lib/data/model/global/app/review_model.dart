class UserReview {
  String? id;
  String? rideId;
  String? userId;
  String? driverId;
  String? rating;
  String? review;
  String? createdAt;
  String? updatedAt;

  UserReview({
    this.id,
    this.rideId,
    this.userId,
    this.driverId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
        id: json["id"].toString(),
        rideId: json["ride_id"].toString(),
        userId: json["user_id"].toString(),
        driverId: json["driver_id"].toString(),
        rating: json["rating"].toString(),
        review: json["review"].toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ride_id": rideId,
        "user_id": userId,
        "driver_id": driverId,
        "rating": rating,
        "review": review,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}
