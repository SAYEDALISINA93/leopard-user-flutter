class UnverifiedService {
  UnverifiedService._();

  bool _isUnverified = false;

  bool get isUnverified => _isUnverified;

  void setIsUnverified(bool value) {
    _isUnverified = value;
  }

  static final UnverifiedService _instance = UnverifiedService._();

  static UnverifiedService get instance => _instance;
}
