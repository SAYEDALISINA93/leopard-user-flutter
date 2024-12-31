import 'package:leoparduser/data/model/global/user/global_driver_model.dart';

class BidModel {
  String? id; //
  String? rideId; //
  String? driverId; //
  String? bidAmount;
  String? acceptDate;
  String? status; //
  String? createdAt; //
  String? updatedAt; //
  GlobalDriverInfo? driver;

  BidModel({
    this.id,
    this.rideId,
    this.driverId,
    this.bidAmount,
    this.acceptDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.driver,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
        id: json["id"].toString(),
        rideId: json["ride_id"].toString(),
        driverId: json["driver_id"].toString(),
        bidAmount: json["bid_amount"].toString(),
        acceptDate: json["accept_date"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        driver: json["driver"] == null
            ? null
            : GlobalDriverInfo.fromJson(json["driver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ride_id": rideId,
        "driver_id": driverId,
        "bid_amount": bidAmount,
        "accept_date": acceptDate,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "driver": driver?.toJson(),
      };
}
