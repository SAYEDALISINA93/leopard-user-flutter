class RideMessage {
  String? id;
  String? rideId;
  String? userId;
  String? driverId;
  String? message;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageWithPath;

  RideMessage({
    this.id,
    this.rideId,
    this.userId,
    this.driverId,
    this.message,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageWithPath,
  });

  factory RideMessage.fromJson(Map<String, dynamic> json) => RideMessage(
        id: json["id"].toString(),
        rideId: json["ride_id"].toString(),
        userId: json["user_id"].toString(),
        driverId: json["driver_id"].toString(),
        message: json["message"].toString(),
        image: json["image"].toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        imageWithPath: json["image_with_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ride_id": rideId,
        "user_id": userId,
        "driver_id": driverId,
        "message": message,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_with_path": imageWithPath,
      };
}
