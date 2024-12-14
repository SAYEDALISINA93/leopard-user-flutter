import 'package:leoparduser/data/model/global/app/vehicle_brand_model.dart';

class Vehicle {
  String? id;
  String? serviceId;
  String? driverId;
  String? brandId;
  List<VehicleData>? vehicleData;
  String? createdAt;
  String? updatedAt;
  Brand? brand;

  Vehicle({
    this.id,
    this.serviceId,
    this.driverId,
    this.brandId,
    this.vehicleData,
    this.createdAt,
    this.updatedAt,
    this.brand,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"].toString(),
        serviceId: json["service_id"].toString(),
        driverId: json["driver_id"].toString(),
        brandId: json["brand_id"].toString(),
        vehicleData: json["vehicle_data"] == null
            ? []
            : List<VehicleData>.from(
                json["vehicle_data"]!.map((x) => VehicleData.fromJson(x))),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "driver_id": driverId,
        "brand_id": brandId,
        "vehicle_data": vehicleData == null
            ? []
            : List<dynamic>.from(vehicleData!.map((x) => x.toJson())),
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "brand": brand?.toJson(),
      };
}

class VehicleData {
  String? name;
  String? type;
  String? value;

  VehicleData({
    this.name,
    this.type,
    this.value,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) => VehicleData(
        name: json["name"].toString(),
        type: json["type"].toString(),
        value: json["value"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "value": value,
      };
}
