import 'dart:convert';
import 'dart:io';

import 'package:tfields/settings.dart';

/// Mixing this into any class allows it to read the app settings. It provides a
/// Settings variable that is initialized by loadSettings, which MUST be called
/// BEFORE the variable is used for anything
mixin SettingsReader<S extends CommonSettings> {
  /// The settings variable that is initialized by calling loadSettings()
  late S settings;

  /// The json initialization function of the settings
  S settingsFromJson(String fileContents);

  /// The default initialization function of the settings
  S settingsFromDefault();

  /// Load the settings from the json file in the app's root directory
  void loadSettings() {
    try {
      File settingsFile = File('./settings.json');
      if (settingsFile.existsSync()) {
        settings = settingsFromJson(settingsFile.readAsStringSync());
      } else {
        settings = settingsFromDefault();
      }
    } catch (e) {
      // If we fail to load the settings file, keep going with default settings
      settings = settingsFromDefault();
    }
  }
}

/// A specialization of [SettingsReader] that limits itself to the common
/// settings defined in TFields
mixin CommonSettingsReader on SettingsReader<CommonSettings> {
  @override
  CommonSettings settingsFromJson(String fileContents) =>
      CommonSettings.fromJson(json.decode(fileContents));

  @override
  CommonSettings settingsFromDefault() => CommonSettings.fromDefault();
}
