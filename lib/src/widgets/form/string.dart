import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/src/mixins/icon_updateable_form.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/icons.dart';
import 'package:tfields/src/widgets/input_decoration.dart';

typedef TStringFormKey = GlobalKey<TFormStringState>;

/// A specialization of the generic Form that allows the user to input a String
class TFormString extends TForm<String> {
  /// The formatters that will be applied to the TextEditingController
  final List<TextInputFormatter> formatters;

  /// The hint that will be displayed when the current value is empty
  final String hintText;

  /// Whether multiple lines are accepted or not
  final bool isMultiline;

  /// A callback that will be called whenever the user hits the "Enter" key
  final void Function()? submitCallback;

  const TFormString({
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.isMultiline = false,
    this.hintText = '',
    this.formatters = const <TextInputFormatter>[],
    this.submitCallback,
    super.readonly,
    super.subtitle = '',
    super.errorMessage = '',
    super.prefixIcon,
    super.suffixIcon,
    super.decoratorIcon,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  });

  /// Standardizes the prefix icon into a search icon and the suffix icon into a
  /// send icon that triggers [submitCallback]
  TFormString.searchBar({
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.hintText = '',
    this.formatters = const <TextInputFormatter>[],
    this.submitCallback,
    super.readonly,
    super.subtitle = '',
    super.errorMessage = '',
    super.decoratorIcon,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) :
    isMultiline = false,
    super(
      prefixIcon: const Icon(Icons.search),
      suffixIcon: TButton.iconOnly(
        icon: const TIcon(icon: Icons.send),
        text: 'Search',
        onPressed: submitCallback,
      ),
    );

  @override
  TFormStringState createState() => TFormStringState();
}

/// The StringForm's internal state
class TFormStringState extends IconUpdateableTFormState<String, TFormString> {
  /// The controller that the user will interact with
  final TextEditingController _controller = TextEditingController();

  @override
  set value(String? newValue) {
    // We override the value setter to make sure we copy the value into the
    // controller, mirroring the internal state with the controller
    _controller.text = newValue ?? '';
    super.value = newValue;
  }

  @override
  void initState() {
    super.initState();
    // Copy the initial state from the widget
    _controller.text = widget.initialValue ?? '';
    // Add a listener to the controller's input, so that its changes are
    // propagated to the form's callbacks
    _controller.addListener(() {
      // We explicitly call super.value here to avoid a recursion with the
      // custom setter above, since that changes the controller's value, which
      // would just call this again infinitely
      super.value = _controller.text;
      widget.onValueChanged?.call(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: _controller,
      inputFormatters: widget.formatters,
      onFieldSubmitted:
          enabled && !readonly ? (_) => widget.submitCallback?.call() : null,
      readOnly: readonly,
      keyboardType:
          widget.isMultiline ? TextInputType.multiline : TextInputType.text,
      maxLines: widget.isMultiline ? null : 1,
      decoration: TInputDecoration(
        enabled: enabled,
        labelText: title,
        helperText: subtitle,
        hintText: widget.hintText,
        icon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (_) => errorMessage.isNotEmpty ? errorMessage : null,
    );
  }
}
