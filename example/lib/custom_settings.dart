import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/views/settings.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/string.dart';
import 'package:tfields/widgets/rounded_border.dart';

class CustomSettings extends CommonSettings {
  String customValue = '';

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

mixin CustomSettingsReader on SettingsReader<CustomSettings> {
  @override
  CustomSettings settingsFromJson(String fileContents) =>
      CustomSettings.fromJson(json.decode(fileContents));

  @override
  CustomSettings settingsFromDefault() => CustomSettings.fromDefault();
}

class CustomSettingsWidget extends AbstractSettingsWidget<CustomSettings> {
  const CustomSettingsWidget({required super.title, super.key});

  @override
  State<CustomSettingsWidget> createState() => CustomSettingsState();
}

class CustomSettingsState
    extends AbstractSettingsState<CustomSettings, CustomSettingsWidget>
    with CustomSettingsReader {
  /// The custom value string form...
  late TFormString _customValueForm;

  /// ...and its key, used to access the form's inner state
  final StringFormKey _customValueFormKey = StringFormKey();

  @override
  bool get hasChanges =>
      super.hasChanges ||
      (_customValueFormKey.currentState?.hasChanges ?? false);

  @override
  void updateSettingsWithForm() {
    super.updateSettingsWithForm();
    settings.customValue = _customValueFormKey.currentState!.value;
  }

  @override
  void resetFormValues() {
    super.resetFormValues();
    _customValueFormKey.currentState!.resetInitialValue();
  }

  @override
  List<Widget> get additionalForms => <Widget>[
    TRoundedBorder(
      color: TFormTitle.subtitleColor,
      childPadding: const EdgeInsets.only(right: 15),
      child: _customValueForm,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _customValueForm = TFormString(
      enabled: true,
      title: 'A custom value used by the app',
      subtitle: "We don't know why it's required, but surely it's useful!",
      initialValue: settings.customValue,
      hintText: 'Give it a value!',
      onValueChanged: (_) => setState(() {}),
      key: _customValueFormKey,
    );
  }

  @override
  String get unhandledExceptionMessage => 'A weird exception happened';
}
