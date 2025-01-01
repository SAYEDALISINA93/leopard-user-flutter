import 'package:leoparduser/core/helper/string_format_helper.dart';

class RouteManager {
  // Singleton instance
  static final RouteManager _instance = RouteManager._internal();
  // Private constructor for singleton
  RouteManager._internal();
  factory RouteManager() {
    return _instance;
  }
  // Flag to check if a logout is in progress
  bool _isLoggingOut = false;
  // Method to start the logout process
  Future<void> startLogout(Function logoutAction) async {
    if (_isLoggingOut) {
      loggerI('Logout is already in progress.');
      return;
    }
    _isLoggingOut = true;
    try {
      await logoutAction();
    } catch (e) {
      loggerI('Error during logout: $e');
    } finally {
      // Reset the flag after the logout process completes
      // _isLoggingOut = false;
    }
  }

  // Getter to check if a logout is already happening
  bool get isLoggingOut => _isLoggingOut;

  set resetLoggingOut(bool value) {
    _isLoggingOut = value;
  }
}
