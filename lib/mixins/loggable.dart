import 'package:agattp/agattp.dart';
import 'package:tfields/logger.dart';

/// Mixing this into any class will allow that class to standardize its
/// interactions with the application's log file. It provides functions to log
/// messages and change the current log level
mixin Loggable {
  /// The Logger singleton reference
  final Logger _logger = Logger();

  /// Log a message and immediately flush it to disk
  Future<void> log(LogLevel level, dynamic message) =>
      _logger.log(level, message);

  /// Log a message in the buffer, without flushing it to disk just yet
  void logBuffer(LogLevel level, dynamic message) =>
      _logger.logBuffer(level, message);

  /// Flush the log buffer into disk
  Future<void> logFlush() => _logger.flush();

  /// Log a debug message with the parameters of a HTTP request
  Future<void> logRequest(Uri uri, dynamic body) =>
      log(LogLevel.debug, 'Sending request: $uri | Body: $body');

  /// Log a debug message with the parameters of a HTTP response
  Future<void> logResponse(AgattpResponse response) => log(
    LogLevel.debug,
    'Status code: ${response.statusCode} | Body: ${response.body}',
  );

  /// Change the current log level
  set logLevel(LogLevel level) => _logger.logLevel = level;
}
