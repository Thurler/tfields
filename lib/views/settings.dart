import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/discardable_changes.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/dropdown.dart';
import 'package:tfields/widgets/form/switch.dart';
import 'package:tfields/widgets/rounded_border.dart';

/// The widget that allows the user to change app settingss
abstract class AbstractSettingsWidget<S extends CommonSettings>
    extends StatefulWidget {
  final String title;
  const AbstractSettingsWidget({required this.title, super.key});
}

/// The state consists only of the form elements, so we mix DiscardableChanges
/// in to easily handle the changes in that state for us
abstract class AbstractSettingsState<S extends CommonSettings>
    extends State<AbstractSettingsWidget<S>>
    with
        Loggable,
        SettingsReader<S>,
        AlertHandler<AbstractSettingsWidget<S>>,
        DiscardableChanges<AbstractSettingsWidget<S>> {
  /// The dialog message to use on unhandled exceptions
  String get unhandledExceptionMessage;

  /// The log level options, mapped to their dropdown text values
  final List<String> _options = LogLevel.values.map(
    (LogLevel level) => level.dropdownText,
  ).toList();

  /// The log level dropdown form...
  late TFormDropdown _logLevelForm;

  /// ...and its key, used to access the form's inner state
  final DropdownFormKey _logLevelFormKey = DropdownFormKey();

  /// The update check bool switch form...
  late TFormSwitch _checkUpdatesForm;

  /// ...and its key, used to access the form's inner state
  final SwitchFormKey _checkUpdatesFormKey = SwitchFormKey();

  @override
  @mustCallSuper
  bool get hasChanges =>
      // Simply aply a logical OR to the form hasChanges flags
      (_logLevelFormKey.currentState?.hasChanges ?? false) ||
      (_checkUpdatesFormKey.currentState?.hasChanges ?? false);

  /// Handle the weird case where we can't save the settings file to disk
  Future<void> _handleFileSystemException(FileSystemException e) {
    return handleException(
      logMessage: 'FileSystem Exception when saving settings: ${e.message}',
      dialogTitle: 'An error occured when saving the settings!',
      dialogBody: 'Make sure your user has permission to write a file in '
          'the folder this app is in.',
    );
  }

  @mustCallSuper
  void updateSettingsWithForm() {
    // Get the log level from the dropdown value, and save it to settings
    String chosenLogLevel = _logLevelFormKey.currentState!.value;
    settings.logLevel = LogLevel.values[_options.indexOf(chosenLogLevel)];
    // Similarly to the remaining settings
    settings.checkUpdates = _checkUpdatesFormKey.currentState!.value;
  }

  @mustCallSuper
  void resetFormValues() {
    // Reset initial value to remove the has changes flag
    _logLevelFormKey.currentState!.resetInitialValue();
    _checkUpdatesFormKey.currentState!.resetInitialValue();
    setState(() {});
  }

  @override
  Future<void> saveChanges() async {
    updateSettingsWithForm();
    // Try to save the new settings to disk - if it fails, we don't exit out
    // of settings, keep the user here even though we've already changed the
    // internal settings
    try {
      File settingsFile = File('./settings.json');
      settingsFile.writeAsStringSync('${settings.toJson()}\n');
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on Exception catch (e, s) {
      await handleUnexpectedException(
        e,
        s,
        dialogBody: unhandledExceptionMessage,
      );
      return;
    }
    await log(
      LogLevel.info,
      'Applying log level ${settings.logLevel.name}',
    );
    await log(LogLevel.info, 'Saved settings changes');
    logLevel = settings.logLevel;
    resetFormValues();
  }

  /// Callback for the log level dropdown, used only to log what was changed
  Future<void> _changeLogLevel(String? chosen) async {
    if (chosen == null) {
      return;
    }
    LogLevel chosenLevel = LogLevel.values[_options.indexOf(chosen)];
    await log(
      LogLevel.debug,
      'Log level changed to ${chosenLevel.name}',
    );
    // Refresh has changes flag
    setState(() {});
  }

  /// Callback for the update check switch, used only to log what was changed
  Future<void> _changeUpdateCheck(bool? chosen) async {
    if (chosen == null) {
      return;
    }
    await log(
      LogLevel.debug,
      'Auto update checks ${chosen ? 'enabled' : 'disabled'}',
    );
    // Refresh has changes flag
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
    _logLevelForm = TFormDropdown(
      enabled: true,
      title: 'Log level',
      subtitle: 'Specifies severity of information to be logged',
      hintText: 'Select a log level',
      options: _options,
      initialValue: _options[settings.logLevel.index],
      onValueChanged: _changeLogLevel,
      key: _logLevelFormKey,
    );
    _checkUpdatesForm = TFormSwitch(
      enabled: true,
      title: 'Check for updates on startup',
      subtitle: 'A message is displayed if an update is available',
      offText: "Don't check for updates",
      onText: 'Check for updates',
      onValueChanged: _changeUpdateCheck,
      initialValue: settings.checkUpdates,
      key: _checkUpdatesFormKey,
    );
  }

  List<Widget> get additionalForms;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: CommonScaffold(
        title: widget.title,
        floatingActionButton: saveButton,
        children: <Widget>[
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _logLevelForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _checkUpdatesForm,
          ),
          ...additionalForms,
        ],
      ),
    );
  }
}
