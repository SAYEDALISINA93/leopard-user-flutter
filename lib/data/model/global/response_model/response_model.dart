class ResponseModel {
  final bool _isSuccess;
  final int _statusCode;
  final String _message;
  final dynamic _responseJson;
  ResponseModel(
    this._isSuccess,
    this._message,
    this._statusCode,
    this._responseJson,
  );

  String get message => _message;
  dynamic get responseJson => _responseJson;
  int get statusCode => _statusCode;
  bool get isSuccess => _isSuccess;
}
