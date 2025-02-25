import 'package:flutter/material.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/string.dart';

/// A shorthand for a Dropdown Form's state
typedef DropdownFormKey = GlobalKey<TFormDropdownState>;

/// The Dropdown Form's field widget, composed of a DropdownButton and, if
/// provided, a subform that will be displayed when a "other" option is selected
/// in the dropdown
class TFormDropdownField extends TFormField {
  final bool enabled;
  final String value;
  final String hintText;
  final List<String> options;
  final void Function(String? value) updateValue;
  final Widget? otherOptionForm;

  const TFormDropdownField({
    required this.enabled,
    required this.value,
    required this.hintText,
    required this.options,
    required this.updateValue,
    this.otherOptionForm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: otherOptionForm != null ? 10 : 0),
      child: Column(
        children: <Widget>[
          DropdownButton<String>(
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
              child: Text(hintText),
            ),
            value: (value != '') ? value : null,
            onChanged: enabled ? updateValue : null,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(option),
                ),
              );
            }).toList(),
          ),
          if (otherOptionForm != null) otherOptionForm!,
        ],
      ),
    );
  }
}

/// The Dropdown Form's stateful widget, which expands a regular Form by adding
/// a list of options to select from, a hint text, and optional parameters for
/// making a TFormStringField for an "other" option in the dropdown
class TFormDropdown extends TForm<String> {
  /// The initially available dropdown options
  final List<String> options;

  /// The dropdown's hint text when no value is selected
  final String hintText;

  /// Whether the last option should be interpreted as an "other" option
  final bool otherOptionEnabled;

  /// The "other" option's controller hint text
  final String otherOptionHintText;

  const TFormDropdown({
    required this.hintText,
    required this.options,
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.validationCallback,
    super.onValueChanged,
    super.errorMessage,
    super.key,
  }) : otherOptionEnabled = false, otherOptionHintText = '';

  /// Forces the specification of regular options separate from the "other"
  /// option, to ensure it is at the bottom
  TFormDropdown.withOtherOption({
    required this.hintText,
    required this.otherOptionHintText,
    required List<String> regularOptions,
    required String otherOptionText,
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.validationCallback,
    super.onValueChanged,
    super.errorMessage,
    super.key,
  }) :
    options = regularOptions..add(otherOptionText),
    otherOptionEnabled = true;

  @override
  State<TFormDropdown> createState() => TFormDropdownState();
}

/// The Dropown Form's state, which only really handles the DropdownButton's
/// callbacks for value chages and handles updating the form's options
class TFormDropdownState extends TFormState<String, TFormDropdown> {
  /// The controller used for the "other" option, if enabled
  final TextEditingController otherOptionController = TextEditingController();

  late List<String> _options;

  /// Callback used in the DropdownButton
  void _updateValue(String? value) {
    if (value == null) {
      return;
    }
    setState(() {
      super.value = value;
    });
    widget.onValueChanged?.call(value);
  }

  /// Update the dropdown's available options, making sure the value stays
  /// consistent and that the "other" option is preserved, if not included
  void updateOptions(List<String> newOptions) {
    String? otherOption = widget.otherOptionEnabled ? _options.last : null;
    setState(() {
      _options = newOptions;
      // Forcefully include the "other" option
      if (otherOption != null && !newOptions.contains(otherOption)) {
        _options.add(otherOption);
      }
      // Reset the value if the previous one is not in the new options
      if (!newOptions.contains(value)) {
        value = '';
      }
    });
  }

  @override
  TFormField get field => TFormDropdownField(
    enabled: enabled,
    value: super.value,
    hintText: widget.hintText,
    options: _options,
    updateValue: _updateValue,
    otherOptionForm: widget.otherOptionEnabled && value == _options.last
      ? TFormStringField(
          enabled: enabled,
          hintText: widget.otherOptionHintText,
          controller: otherOptionController,
        )
      : null,
  );

  // Use the option index as an int value
  @override
  int get intValue => _options.indexOf(value);

  // Use the option index as a big int value
  @override
  BigInt get bigIntValue => BigInt.from(_options.indexOf(value));

  /// Returns the text set on the "other" option's text controller
  String get otherOptionValue => otherOptionController.text;

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    otherOptionController.addListener(() {
      widget.onValueChanged?.call(value);
    });
  }
}
