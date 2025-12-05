class CouponModel {
  String? id; //
  String? name;
  String? code;
  String? startFrom;
  String? endAt;
  String? minimumAmount;
  String? discountType; //
  String? amount;
  String? maximumUsingTime; //
  String? description;
  String? status; //
  String? createdAt;
  String? updatedAt;

  CouponModel({
    this.id,
    this.name,
    this.code,
    this.startFrom,
    this.endAt,
    this.minimumAmount,
    this.discountType,
    this.amount,
    this.maximumUsingTime,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
        code: json["code"].toString(),
        startFrom: json["start_from"]?.toString(),
        endAt: json["end_at"]?.toString(),
        minimumAmount: json["minimum_amount"].toString(),
        discountType: json["discount_type"].toString(),
        amount: json["amount"].toString(),
        maximumUsingTime: json["maximum_using_time"].toString(),
        description: json["description"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "start_from": startFrom,
        "end_at": endAt,
        "minimum_amount": minimumAmount,
        "discount_type": discountType,
        "amount": amount,
        "maximum_using_time": maximumUsingTime,
        "description": description,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
