import 'package:flutter/material.dart';

typedef TGenericForm = TForm<dynamic>;
typedef TGenericFormKey = TFormKey<dynamic>;
typedef TFormKey<T> = GlobalKey<TFormState<T, TForm<T>>>;

/// A struct to hold functions that define how the [TForm] will behave when
/// attempting to save data that has generated error messages
class TFormSaveWithErrorOptions<Value> {
  /// A function that takes the current value and error message, returning a new
  /// warning message. Typically used to warn of side effects of forcing the
  /// save action with the error still present
  final String Function(Value?, String)? warningMessageBuilder;

  /// A callback that is called when the [TFormState.saveValue] function is
  /// called with a value that has generated an error message from validation.
  final void Function(Value?)? onSaveWithError;

  const TFormSaveWithErrorOptions({
    this.warningMessageBuilder,
    this.onSaveWithError,
  });
}

/// A generic Form that with generic Value type for its value
abstract class TForm<Value> extends StatefulWidget {
  /// A default validation function to make sure the validation always passes
  static String _alwaysValid(dynamic value) => '';

  /// Whether the form is enabled or not
  final bool enabled;

  /// The form's title, that will be displayed in the applicable InputDecorator
  final String title;

  /// The form's subtitle, that will be displayed under the applicable
  /// InputDecorator
  final String subtitle;

  /// The form's error message, that will be displayed under the applicable
  /// InputDecorator
  final String errorMessage;

  /// The initial value to start with
  final Value? initialValue;

  /// Whether the form is readonly or writable - this will not prevent editing
  /// the value directly, but will prevent the user from interacting with the
  /// form to change the state
  final bool readonly;

  /// The callback that is called whenever the value is changed, to trigger
  /// validation
  final String Function(Value?) validationCallback;

  /// A callback that will be called whenever the value is changed
  final ValueChanged<Value?>? onValueChanged;

  /// A widget that will be rendered to the left, outside the input decorator
  final Widget? decoratorIcon;

  /// A widget that will be rendered to the left, inside the input decorator
  final Widget? prefixIcon;

  /// A widget that will be rendered to the right, inside the input decorator
  final Widget? suffixIcon;

  /// The options to use when defining behavior related to saving a value that
  /// has generated an error message when being validated
  final TFormSaveWithErrorOptions<Value>? saveWithErrorOptions;

  const TForm({
    required this.enabled,
    required this.title,
    required this.initialValue,
    this.readonly = false,
    this.subtitle = '',
    this.errorMessage = '',
    this.onValueChanged,
    this.decoratorIcon,
    this.prefixIcon,
    this.suffixIcon,
    this.saveWithErrorOptions,
    String Function(Value?)? validationCallback,
    TFormKey<Value>? super.key,
  }) : validationCallback = validationCallback ?? _alwaysValid;

  @override
  TFormState<Value, TForm<Value>> createState();
}

/// The Form's internal state
abstract class TFormState<Value, AForm extends TForm<Value>>
    extends State<AForm> {
  late Value? _initialValue;

  /// The initial value to start with - this is also used to detect changes, by
  /// comparing the current value to initialValue
  Value? get initialValue => _initialValue;

  bool? _enabled;
  bool? _readonly;
  String? _title;
  String? _subtitle;
  String? _errorMessage;

  /// Whether the form is currently enabled or not
  bool get enabled => _enabled ?? widget.enabled;
  set enabled(bool newValue) {
    setState(() {
      _enabled = newValue;
    });
  }

  /// Whether the form is currently readonly or writable - this will not prevent
  /// editing the value directly, but will prevent the user from interacting
  /// with the form to change the state
  bool get readonly => _readonly ?? widget.readonly;
  set readonly(bool newValue) {
    setState(() {
      _readonly = newValue;
    });
  }

  /// The form's title, that will be displayed in the applicable InputDecorator
  String get title => _title ?? widget.title;
  set title(String newValue) {
    setState(() {
      _title = newValue;
    });
  }

  /// The form's subtitle, that will be displayed under the applicable
  /// InputDecorator
  String get subtitle => _subtitle ?? widget.subtitle;
  set subtitle(String newValue) {
    setState(() {
      _subtitle = newValue;
    });
  }

  /// The form's error message, that will be displayed under the applicable
  /// InputDecorator
  String get errorMessage => _errorMessage ?? widget.errorMessage;
  set errorMessage(String newMessage) {
    setState(() {
      _errorMessage = newMessage;
    });
  }

  /// The form's warning message when attempting to save the current value that
  /// has generated an error message. Returns an empty string when the current
  /// value is valid
  String get errorSaveWarningMessage => hasErrors
    ? widget.saveWithErrorOptions?.warningMessageBuilder?.call(
        value,
        errorMessage,
      ) ?? errorMessage
    : '';

  /// A shorthand getter for comparing the current value to the initial value
  bool get hasChanges => value != _initialValue;

  /// A shorthand getter for checking for an error message
  bool get hasErrors => errorMessage.isNotEmpty;

  late Value? _value;

  /// The form's current value
  Value? get value => _value;
  set value(Value? newValue) {
    _value = newValue;
    validate();
  }

  /// The function that is called whenever the form needs validation. Will
  /// call the validation callback and store its result in errorMessage
  void validate() {
    errorMessage = widget.validationCallback(value);
  }

  /// This saves the current value as the new initialValue, effectively
  /// resetting the hasChanges check
  void resetInitialValue() {
    _initialValue = copyValue(value);
  }

  /// This saves the current value as the new initialValue, effectively
  /// resetting the hasChanges check, along with returning the current value.
  ///
  /// If a [TFormSaveWithErrorOptions.onSaveWithError] callback was provided in
  /// [TForm.saveWithErrorOptions], then that callback is invoked here if the
  /// current value is invalid
  Value? saveValue() {
    if (hasErrors && widget.saveWithErrorOptions?.onSaveWithError != null) {
      widget.saveWithErrorOptions?.onSaveWithError?.call(value);
    }
    resetInitialValue();
    return value;
  }

  /// This makes a copy of a value, so that types that aren't copied on
  /// assignment can override the assignment behavior
  Value? copyValue(Value? source) => source;

  @override
  void initState() {
    super.initState();
    // Copy the initial state from the widget
    _initialValue = widget.initialValue;
    _value = copyValue(widget.initialValue);
    // And then force a validation to make sure invalid initial values are
    // already loaded with the appropriate error message
    validate();
  }
}
