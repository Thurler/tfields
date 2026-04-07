import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tfields/src/logger.dart';
import 'package:tfields/src/mixins/dialog_displayer.dart';
import 'package:tfields/src/mixins/discardable_changes.dart';
import 'package:tfields/src/mixins/loggable.dart';
import 'package:tfields/src/mixins/settings.dart';
import 'package:tfields/src/settings.dart';
import 'package:tfields/src/widgets/common_scaffold.dart';
import 'package:tfields/src/widgets/form/group/common_settings.dart';
import 'package:tfields/src/widgets/form/group/group.dart';

/// The widget that allows the user to change app settingss
abstract class TAbstractSettingsWidget<S extends TCommonSettings,
    F extends TFormField> extends StatefulWidget {
  /// The title to be used in the Scaffold
  final String title;

  const TAbstractSettingsWidget({required this.title, super.key});
}

/// The state consists only of the form elements, so we mix DiscardableChanges
/// in to easily handle the changes in that state for us
abstract class TAbstractSettingsState<
        S extends TCommonSettings,
        F extends TFormField,
        T extends TAbstractSettingsWidget<S, F>> extends State<T>
    with
        TLoggable,
        TSettingsJsonReader<S>,
        TSettingsJsonWriter<S>,
        TDialogDisplayer<T>,
        TDiscardableChanges<T> {
  /// The dialog message to use on unhandled exceptions
  String get unhandledExceptionMessage;

  /// The form for editing Settings data
  TSettingsGroup<S, F> get settingsForm;

  @override
  bool get hasChanges => settingsForm.hasChanges;

  /// This function updates the current settings that are loaded in the
  /// application with the new settings that is being saved. Classes that use
  /// customized settings **must** override this method to update the customized
  /// fields, otherwise they must be reloaded manually from the saved file
  @mustCallSuper
  void updateSettingsWithForm(S newSettings) {
    settings.logLevel = newSettings.logLevel;
    settings.checkUpdates = newSettings.checkUpdates;
  }

  @override
  Future<void> saveChanges() async {
    // Request a form validation and check for errors
    if (!settingsForm.validate()) {
      unawaited(showWarning('The provided information is not valid'));
      setState(() {});
      return;
    }
    // Make a new settings entity and copy its values over to the existing one
    S newSettings = settingsForm.makeEntity(null);
    updateSettingsWithForm(newSettings);
    // Try to save the new settings to disk - if it fails, we don't exit out
    // of settings, keep the user here even though we've already changed the
    // internal settings
    writeSettings();
    await log(TLogLevel.info, 'Applying log level ${settings.logLevel.name}');
    await log(TLogLevel.info, 'Saved settings changes');
    logLevel = settings.logLevel;
    settingsForm.saveValues();
    // Make sure to redraw the state to get rid of the hasChanges flag
    setState(() {});
  }

  @override
  Future<void> handleWriteError(Object exception, StackTrace stackTrace) async {
    // Handle the weird case where we can't save the settings file to disk
    if (exception is FileSystemException) {
      return showException(
        'An error occured when saving the settings!',
        logMessage: 'FileSystem Exception when saving settings: '
            '${exception.message}',
        body: 'Make sure your user has permission to write a file in the '
            'folder this app is in.',
      );
    } else {
      return showUnexpectedException(
        exception,
        stackTrace,
        body: unhandledExceptionMessage,
      );
    }
  }

  /// The function that builds the actual form for the settings type
  TFormGroupWidget<TSettingsGroup<S, F>> buildForm(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: TCommonScaffold(
        title: widget.title,
        floatingActionButton: saveButton,
        children: <Widget>[buildForm(context)],
      ),
    );
  }
}

/// We also extend the AbstractSettingsWidget with our common settings class, so
/// apps without custom settings will be production-ready
class TCommonSettingsWidget
    extends TAbstractSettingsWidget<TCommonSettings, TCommonSettingsFormField> {
  const TCommonSettingsWidget({required super.title, super.key});

  @override
  State<TCommonSettingsWidget> createState() => _TCommonSettingsState();
}

class _TCommonSettingsState extends TAbstractSettingsState<
    TCommonSettings,
    TCommonSettingsFormField,
    TCommonSettingsWidget> with TCommonSettingsDeserializer {
  /// The common settings form group
  late final TCommonSettingsGroup _commonSettingsGroup;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _commonSettingsGroup = TCommonSettingsGroup(
      enabled: true,
      setState: setState,
      initialData: settings,
    );
  }

  @override
  String get unhandledExceptionMessage => 'Exception reading the settings file';

  @override
  TCommonSettingsGroup get settingsForm => _commonSettingsGroup;

  @override
  TCommonSettingsGroupWidget buildForm(BuildContext context) =>
      TCommonSettingsGroupWidget(form: _commonSettingsGroup);
}
