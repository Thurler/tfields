import 'package:flutter/material.dart';
import 'package:tfields/src/logger.dart';
import 'package:tfields/src/settings.dart';
import 'package:tfields/src/widgets/form/dropdown.dart';
import 'package:tfields/src/widgets/form/group/group.dart';
import 'package:tfields/src/widgets/grid/item.dart';
import 'package:tfields/src/widgets/grid/row.dart';

/// The form fields corresponding to the common settings' attributes
enum TCommonSettingsFormField implements TFormField {
  logLevel,
  autoUpdate;
}

/// A group that contains the forms for common settings attributes
abstract class TSettingsGroup<S extends TCommonSettings, F extends TFormField>
    extends TFormGroup<S, void, F> {
  /// The field corresponding to the common settings' log level setting
  F get logLevelField;

  /// The field corresponding to the common settings' auto update setting
  F get autoUpdateField;

  /// The initial data that will be loaded into the form
  final S? initialData;

  TSettingsGroup({
    required super.enabled,
    required super.setState,
    this.initialData,
  }) {
    addDropdownForm(
      formName: logLevelField,
      title: 'Log level',
      subtitle: 'Specifies severity of information to be logged',
      hintText: 'Select a log level',
      options: TLogLevel.values,
      sortLogic: TDropdownSortLogic.object,
      initialValue: initialData?.logLevel,
      toDropdownText: (TLogLevel level) => level.dropdownText,
    );

    addCheckboxForm(
      formName: autoUpdateField,
      title: 'Auto-update',
      text: 'Check for updates on startup',
      subtitle: 'A message is displayed if an update is available',
      initialValue: initialData?.checkUpdates ?? true,
    );
  }

  /// The value for the application log level
  TLogLevel get logLevel =>
      this[logLevelField].dropdownValue() ?? initialData?.logLevel ??
      TLogLevel.info;

  /// The value for whether the auto-update feature will be on or not
  bool get autoUpdate =>
      this[autoUpdateField].checkboxValue ?? initialData?.checkUpdates ?? true;
}

/// The concretization of the TSettingsGroup class for use with only the common
/// settings
class TCommonSettingsGroup
    extends TSettingsGroup<TCommonSettings, TCommonSettingsFormField> {
  TCommonSettingsGroup({
    required super.enabled,
    required super.setState,
    super.initialData,
  });

  @override
  TCommonSettingsFormField get autoUpdateField =>
      TCommonSettingsFormField.autoUpdate;

  @override
  TCommonSettingsFormField get logLevelField =>
      TCommonSettingsFormField.logLevel;

  @override
  TCommonSettings makeEntity(void additionalData) => TCommonSettings(
    logLevel: logLevel,
    checkUpdates: autoUpdate,
    themeMode: initialData?.themeMode ?? ThemeMode.system,
  );
}

/// A widget visualization of the TCommonSettingsGroup class
class TCommonSettingsGroupWidget
    extends TFormGroupWidget<TCommonSettingsGroup> {
  const TCommonSettingsGroupWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      mdFlexLimit: 1,
      children: <TGridItem>[
        TGridItem(child: form[TCommonSettingsFormField.logLevel]),
        TGridItem(child: form[TCommonSettingsFormField.autoUpdate]),
      ],
    );
  }
}
