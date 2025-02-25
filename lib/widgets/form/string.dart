import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/spaced_row.dart';

/// A shorthand for a String Form's state
typedef StringFormKey = GlobalKey<TFormStringState<TFormString>>;

/// The String Form's field widget, composed of a simple TextFormField,
/// decorated with a hint and suffix icons
class TFormStringField extends TFormField {
  final bool enabled;
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final List<Widget> icons;

  const TFormStringField({
    required this.enabled,
    required this.hintText,
    required this.controller,
    this.formatters,
    this.icons = const <Widget>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      style: const TextStyle(fontSize: 18),
      inputFormatters: formatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Theme.of(context).textTheme.displayMedium?.color?.withOpacity(
            0.5,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        suffixIcon: icons.isNotEmpty
          ? TSpacedRow(
              mainAxisSize: MainAxisSize.min,
              spacer: const SizedBox(width: 2),
              children: icons,
            )
          : null,
      ),
    );
  }
}

/// The Dropdown Form's stateful widget, which expands a regular Form by adding
/// a list of formatters to mask the input, and a hint text used when the value
/// is empty
class TFormString extends TForm<String> {
  final List<TextInputFormatter> formatters;
  final String hintText;

  const TFormString({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    this.hintText = '',
    this.formatters = const <TextInputFormatter>[],
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.key,
  });

  @override
  State<TFormString> createState() => TFormStringState<TFormString>();
}

/// The String Form's state, which only really handles the text controller's
/// value callbacks and maps them to the form's callbacks
class TFormStringState<T extends TFormString> extends TFormState<String, T> {
  final TextEditingController controller = TextEditingController();
  late List<TextInputFormatter> formatters;

  @override
  set value(String newValue) {
    controller.text = newValue;
    super.value = newValue;
  }

  @override
  void initState() {
    super.initState();
    formatters = widget.formatters;
    controller.text = widget.initialValue;
    controller.addListener(() {
      // Call the super setter here to avoid infinite recursion, I guess
      super.value = controller.text;
      widget.onValueChanged?.call(controller.text);
    });
  }

  @override
  TFormField get field => TFormStringField(
    enabled: enabled,
    hintText: widget.hintText,
    controller: controller,
    formatters: formatters,
  );

  // Parse the current value as an int, removing helper commas
  @override
  int get intValue => int.parse(value.replaceAll(',', ''));

  // Parse the current value as a big int, removing helper commas
  @override
  BigInt get bigIntValue => BigInt.parse(value.replaceAll(',', ''));
}
