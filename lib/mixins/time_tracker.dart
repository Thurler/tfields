import 'dart:async';

import 'package:flutter/material.dart';

/// Mixing this into a State allows that state to keep track of time - a Timer
/// can be started, stopped and resumed to keep track of how many seconds have
/// passed since it was started
mixin TTimeTracker<T extends StatefulWidget> on State<T> {
  /// The timer that will tick every second when tracking is active
  Timer? _timer;

  /// The number of seconds elapsed since the timer was started
  int elapsedSeconds = 0;

  /// Whether the State is currently tracking time or not
  bool get timerIsActive => _timer?.isActive ?? false;

  /// The duration of time elapsed since the timer was started
  Duration get elapsedDuration => Duration(seconds: elapsedSeconds);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Start the timer, resetting the number of elapsed seconds to zero
  void startTimer() {
    elapsedSeconds = 0;
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
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
          elapsedSeconds++;
        }),
      );
    });
  }

  /// Stops the timer - will not reset the number of elapsed seconds
  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _timer = null;
    });
  }
}
