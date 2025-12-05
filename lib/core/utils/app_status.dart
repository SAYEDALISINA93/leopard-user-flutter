// ignore_for_file: constant_identifier_names

class AppStatus {
  static const String ENABLE = '1';
  static const String DISABLE = '0';

  static const String YES = '1';
  static const String NO = '0';

  static const String DISCOUNT_PERCENT = '1';
  static const String DISCOUNT_FIXED = '2';

  static const String RIDE_TYPE_CITY = '1';
  static const String RIDE_TYPE_INTERCITY = '2';

  static const String RIDE_PENDING = '0';
  static const String RIDE_COMPLETED = '1';
  static const String RIDE_ACTIVE = '2';
  static const String RIDE_RUNNING = '3';
  static const String RIDE_CANCELED = '9';
  static const String RIDE_PAYMENT_REQUESTED = '4';

  /// ride end || payment requested
  static const String PAYMENT_TYPE_GATEWAY = '1';
  static const String PAYMENT_TYPE_CASH = '2';
}
