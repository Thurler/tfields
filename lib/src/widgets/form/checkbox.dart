import 'package:flutter/material.dart';
import 'package:tfields/src/mixins/icon_updateable_form.dart';
import 'package:tfields/src/widgets/clickable.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/input_decoration.dart';

typedef TCheckboxFormKey = GlobalKey<TFormCheckboxState>;

/// A specialization of the generic Form that allows the user to interact with a
/// checkbox
class TFormCheckbox extends TForm<bool> {
  /// The text displayed alongside the checkbox
  final String text;

  const TFormCheckbox({
    required this.text,
    required super.enabled,
    required super.title,
    required bool super.initialValue,
    super.readonly,
    super.decoratorIcon,
    super.validationCallback,
    super.onValueChanged,
    super.subtitle,
    super.errorMessage,
    super.suffixIcon,
    super.saveWithErrorOptions,
    super.key,
  });

  @override
  TFormCheckboxState createState() => TFormCheckboxState();
}

class TFormCheckboxState extends TFormState<bool, TFormCheckbox>
    with
        DecoratorIconUpdateableForm<bool, TFormCheckbox>,
        SuffixIconUpdateableForm<bool, TFormCheckbox> {
  /// A controller that will display the fixed checkbox text
  final TextEditingController controller = TextEditingController();

  void _updateValue(bool value) {
    setState(() {
      super.value = value;
    });
    widget.onValueChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    // Copy the initial state from the widget
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return TClickable(
      onTap: enabled && !readonly ? () => _updateValue(!value!) : null,
      child: TextFormField(
        enabled: enabled,
        readOnly: true,
        controller: controller,
        decoration: TInputDecoration(
          prefixIcon: Checkbox(
            value: value,
            onChanged:
                enabled && !readonly ? (_) => _updateValue(!value!) : null,
          ),
          suffixIcon: suffixIcon,
          labelText: title,
          helperText: subtitle,
          icon: decoratorIcon,
        ),
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => errorMessage.isNotEmpty ? errorMessage : null,
      ),
    );
  }
}
