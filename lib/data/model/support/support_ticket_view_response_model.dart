// To parse this JSON data, do
//
//     final supportTicketViewResponseModel = supportTicketViewResponseModelFromJson(jsonString);

import 'dart:convert';

SupportTicketViewResponseModel supportTicketViewResponseModelFromJson(
  String str,
) =>
    SupportTicketViewResponseModel.fromJson(json.decode(str));

String supportTicketViewResponseModelToJson(
  SupportTicketViewResponseModel data,
) =>
    json.encode(data.toJson());

class SupportTicketViewResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  SupportTicketViewResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory SupportTicketViewResponseModel.fromJson(Map<String, dynamic> json) => SupportTicketViewResponseModel(
        remark: json["remark"],
        status: json["status"],
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
  MyTickets? myTickets;
  List<SupportMessage>? myMessages;
  String? ticketImagePath;

  Data({this.myTickets, this.myMessages, this.ticketImagePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        myTickets: json["my_ticket"] == null ? null : MyTickets.fromJson(json["my_ticket"]),
        myMessages: json["messages"] == null
            ? []
            : List<SupportMessage>.from(
                json["messages"]!.map((x) => SupportMessage.fromJson(x)),
              ),
        ticketImagePath: json["ticket_image_path"],
      );

  Map<String, dynamic> toJson() => {
        "my_ticket": myTickets?.toJson(),
        "messages": myMessages == null ? [] : List<dynamic>.from(myMessages!.map((x) => x.toJson())),
        "ticket_image_path": ticketImagePath,
      };
}

class SupportMessage {
  int? id;
  String? supportTicketId;
  String? adminId;
  String? message;
  String? createdAt;
  String? updatedAt;
  MyTickets? ticket;
  Admin? admin;
  List<Attachment>? attachments;

  SupportMessage({
    this.id,
    this.supportTicketId,
    this.adminId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.ticket,
    this.admin,
    this.attachments,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
        id: json["id"],
        supportTicketId: json["support_ticket_id"].toString(),
        adminId: json["admin_id"].toString(),
        message: json["message"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        ticket: json["ticket"] == null ? null : MyTickets.fromJson(json["ticket"]),
        admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "support_ticket_id": supportTicketId,
        "admin_id": adminId,
        "message": message,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "ticket": ticket?.toJson(),
        "admin": admin?.toJson(),
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class Admin {
  int? id;
  String? name;
  String? email;
  String? username;
  String? emailVerifiedAt;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;

  Admin({
    this.id,
    this.name,
    this.email,
    this.username,
    this.emailVerifiedAt,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["id"],
        name: json["name"].toString(),
        email: json["email"].toString(),
        username: json["username"].toString(),
        emailVerifiedAt: json["email_verified_at"].toString(),
        image: json["image"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        "email_verified_at": emailVerifiedAt,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Attachment {
  int? id;
  String? supportMessageId;
  String? attachment;
  String? createdAt;
  String? updatedAt;

  Attachment({
    this.id,
    this.supportMessageId,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        supportMessageId: json["support_message_id"].toString(),
        attachment: json["attachment"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "support_message_id": supportMessageId,
        "attachment": attachment,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class MyTickets {
  int? id;
  String? userId;
  String? name;
  String? email;
  String? ticket;
  String? subject;
  String? status;
  String? priority;
  String? lastReply;
  String? createdAt;
  String? updatedAt;

  MyTickets({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.ticket,
    this.subject,
    this.status,
    this.priority,
    this.lastReply,
    this.createdAt,
    this.updatedAt,
  });

  factory MyTickets.fromJson(Map<String, dynamic> json) => MyTickets(
        id: json["id"],
        userId: json["user_id"].toString(),
        name: json["name"],
        email: json["email"],
        ticket: json["ticket"],
        subject: json["subject"],
        status: json["status"].toString(),
        priority: json["priority"].toString(),
        lastReply: json["last_reply"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "email": email,
        "ticket": ticket,
        "subject": subject,
        "status": status,
        "priority": priority,
        "last_reply": lastReply,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
