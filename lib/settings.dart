import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';

/// The common app settings, holding common flags that control how it behaves
class TCommonSettings {
  /// The current log level threshold for logged messages
  TLogLevel logLevel = TLogLevel.info;

  /// Whether to check for updates at startup
  bool checkUpdates = true;

  /// Which brightness color theme to use
  ThemeMode themeMode = ThemeMode.system;

  /// Copy settings from another instance
  TCommonSettings.from(TCommonSettings other) :
    logLevel = other.logLevel,
    checkUpdates = other.checkUpdates,
    themeMode = other.themeMode;

  /// Initialize settings with their default values
  TCommonSettings.fromDefault();

  /// Initialize settings from a serialized JSON map
  TCommonSettings.fromJson(Map<String, dynamic> jsonContents) {
    if (jsonContents.containsKey('logLevel')) {
      logLevel = TLogLevel.fromName(jsonContents['logLevel']);
    }
    if (jsonContents.containsKey('checkUpdates')) {
      checkUpdates = jsonContents['checkUpdates'];
    }
    if (jsonContents.containsKey('themeMode')) {
      themeMode = switch (jsonContents['themeMode']) {
        'system' => ThemeMode.system,
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    }
  }

  /// Serialize settings into a JSON map
  @mustCallSuper
  Map<String, dynamic> toJson() => <String, dynamic>{
    'logLevel': logLevel.name,
    'checkUpdates': checkUpdates,
    'themeMode': themeMode.name,
  };
}
