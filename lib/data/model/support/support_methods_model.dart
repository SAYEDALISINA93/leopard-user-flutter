// To parse this JSON data, do
//
//     final supportMethods = supportMethodsFromJson(jsonString);

import 'dart:convert';

SupportMethods supportMethodsFromJson(String str) => SupportMethods.fromJson(json.decode(str));

String supportMethodsToJson(SupportMethods data) => json.encode(data.toJson());

class SupportMethods {
  String? remark;
  String? status;
  Data? data;

  SupportMethods({
    this.remark,
    this.status,
    this.data,
  });

  factory SupportMethods.fromJson(Map<String, dynamic> json) => SupportMethods(
        remark: json["remark"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  List<SupportMethod>? methods;
  String? methodFilePath;

  Data({
    this.methods,
    this.methodFilePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        methods: json["methods"] == null ? [] : List<SupportMethod>.from(json["methods"]!.map((x) => SupportMethod.fromJson(x))),
        methodFilePath: json["method_file_path"],
      );

  Map<String, dynamic> toJson() => {
        "methods": methods == null ? [] : List<dynamic>.from(methods!.map((x) => x.toJson())),
        "method_file_path": methodFilePath,
      };
}

class SupportMethod {
  String? id;
  String? name;
  String? url;
  String? image;
  String? isDefault;
  String? status;
  String? createdAt;
  String? updatedAt;

  SupportMethod({
    this.id,
    this.name,
    this.url,
    this.image,
    this.isDefault,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportMethod.fromJson(Map<String, dynamic> json) => SupportMethod(
        id: json["id"].toString(),
        name: json["name"].toString(),
        url: json["url"].toString(),
        image: json["image"].toString(),
        isDefault: json["is_default"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "image": image,
        "is_default": isDefault,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
