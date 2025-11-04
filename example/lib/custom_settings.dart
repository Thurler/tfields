import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfields/mixins/settings.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/theme_provider.dart';
import 'package:tfields/views/settings.dart';
import 'package:tfields/widgets/form/group/common_settings.dart';
import 'package:tfields/widgets/form/group/group.dart';
import 'package:tfields/widgets/grid/item.dart';
import 'package:tfields/widgets/grid/row.dart';

/// We extend the CommonSettings class with the new attributes we want our
/// application to have - make sure we override the constructors and
/// serialization function as well
class CustomSettings extends TCommonSettings {
  String customValue = '';

  CustomSettings({
    required this.customValue,
    required super.logLevel,
    required super.checkUpdates,
    required super.themeMode,
  });

  CustomSettings.from(CustomSettings super.other) :
    customValue = other.customValue,
    super.from();

  CustomSettings.fromDefault() : super.fromDefault();

  CustomSettings.fromJson(Map<String, dynamic> jsonContents) :
    super.fromJson(jsonContents) {
    if (jsonContents.containsKey('customValue')) {
      customValue = jsonContents['customValue'];
    }
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll(<String, dynamic>{
    'customValue': customValue,
  });
}

/// We must specify in an enum all the fields present in our custom settings, so
/// we can edit them in a standardized way. The log level and auto update flags
/// must be present
enum CustomSettingsField implements TFormField {
  logLevel,
  autoUpdate,
  customValue;
}

/// Now we can extend the settings form group with a class that adds our custom
/// values
class CustomSettingsGroup
    extends TSettingsGroup<CustomSettings, CustomSettingsField> {
  CustomSettingsGroup({
    required super.enabled,
    required super.setState,
    super.initialData,
  }) {
    addStringForm(
      formName: CustomSettingsField.customValue,
      title: 'Custom value',
      subtitle: 'A custom value used by the app',
      hintText: 'Give it a value!',
      initialValue: initialData?.customValue ?? '',
    );
  }

  /// The value for the custom value
  String get customValue => this[CustomSettingsField.customValue].stringValue;

  @override
  CustomSettingsField get autoUpdateField => CustomSettingsField.autoUpdate;

  @override
  CustomSettingsField get logLevelField => CustomSettingsField.logLevel;

  @override
  CustomSettings makeEntity(void additionalData) => CustomSettings(
    customValue: customValue,
    logLevel: logLevel,
    checkUpdates: autoUpdate,
    themeMode: initialData?.themeMode ?? ThemeMode.system,
  );
}

/// And similarly extend the stateless widget that represents the group
class CustomSettingsGroupWidget extends TFormGroupWidget<CustomSettingsGroup> {
  const CustomSettingsGroupWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      mdFlexLimit: 1,
      lgFlexLimit: 2,
      children: <TGridItem>[
        TGridItem(child: form[CustomSettingsField.logLevel]),
        TGridItem(child: form[CustomSettingsField.autoUpdate]),
        TGridItem(child: form[CustomSettingsField.customValue]),
      ],
    );
  }
}

/// Similarly, we make a deserializer mixin so we don't need to set the
/// settingsFromJson and settingsFromDefault on every other class
mixin CustomSettingsDeserializer on TSettingsDeserializer<CustomSettings> {
  @override
  CustomSettings settingsFromJson(String fileContents) =>
      CustomSettings.fromJson(json.decode(fileContents));

  @override
  CustomSettings settingsFromDefault() => CustomSettings.fromDefault();
}

/// We also extend the SettingsThemeProvider with our custom settings class
class CustomSettingsThemeProvider extends TSettingsThemeProvider<CustomSettings>
    with TSettingsJsonReader<CustomSettings>, CustomSettingsDeserializer {
  CustomSettingsThemeProvider(super.seedColor);
}

/// We also extend the AbstractSettingsWidget with our custom settings class
class CustomSettingsWidget
    extends TAbstractSettingsWidget<CustomSettings, CustomSettingsField> {
  const CustomSettingsWidget({required super.title, super.key});

  @override
  State<CustomSettingsWidget> createState() => CustomSettingsState();
}

/// And also the AbstractSettingsState, making sure to override the functions
/// that relate to the form behavior to account for our new attribute
class CustomSettingsState extends TAbstractSettingsState<CustomSettings,
    CustomSettingsField, CustomSettingsWidget> with CustomSettingsDeserializer {
  /// The custom settings form group
  late final CustomSettingsGroup _customSettingsGroup;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _customSettingsGroup = CustomSettingsGroup(
      enabled: true,
      setState: setState,
      initialData: settings,
    );
  }

  // Override updateSettingsWithForm to apply the new value for our attributes
  @override
  void updateSettingsWithForm(CustomSettings newSettings) {
    super.updateSettingsWithForm(newSettings);
    settings.customValue = newSettings.customValue;
  }

  @override
  String get unhandledExceptionMessage => 'A weird exception happened';

  @override
  CustomSettingsGroup get settingsForm => _customSettingsGroup;

  @override
  CustomSettingsGroupWidget buildForm(BuildContext context) =>
      CustomSettingsGroupWidget(form: _customSettingsGroup);

  @override
  CustomSettings readSettings() => settings;
}
