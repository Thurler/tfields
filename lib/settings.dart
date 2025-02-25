import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tfields/logger.dart';

/// The common app settings, holding common flags that control how it behaves
class CommonSettings {
  /// The current log level threshold for logged messages
  LogLevel logLevel = LogLevel.info;

  /// Whether to check for updates at startup
  bool checkUpdates = true;

  /// Copy settings from another instance
  CommonSettings.from(CommonSettings other) :
    logLevel = other.logLevel,
    checkUpdates = other.checkUpdates;

  /// Initialize settings with their default values
  CommonSettings.fromDefault();

  /// Initialize settings from a serialized JSON map
  CommonSettings.fromJson(String raw) {
    Map<String, dynamic> jsonContents = json.decode(raw);
    if (jsonContents.containsKey('logLevel')) {
      logLevel = LogLevel.fromName(jsonContents['logLevel']);
    }
    if (jsonContents.containsKey('checkUpdates')) {
      checkUpdates = jsonContents['checkUpdates'];
    }
  }

  /// Serialize settings into a JSON map
  @mustCallSuper
  String toJson() {
    Map<String, dynamic> result = <String, dynamic>{
      'logLevel': logLevel.name,
      'checkUpdates': checkUpdates,
    };
    return json.encode(result);
  }
}
