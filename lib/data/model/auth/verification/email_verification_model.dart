class EmailVerificationModel {
  EmailVerificationModel({
    required int code,
    required String status,
    required String colorRedirectUrl,
    List<String>? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _colorRedirectUrl = colorRedirectUrl;
    _data = data;
  }

  EmailVerificationModel.fromJson(dynamic json) {
    _code = json['code'] ?? 0;
    _colorRedirectUrl = json['colorRedirect_url'] ?? '';
    _status = json['status'] ?? 'null status';
    _message = json['message'] != null ? List<String>.from(json['message']!.map((x) => x.toString())) : [];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  late int _code;
  late String _status;
  late String _colorRedirectUrl;
  List<String>? _message;
  Data? _data;

  int get code => _code;
  String get status => _status;
  String get colorRedirectUrl => _colorRedirectUrl;
  List<String>? get message => _message;
  Data? get data => _data;

  void setCode(int code) {
    _code = code;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message;
    }
    if (_colorRedirectUrl.isNotEmpty) {
      map['colorRedirect_url'] = _colorRedirectUrl;
    }
    return map;
  }
}

class Data {
  //only use in forget password   section
  String? email;
  String? token;

  Data({this.email, this.token});
  Data.fromJson(dynamic json) {
    if (json['email'] != null) {
      email = json['email'];
    } else {
      email = null;
    }
    if (json['code'] != null) {
      token = json['code'].toString();
    } else {
      token = null;
    }
  }
}
