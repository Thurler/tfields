import 'dart:convert';
import 'dart:io';

import 'package:tfields/settings.dart';

/// The interface that unifies how regular classes and widgets deserialize the
/// settings json and what default to use when it fails
abstract interface class TSettingsDeserializer<S extends TCommonSettings> {
  /// The default initialization function of the settings
  S settingsFromDefault();

  /// The json initialization function of the settings
  S settingsFromJson(String fileContents);
}

/// A specialization of [TSettingsDeserializer] that limits itself to the common
/// settings defined in TFields
mixin TCommonSettingsDeserializer on TSettingsDeserializer<TCommonSettings> {
  @override
  TCommonSettings settingsFromJson(String fileContents) =>
      TCommonSettings.fromJson(json.decode(fileContents));

  @override
  TCommonSettings settingsFromDefault() => TCommonSettings.fromDefault();
}

/// The interface that unifies how regular classes read the settings file and
/// how widgets read the settings from the provider
abstract interface class TSettingsReader<S extends TCommonSettings>
    implements TSettingsDeserializer<S> {
  /// The settings variable that is initialized by calling loadSettings()
  S get settings;

  /// A function that initializes the settings used by the getter
  S readSettings();
}

/// The interface that unifies how regular classes and widgets write to the
/// settings file
abstract interface class TSettingsWriter<S extends TCommonSettings>
    implements TSettingsReader<S> {
  /// The function that writes the current settings to disk
  bool writeSettings();

  /// The function that handles any error thrown during the save procedure
  void handleWriteError(Object exception, StackTrace stackTrace);
}

/// Mixing this into any class allows it to read the app settings. It provides a
/// Settings variable that is initialized by readSettings, which MUST be called
/// BEFORE the variable is used for anything
mixin TSettingsJsonReader<S extends TCommonSettings>
    implements TSettingsReader<S> {
  S? _settings;

  // We read the file once, and then keep returning what we read. If we want to
  // reread the file, we must call readSettings() directly
  @override
  S get settings => _settings ?? (_settings = readSettings());

  /// Load the settings from the json file in the app's root directory
  @override
  S readSettings() {
    try {
      File settingsFile = File('./settings.json');
      if (settingsFile.existsSync()) {
        // Make sure we assign and return at the same time
        return _settings = settingsFromJson(settingsFile.readAsStringSync());
      } else {
        // Make sure we assign and return at the same time
        return _settings = settingsFromDefault();
      }
    } catch (e) {
      // If we fail to load the settings file, keep going with default settings
      // Make sure we assign and return at the same time
      return _settings = settingsFromDefault();
    }
  }
}

/// Mixing this into any class allows it to write the app settings
mixin TSettingsJsonWriter<S extends TCommonSettings>
    implements TSettingsWriter<S> {
  @override
  bool writeSettings() {
    try {
      File settingsFile = File('./settings.json');
      settingsFile.writeAsStringSync('${json.encode(settings.toJson())}\n');
      return true;
    } catch (e, s) {
      handleWriteError(e, s);
      return false;
    }
  }
}
