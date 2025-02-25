import 'dart:async';

import 'package:flutter/material.dart';

/// Mixing this into a State allows that state to keep track of time - a Timer
/// can be started, stopped and resumed to keep track of how many seconds have
/// passed since it was started
mixin TimeTracker<T extends StatefulWidget> on State<T> {
  bool timerIsActive = false;
  int elapsedSeconds = 0;
  Timer? _timer;

  Duration get elapsedDuration => Duration(seconds: elapsedSeconds);

  /// Start the timer, resetting the number of elapsed seconds to zero
  void startTimer() {
    setState(() {
      elapsedSeconds = 0;
    });
    stopTimer();
    resumeTimer();
  }

  /// Resume the timer, without resetting the number of elapsed seconds to zero.
  /// Does nothing if the timer is already running
  void resumeTimer() {
    if (_timer != null) {
      return;
    }
    setState(() {
      timerIsActive = true;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {
        elapsedSeconds++;
      }),
    );
  }

  /// Stops the timer - will not reset the number of elapsed seconds
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      timerIsActive = false;
    });
  }
}
