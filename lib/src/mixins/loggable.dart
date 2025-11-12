import 'package:agattp/agattp.dart';
import 'package:tfields/src/logger.dart';

/// Mixing this into any class will allow that class to standardize its
/// interactions with the application's log file. It provides functions to log
/// messages and change the current log level
mixin TLoggable {
  /// The Logger singleton reference
  final TLogger _logger = TLogger();

  /// Log a message and immediately flush it to disk
  Future<void> log(TLogLevel level, dynamic message) =>
      _logger.log(level, message);

  /// Log a message in the buffer, without flushing it to disk just yet
  void logBuffer(TLogLevel level, dynamic message) =>
      _logger.logBuffer(level, message);

  /// Flush the log buffer into disk
  Future<void> logFlush() => _logger.flush();

  /// Log a debug message with the parameters of a HTTP request
  Future<void> logRequest(Uri uri, dynamic body) =>
      log(TLogLevel.debug, 'Sending request: $uri | Body: $body');

  /// Log a debug message with the parameters of a HTTP response
  Future<void> logResponse(AgattpResponse response) => log(
    TLogLevel.debug,
    'Status code: ${response.statusCode} | Body: ${response.body}',
  );

  /// Change the current log level
  set logLevel(TLogLevel level) => _logger.settings.logLevel = level;
}
