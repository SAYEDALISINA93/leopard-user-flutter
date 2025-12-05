class RunningRideService {
  RunningRideService._();

  bool _isRunning = false;

  bool get isRunningShow => _isRunning;

  void setIsRunning(bool value) {
    _isRunning = value;
  }

  static final RunningRideService _instance = RunningRideService._();

  static RunningRideService get instance => _instance;
}
