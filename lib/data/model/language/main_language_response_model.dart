// To parse this JSON data, do
//
//     final mainLanguageResponseModel = mainLanguageResponseModelFromJson(jsonString);

import 'dart:convert';

MainLanguageResponseModel mainLanguageResponseModelFromJson(String str) => MainLanguageResponseModel.fromJson(json.decode(str));

String mainLanguageResponseModelToJson(MainLanguageResponseModel data) => json.encode(data.toJson());

class MainLanguageResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  MainLanguageResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory MainLanguageResponseModel.fromJson(Map<String, dynamic> json) => MainLanguageResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class Data {
  List<Language>? languages;

  Map<String, dynamic>? file;
  String? imagePath;

  Data({this.languages, this.file, this.imagePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: json["languages"] == null
            ? []
            : List<Language>.from(
                json["languages"]!.map((x) => Language.fromJson(x)),
              ),
        file: json["file"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "languages": languages == null ? [] : List<dynamic>.from(languages!.map((x) => x.toJson())),
        "file": Map.from(file!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "image_path": imagePath,
      };
}

class Language {
  String? id;
  String? name;
  String? code;
  String? isDefault;
  String? image;
  String? info;
  String? createdAt;
  String? updatedAt;

  Language({
    this.id,
    this.name,
    this.code,
    this.isDefault,
    this.image,
    this.info,
    this.createdAt,
    this.updatedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"].toString(),
        name: json["name"],
        code: json["code"],
        isDefault: json["is_default"].toString(),
        image: json["image"],
        info: json["info"],
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "is_default": isDefault,
        "image": image,
        "info": info,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
