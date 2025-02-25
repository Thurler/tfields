import 'package:flutter/material.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/switch.dart';

/// A shorthand for a Switch Form's state
typedef SwitchFormKey = GlobalKey<TFormSwitchState>;

/// The Dropdown Form's field widget, composed of a simple TSwitch
class TFormSwitchField extends TFormField {
  final bool enabled;
  final bool value;
  final String offText;
  final String onText;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool value) updateValue;

  const TFormSwitchField({
    required this.enabled,
    required this.value,
    required this.offText,
    required this.onText,
    required this.updateValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TSwitch(
      onChanged: enabled ? updateValue : null,
      offText: offText,
      onText: onText,
      value: value,
    );
  }
}

/// The Dropdown Form's stateful widget, which expands a regular Form by adding
/// a text to be used in the "off" state and another in the "on" state
class TFormSwitch extends TForm<bool> {
  final String offText;
  final String onText;

  const TFormSwitch({
    required this.offText,
    required this.onText,
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.validationCallback,
    super.onValueChanged,
    super.errorMessage,
    super.key,
  });

  @override
  State<TFormSwitch> createState() => TFormSwitchState();
}

/// The Dropown Form's state, which only really handles the TSwitch's value
/// callbacks and maps them to the form's callbacks
class TFormSwitchState extends TFormState<bool, TFormSwitch> {
  void _updateValue(bool value) {
    setState(() {
      super.value = value;
    });
    widget.onValueChanged?.call(value);
  }

  @override
  TFormField get field => TFormSwitchField(
    enabled: enabled,
    offText: widget.offText,
    onText: widget.onText,
    updateValue: _updateValue,
    value: super.value,
  );

  // Use one and zero as integer values
  @override
  int get intValue => value ? 1 : 0;

  // Use one and zero as integer values
  @override
  BigInt get bigIntValue => value ? BigInt.one : BigInt.zero;
}
