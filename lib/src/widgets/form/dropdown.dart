import 'package:flutter/material.dart';
import 'package:tfields/src/extensions/iterable.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/input_decoration.dart';

typedef TDropdownFormKey<T> = GlobalKey<TFormDropdownState<T>>;

/// How the dropdown sort logic should be implemented
enum TDropdownSortLogic {
  /// No sorting is performed
  none,

  /// Sorting is done based on the dropdown type (the type must implement the
  /// `Comparable` interface with itself)
  object,

  /// Sorting is based on the dropdown text that is displayed for the object
  text;
}

/// A specialization of the generic Form that allows the user to input a value
/// form a list of options in a dropdown
class TFormDropdown<T> extends TForm<T> {
  /// The options that will be displayed to the user
  final List<T> options;

  /// The hint text that will be displayed when no option is selected
  final String hintText;

  /// The function that will be used to convert T into a String for the user
  final String Function(T) toDropdownText;

  /// Whether the last option should be interpreted as an "other" option to
  /// draw a secondary form for the user to fill in the custom value
  final bool otherOptionEnabled;

  /// Whether the "other" option's form will be placed horizontally or
  /// vertically aligned with this form. Providing "null" means the form won't
  /// be rendered at all
  final Axis? otherOptionAxis;

  /// The text that will be displayed when the "other" option is selected
  final String otherOptionText;

  /// The widget that will hold the form for the "other" option. It MUST have a
  /// key associated with it, so that we can access the form value
  final TForm<T>? otherOptionForm;

  /// The object that is used as a placeholder value for the "other" option in
  /// the dropdown. It will be returned when the form fails to return the input
  /// value from the state
  final T? otherOptionPlaceholder;

  /// Defines how sorting should be performed in the dropdown elements. Defaults
  /// to ordering by the text value provided by the `toDropdownText` function
  final TDropdownSortLogic sortLogic;

  const TFormDropdown({
    required this.hintText,
    required this.toDropdownText,
    required this.options,
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.sortLogic = TDropdownSortLogic.text,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.readonly,
    super.validationCallback,
    super.onValueChanged,
    super.subtitle,
    super.errorMessage,
    super.key,
  }) :
    otherOptionForm = null,
    otherOptionPlaceholder = null,
    otherOptionEnabled = false,
    otherOptionText = '',
    otherOptionAxis = null;

  /// Specify an option to act as a "other" option, which will prompt the user
  /// with a new form to type the custom value in
  const TFormDropdown.withOtherOption({
    required TForm<T> this.otherOptionForm,
    required T this.otherOptionPlaceholder,
    required this.hintText,
    required this.options,
    required this.toDropdownText,
    required this.otherOptionAxis,
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.sortLogic = TDropdownSortLogic.text,
    this.otherOptionText = '',
    super.readonly,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.validationCallback,
    super.onValueChanged,
    super.subtitle,
    super.errorMessage,
    super.key,
  }) : otherOptionEnabled = true;

  @override
  TFormDropdownState<T> createState() => TFormDropdownState<T>();
}

/// The DropdownForm's internal state
class TFormDropdownState<T> extends TFormState<T, TFormDropdown<T>> {
  /// The key used to communicate with Flutter's dropdown's state
  final GlobalKey<FormFieldState<T>> _formState =
      GlobalKey<FormFieldState<T>>();

  /// The current list of options the dropdown will render
  late List<T> _options;

  // We override the value getter to return the form's value if the other option
  // is selected - fallback to the placeholder
  @override
  T? get value => super.value == widget.otherOptionPlaceholder
    ? (widget.otherOptionForm?.key as TFormKey<T>?)?.currentState?.value ??
        widget.otherOptionPlaceholder
    : super.value;

  /// Whether the currently selected option is the "other" option
  bool get otherOptionSelected =>
      widget.otherOptionEnabled && super.value == widget.otherOptionPlaceholder;

  /// A callback for the DropdownButtonFormField, which will update the internal
  /// selected newValue and call the appropriate callbacks
  void _updateValue(T? newValue) {
    if (newValue == null) {
      return;
    }
    setState(() {
      super.value = newValue;
    });
    widget.onValueChanged?.call(value);
  }

  /// Updates the dropdown's current list of options, preserving the option that
  /// was appointed as an "other" option, and preserving the current value if
  /// it is still among the new options provided
  void updateOptions(Set<T> newOptions) {
    setState(() {
      _options = newOptions.toList();
      // Reset the value if the previous one is not in the new options
      if (!otherOptionSelected && !_options.contains(value)) {
        value = null;
        _formState.currentState?.didChange(null);
      }
    });
    // Because this triggers a change in the internal state that could cause
    // a validation error or a change in how the value is interpreted, we call
    // on both the validation and change callbacks
    validate();
    widget.onValueChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    _options = widget.options;
  }

  @override
  Widget build(BuildContext context) {
    List<T> items = _options.toList();
    // Convert the options to their respective texts
    Map<T, String> itemTexts = <T, String>{
      for (final T option in items) option: widget.toDropdownText(option),
    };
    // Make sure we sort the options
    switch (widget.sortLogic) {
      // Sort by the object's own comparison function
      case TDropdownSortLogic.object: {
        if (items.isNotEmpty && items.first is Comparable) {
          items.sort();
        }
      }
      // Sort by text that will be displayed
      case TDropdownSortLogic.text: {
        items.sort(
          (T one, T other) => itemTexts[one]!.compareTo(itemTexts[other]!),
        );
      }
      // Do nothing if no logic is set
      case TDropdownSortLogic.none: {}
    }
    // Add the other option placeholder into the list of items, if present. We
    // made a shallow copy above to preserve the original list
    T? placeholder = widget.otherOptionPlaceholder;
    if (widget.otherOptionEnabled && placeholder != null) {
      items.add(placeholder);
      // Use the other option text, if provided and this is the placeholder -
      // otherwise, use the conversion function
      itemTexts[placeholder] = widget.otherOptionText.isNotEmpty
        ? widget.otherOptionText
        : widget.toDropdownText(placeholder);
    }
    Widget dropdown = DropdownButtonFormField<T>(
      key: _formState,
      hint: Text(widget.hintText),
      initialValue: super.value, // Use super here since we override the getter
      onChanged: enabled && !readonly ? _updateValue : null,
      items: items.map(
        (T option) =>
            DropdownMenuItem<T>(value: option, child: Text(itemTexts[option]!)),
      ).toList(),
      decoration: TInputDecoration(
        enabled: enabled,
        labelText: title,
        helperText: subtitle,
        icon: widget.decoratorIcon,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (_) => errorMessage.isNotEmpty ? errorMessage : null,
    );
    // Just return the DropdownButtonFormField if no other option selected
    // Use super.value here since we override the getter, which can lead to
    // dirty values being used for comparison
    if (
      !widget.otherOptionEnabled || super.value != widget.otherOptionPlaceholder
    ) {
      return dropdown;
    }
    // Otherwise, we put the widget next to the other form widget
    return switch (widget.otherOptionAxis) {
      Axis.horizontal => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(child: dropdown),
            Flexible(child: widget.otherOptionForm!),
          ].separateWith(const SizedBox(width: 20)),
        ),
      Axis.vertical => Column(
          children: <Widget>[dropdown, widget.otherOptionForm!].separateWith(
            const SizedBox(height: 10),
          ),
        ),
      null => dropdown,
    };
  }
}
