import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tfields/src/mixins/settings.dart';
import 'package:tfields/src/settings.dart';

/// The log level associated with a message, it can be one of:
///
/// - Debug: usually associated with dev messages that help with debugging
/// - Info: usually associated with messages that do not impact operation, but
/// are still useful in general
/// - Warning: usually associated with errors that can be handled gracefully by
/// the application, allowing for normal operation to continue
/// - Error: usually associated with errors that can't be handled gracefully by
/// the application, usually impeding normal operation in some way
/// - None: nothing is logged, good luck debugging
enum TLogLevel {
  debug('Debug (everything is logged)'),
  info('Info (major actions and higher are logged)'),
  warning('Warning (warnings and higher are logged)'),
  error('Error (only errors are logged)'),
  none('None (nothing is logged)');

  /// The pretty text to be displayed in the settings dropdown
  final String dropdownText;

  const TLogLevel(this.dropdownText);

  /// Instantiate a LogLevel based on its enum name
  factory TLogLevel.fromName(String name) =>
      TLogLevel.values.firstWhere((TLogLevel l) => l.name == name);
}

/// A singleton class that handles the writing of log messages into the log file
///
/// The log file is always overwritten when the software is reopened
class TLogger
    with TSettingsJsonReader<TCommonSettings>, TCommonSettingsDeserializer {
  /// The singleton object itself
  static final TLogger _logger = TLogger._internal();

  /// The log file's filename
  static const String filename = './applicationlog.txt';

  /// The IO Sink that will buffer the messages
  late IOSink sink;

  /// The current log level required to log a message
  TLogLevel get logLevel => settings.logLevel;

  /// Helper function to format the current timestamp
  String get _currentTimestamp => DateTime.now().toLocal().toIso8601String();

  factory TLogger() {
    return _logger;
  }

  TLogger._internal() {
    // Make sure settingsare loaded so we have a log level to work with
    readSettings();
    // Always reset the log file on startup
    File logFile = File(filename);
    sink = logFile.openWrite();
  }

  /// Helper function to standardize log message formatting
  String _buildLogLine(TLogLevel level, dynamic message) {
    return '$_currentTimestamp | ${level.name.toUpperCase()} | $message';
  }

  /// Buffer a log message into the IO sink, without flushing it
  void logBuffer(TLogLevel level, dynamic message) {
    if (level.index >= logLevel.index) {
      sink.writeln(_buildLogLine(level, message));
      // Also log the message in the terminal if we're in debug mode
      if (kDebugMode) {
        print(_buildLogLine(level, message));
      }
    }
  }

  /// Log a message into the IO sink, flushing it immediately
  Future<void> log(TLogLevel level, dynamic message) async {
    logBuffer(level, message);
    return flush();
  }

  /// Flush the IO sink into the log file
  Future<void> flush() async {
    try {
      await sink.flush();
    } on Exception catch (e, s) {
      // Can't do much - if I can't open the log file, I can't log the error
      // ignore: avoid_print
      print('Exception: $e');
      // ignore: avoid_print
      print('Stack Trace: $s');
    }
  }
}
