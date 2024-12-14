import 'package:leoparduser/data/model/global/user/global_user_model.dart';

class RegistrationResponseModel {
  RegistrationResponseModel(
      {String? remark, String? status, List<String>? message, Data? data}) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  RegistrationResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'].toString();
    _message = json['message'] != null
        ? List<String>.from(json["message"]!.map((x) => x.toString()))
        : [];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _remark;
  String? _status;
  List<String>? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  List<String>? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message;
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({String? accessToken, GlobalUser? user, String? tokenType}) {
    _accessToken = accessToken;
    _user = user;
    _tokenType = tokenType;
  }

  Data.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _user = json['user'] != null ? GlobalUser.fromJson(json['user']) : null;
    _tokenType = json['token_type'];
  }

  String? _accessToken;
  GlobalUser? _user;
  String? _tokenType;

  String? get accessToken => _accessToken;
  GlobalUser? get user => _user;
  String? get tokenType => _tokenType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['token_type'] = _tokenType;
    return map;
  }
}

class Message {
  Message({List<String>? success, List<String>? error}) {
    _success = success;
    _error = error;
  }

  Message.fromJson(dynamic json) {
    _success = json['success'] != null ? [json['success'].toString()] : null;
    _error = json['error'] != null ? [json['error'].toString()] : null;
  }

  List<String>? _success;
  List<String>? _error;

  List<String>? get success => _success;
  List<String>? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['error'] = _error;
    return map;
  }
}
