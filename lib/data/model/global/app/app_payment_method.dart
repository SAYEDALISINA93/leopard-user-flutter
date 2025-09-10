import 'package:leoparduser/data/model/global/app/app_service_model.dart';

class AppPaymentMethod {
  String? id;
  String? name;
  String? currency;
  String? symbol;
  String? methodCode;
  String? gatewayAlias;
  String? minAmount;
  String? maxAmount;
  String? percentCharge;
  String? fixedCharge;
  String? rate;
  String? image;
  String? createdAt;
  String? updatedAt;
  AppService? method;

  AppPaymentMethod({
    this.id,
    this.name,
    this.currency,
    this.symbol,
    this.methodCode,
    this.gatewayAlias,
    this.minAmount,
    this.maxAmount,
    this.percentCharge,
    this.fixedCharge,
    this.rate,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.method,
  });

  factory AppPaymentMethod.fromJson(Map<String, dynamic> json) =>
      AppPaymentMethod(
        id: json["id"].toString(),
        name: json["name"].toString(),
        currency: json["currency"].toString(),
        symbol: json["symbol"].toString(),
        methodCode: json["method_code"].toString(),
        gatewayAlias: json["gateway_alias"].toString(),
        minAmount: json["min_amount"].toString(),
        maxAmount: json["max_amount"].toString(),
        percentCharge: json["percent_charge"].toString(),
        fixedCharge: json["fixed_charge"].toString(),
        rate: json["rate"].toString(),
        image: json["image"].toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        method:
            json["method"] == null ? null : AppService.fromJson(json["method"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "currency": currency,
        "symbol": symbol,
        "method_code": methodCode,
        "gateway_alias": gatewayAlias,
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "percent_charge": percentCharge,
        "fixed_charge": fixedCharge,
        "rate": rate,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "method": method?.toJson(),
      };
}
