import 'dart:async';

enum ChronometerState {
  off,
  running,
  paused,
}

class Chronometer {
  ChronometerState state = ChronometerState.off;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  Timer? _timer;
  final _ticksEmitter = StreamController();
  Stream get ticksStream => _ticksEmitter.stream;

  void cancelTimer() {
    _timer?.cancel();
  }

  void run() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds++;

      if (seconds == 60) {
        minutes++;
      }

      if (minutes == 60) {
        hours++;
      }

      minutes %= 60;
      seconds %= 60;

      _ticksEmitter.add(null); // Don't need any specific data, so send null
    });

    state = ChronometerState.running;
  }

  void pause() {
    cancelTimer();

    state = ChronometerState.paused;
  }

  void restart() {
    cancelTimer();

    hours = 0;
    minutes = 0;
    seconds = 0;

    state = ChronometerState.off;
  }
}
