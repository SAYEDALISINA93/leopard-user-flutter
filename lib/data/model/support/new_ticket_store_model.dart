import 'dart:io';

class TicketStoreModel {
  String name;
  String email;
  String subject;
  String priority;
  String message;
  List<File>? fileList;

  TicketStoreModel({
    required this.name,
    required this.email,
    required this.subject,
    required this.priority,
    required this.message,
    this.fileList,
  });
}
