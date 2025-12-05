import 'dart:convert';

FaqResponseModel faqResponseModelFromJson(String str) => FaqResponseModel.fromJson(json.decode(str));

String faqResponseModelToJson(FaqResponseModel data) => json.encode(data.toJson());

class FaqResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  FaqResponseModel({this.remark, this.status, this.message, this.data});

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) => FaqResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x.toString())),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<Faq>? faq;

  Data({this.faq});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        faq: json["faq"] == null ? [] : List<Faq>.from(json["faq"]!.map((x) => Faq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "faq": faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class Faq {
  int? id;
  String? dataKeys;
  DataValues? dataValues;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  Faq({
    this.id,
    this.dataKeys,
    this.dataValues,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        dataKeys: json["data_keys"],
        dataValues: json["data_values"] == null ? null : DataValues.fromJson(json["data_values"]),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data_keys": dataKeys,
        "data_values": dataValues?.toJson(),
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "get_image": getImage,
      };
}

class DataValues {
  String? question;
  String? answer;

  DataValues({this.question, this.answer});

  factory DataValues.fromJson(Map<String, dynamic> json) => DataValues(question: json["question"], answer: json["answer"]);

  Map<String, dynamic> toJson() => {"question": question, "answer": answer};
}
