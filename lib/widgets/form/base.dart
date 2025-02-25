import 'package:flutter/material.dart';
import 'package:tfields/widgets/spaced_row.dart';

/// A Generic Key used by a Form, typed by the Form's T type
typedef FormKey<T> = GlobalKey<TFormState<T, TForm<T>>>;

/// An exception raised when accessing a from value conversion that is invalid
/// for the form type being accessed
class FormTypeException implements Exception {
  const FormTypeException() : super();
}

/// A Form's title widget, that sits on the left side of the form. It is
/// stateless and merely reflects the form's title, subtitle and error message
class TFormTitle extends StatelessWidget {
  static const Color subtitleColor = Colors.grey;

  /// The form's title, displayed in regular text font and color
  final String title;

  /// The form's subtitle, displayed in muted text font and color
  final String subtitle;

  /// The form's validation error message, displayed in red text font and color
  final String errorMessage;

  const TFormTitle({
    required this.title,
    required this.subtitle,
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: RichText(
        text: TextSpan(
          style: const TextStyle(color: subtitleColor),
          children: <TextSpan>[
            TextSpan(text: subtitle),
            TextSpan(
              text: errorMessage != '' ? '\n$errorMessage' : '',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

/// A generic Form's field widget, that sits on the right side of the form. It
/// is stateless and merely reflects the form's value
abstract class TFormField extends StatelessWidget {
  const TFormField({super.key});
}

/// A generic Form, which value is a generic type. It is initialized with an
/// enable/disable flag; a starting title, subtitle and error message; an
/// initial value of matching type; an optional validation callback and a
/// callback to be notified of value changes
abstract class TForm<U> extends StatefulWidget {
  /// A function that always returns an empty error message
  static String _alwaysValid(dynamic value) => '';

  /// Whether the form is enabled or disabled
  final bool enabled;

  /// The form's title, usually a short description of what is being input
  final String title;

  /// The form's subtitle, usually a longer description of the context the
  /// value will be used in
  final String subtitle;

  /// The form's error message, as returned by the validation callback
  final String errorMessage;

  /// The form's initial value
  final U initialValue;

  /// A validation callback that receives the current value of he form and
  /// returns an error message to be displayed. If the value is valid, an empty
  /// string should be returned
  final String Function(U) validationCallback;

  /// A callback to receive notifications of value changes
  final ValueChanged<U?>? onValueChanged;

  const TForm({
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.initialValue,
    this.validationCallback = _alwaysValid,
    this.errorMessage = '',
    this.onValueChanged,
    super.key,
  });
}

/// A generic Form's state, responsible for receiving updates to the basic
/// variables of a form - such as its subtitle or whether it is enable, as well
/// as handle value changes and initial value alterations
abstract class TFormState<U, T extends TForm<U>> extends State<T> {
  String errorMessage = '';
  late U initialValue;

  // Gotta override the setter to call setState
  bool _enabled = false;
  bool get enabled => _enabled;
  set enabled(bool newValue) {
    setState(() {
      _enabled = newValue;
    });
  }

  // Similarly for the title
  String _title = '';
  String get title => _title;
  set title(String newValue) {
    setState(() {
      _title = newValue;
    });
  }

  // And the subtitle, wow
  String _subtitle = '';
  String get subtitle => _subtitle;
  set subtitle(String newValue) {
    setState(() {
      _subtitle = newValue;
    });
  }

  /// A getter that returns the concrete implementation of the form's right side
  /// - the value area. Because all forms share a common left side (the title
  /// area), only the right part is left abstract
  TFormField get field;

  bool get hasChanges => value != initialValue;
  bool get hasErrors => errorMessage != '';

  late U _value;
  U get value => _value;
  set value(U newValue) {
    _value = newValue;
    // Always validate the new value
    validate();
  }

  // int conversions are left abstract since each type can handle it in their
  // own unique way
  int get intValue;
  BigInt get bigIntValue;

  /// Validate the current value and assign the appropriate error message
  void validate() {
    setState(() {
      errorMessage = widget.validationCallback(value);
    });
  }

  /// Resets the initial value to the current value, effectively ensuring that
  /// the `hasChanges` getter becomes false
  void resetInitialValue() {
    initialValue = value;
  }

  /// Reset the initial value to the current value and return it
  U saveValue() {
    resetInitialValue();
    return value;
  }

  /// Reset the initial value to the current value and return it, cast to int
  int saveIntValue() {
    resetInitialValue();
    return intValue;
  }

  /// Reset the initial value to the current value and return it, cast to
  /// BingInt
  BigInt saveBigIntValue() {
    resetInitialValue();
    return bigIntValue;
  }

  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
    _title = widget.title;
    _subtitle = widget.subtitle;
    value = widget.initialValue;
    initialValue = widget.initialValue;
    // Always call validate on initState since the initialValue could be
    // invalid, and the caller might be unaware of it by not supplying an
    // initial error message
    validate();
  }

  @override
  Widget build(BuildContext context) {
    return TSpacedRow(
      children: <Widget>[
        TFormTitle(
          title: _title,
          subtitle: _subtitle,
          errorMessage: errorMessage,
        ),
        field,
      ],
    );
  }
}

/// A generic Form, which value is a list of a generic type. It is identical to
/// a regular form, with the exception that all operations now act on multiple
/// values, rather than a single one
abstract class TFormList<U> extends TForm<List<U>> {
  const TFormList({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.validationCallback,
    super.errorMessage,
    super.onValueChanged,
    super.key,
  });
}

/// A geniec FormList's state, that acts exactly like a regular Form's state,
/// except it must manage several internal values, as well as handle the
/// creation and deletion of new values
abstract class TFormListState<U, T extends TFormList<U>>
    extends TFormState<List<U>, T> {
  @override
  bool get hasChanges {
    // First we check if the length differs in O(1), since that already implies
    // there was a change in the form
    int length = initialValue.length;
    if (length != value.length) {
      return true;
    }
    // Next we check if any pair of values has changed in O(n). The form assumes
    // order is important for now, but that could be flexibilized at a later
    // point, but maybe it'd be best to make a TFormSet instead of shoehorning
    // that into the TFormList, anyway
    for (int i = 0; i < length; i++) {
      if (initialValue[i] != value[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  set value(List<U> newValue) {
    _value = newValue.toList(); // Make a shallow copy - do we need a deep one?
    validate();
  }

  // Would need to cast the whole list, but that breaks the override, so...
  @override
  int get intValue => throw const FormTypeException();

  // Would need to cast the whole list, but that breaks the override, so...
  @override
  BigInt get bigIntValue => throw const FormTypeException();

  @override
  void resetInitialValue() {
    initialValue = value.toList(); // Shallow copy again - need a deep one?
  }

  /// Update an index of the list with a new value - each value should be aware
  /// of what their index is, and all this function with its new value
  @mustCallSuper
  void update(int index, U newValue) {
    value[index] = newValue;
    widget.onValueChanged?.call(value);
    validate();
  }

  /// This DOES NOT add a new item to the list, since it could cause coupling
  /// issues with handling the internal state in the concrete class. This will
  /// merely call `validate` and `onValueChanged` with the new value
  @mustCallSuper
  void addRow() {
    validate();
    widget.onValueChanged?.call(value);
  }

  /// This WILL delete the value at the specified index, and then call both
  /// `validate` and `onValueChanged` with the new value
  @mustCallSuper
  void deleteRow(int index) {
    value.removeAt(index);
    validate();
    widget.onValueChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    value = widget.initialValue.toList(); // Another shallow copy - you get it
  }
}
