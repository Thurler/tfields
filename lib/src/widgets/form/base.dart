import 'package:flutter/material.dart';

typedef TGenericForm = TForm<dynamic>;
typedef TGenericFormKey = TFormKey<dynamic>;
typedef TFormKey<T> = GlobalKey<TFormState<T, TForm<T>>>;

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
    String Function(Value?)? validationCallback,
    TFormKey<Value>? super.key,
  }) : validationCallback = validationCallback ?? _alwaysValid;

  @override
  TFormState<Value, TForm<Value>> createState();
}

/// The Form's internal state
abstract class TFormState<Value, AForm extends TForm<Value>>
    extends State<AForm> {
  /// The form's error message, that will be displayed under the applicable
  /// InputDecorator
  String errorMessage = '';

  /// The initial value to start with - this is also used to detect changes, by
  /// comparing the current value to initialValue
  late Value? initialValue;

  bool _enabled = false;
  bool _readonly = false;
  String _title = '';
  String _subtitle = '';

  /// Whether the form is currently enabled or not
  bool get enabled => _enabled;
  set enabled(bool newValue) {
    setState(() {
      _enabled = newValue;
    });
  }

  /// Whether the form is currently readonly or writable - this will not prevent
  /// editing the value directly, but will prevent the user from interacting
  /// with the form to change the state
  bool get readonly => _readonly;
  set readonly(bool newValue) {
    setState(() {
      _readonly = newValue;
    });
  }

  /// The form's title, that will be displayed in the applicable InputDecorator
  String get title => _title;
  set title(String newValue) {
    setState(() {
      _title = newValue;
    });
  }

  /// The form's subtitle, that will be displayed under the applicable
  /// InputDecorator
  String get subtitle => _subtitle;
  set subtitle(String newValue) {
    setState(() {
      _subtitle = newValue;
    });
  }

  /// A shorthand getter for comparing the current value to the initial value
  bool get hasChanges => value != initialValue;

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
    setState(() {
      errorMessage = widget.validationCallback(value);
    });
  }

  /// This saves the current value as the new initialValue, effectively
  /// resetting the hasChanges check
  void resetInitialValue() {
    initialValue = value;
  }

  /// This saves the current value as the new initialValue, effectively
  /// resetting the hasChanges check, along with returning the current value
  Value? saveValue() {
    resetInitialValue();
    return value;
  }

  @override
  void initState() {
    super.initState();
    // Copy the initial state from the widget
    _enabled = widget.enabled;
    _readonly = widget.readonly;
    _title = widget.title;
    _subtitle = widget.subtitle;
    value = widget.initialValue;
    initialValue = widget.initialValue;
    // And then force a validation to make sure invalid initial values are
    // already loaded with the appropriate error message
    validate();
  }
}
