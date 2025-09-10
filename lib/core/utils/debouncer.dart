import 'dart:async';

class MyDeBouncer {
  final Duration delay;
  Timer? _timer;

  MyDeBouncer({required this.delay});

  void run(void Function() action) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(delay, action);
  }
}
