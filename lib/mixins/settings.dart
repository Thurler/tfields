import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  void writeSettings();

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
  void writeSettings() {
    try {
      File settingsFile = File('./settings.json');
      settingsFile.writeAsStringSync('${json.encode(settings.toJson())}\n');
    } catch (e, s) {
      handleWriteError(e, s);
    }
  }
}

/// A mixin for StatefulWidgets that need to know the current set of settings
/// outside of their build logic, and don't want to read the json file
mixin TSettingsAware<T extends StatefulWidget, S extends TCommonSettings>
    on State<T> implements TSettingsReader<S> {
  late S? _settings;

  @override
  S get settings => _settings ?? settingsFromDefault();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings =
        Provider.of<TSettingsProvider<S>>(context, listen: false).settings;
  }
}

/// A provider of a concrete set of settings - setting new values will notify
/// all widgets that consume this provider, and redraw them automatically
mixin TSettingsProvider<S extends TCommonSettings>
    implements ChangeNotifier, TSettingsReader<S> {
  S? _settings;

  @override
  S get settings => _settings ?? settingsFromDefault();

  void setSettings(S? settings) {
    _settings = settings;
    notifyListeners();
  }
}
