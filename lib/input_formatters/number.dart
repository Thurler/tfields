import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/extensions/int.dart';

/// Base class for numeric input formatters that restricts text input to valid
/// numbers and provides min/max validation and comma separation formatting
@immutable
abstract class NumberInputFormatter<T extends Comparable<T>>
    extends TextInputFormatter {
  /// Minimum allowed value (inclusive)
  final T? minValue;

  /// Maximum allowed value (inclusive)
  final T? maxValue;

  /// Function to parse string input to target number type
  final T? Function(String) tryParse;

  /// Optional function to format numbers with comma separation
  final String Function(T)? commaSeparate;

  /// Creates a number formatter with optional min/max constraints and formatting
  ///
  /// The [tryParse] function is required to convert string input to the target
  /// type.
  /// [minValue] and [maxValue] are optional constraints (inclusive bounds).
  /// [commaSeparate] is an optional function to format numbers with comma
  /// separators.
  const NumberInputFormatter({
    required this.tryParse,
    this.minValue,
    this.maxValue,
    this.commaSeparate,
  }) : super();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String baseText = newValue.text;
    // Rollback empty value to min value, if present
    if (baseText.isEmpty && minValue != null) {
      baseText = minValue.toString();
    }
    // Try to parse the number input into a string - if it fails, just return
    // the previous value
    T? value = tryParse(baseText);
    if (value == null) {
      return oldValue;
    }
    // Apply min and max rules, if present
    if (minValue != null && value.compareTo(minValue!) < 0) {
      value = minValue;
    } else if (maxValue != null && value.compareTo(maxValue!) > 0) {
      value = maxValue;
    }
    // Get the cursor shift from our updates
    int cursorShift = value.toString().length - oldValue.text.length;
    // Compute and place the commas to separate digits
    String finalText =
        commaSeparate != null ? commaSeparate!(value!) : value.toString();
    // Compute the final cursor position
    int textDiff = finalText.length - baseText.length;
    int finalOffset = oldValue.selection.baseOffset + cursorShift + textDiff;
    // Snap back to text end if mass deletion caused negative offset
    // Or if for some reason we ever go overboard, snap back to text end
    if (finalOffset < 1 || finalOffset > finalText.length) {
      finalOffset = finalText.length;
    }
    // Finally, return with the new values
    return newValue.copyWith(
      text: finalText,
      selection: newValue.selection.copyWith(
        baseOffset: finalOffset,
        extentOffset: finalOffset,
      ),
    );
  }
}

/// Private wrapper class that makes int values comparable for use with
/// NumberInputFormatter
///
/// This is needed because NumberInputFormatter requires a Comparable<T> type
class _ComparableInt implements Comparable<_ComparableInt> {
  /// The wrapped int value
  final int _value;

  /// Creates a new comparable wrapper for an int value
  const _ComparableInt(this._value);

  @override
  int compareTo(_ComparableInt other) => _value.compareTo(other._value);
}

/// Input formatter for integer values
///
/// Restricts input to valid integers and enforces min/max constraints.
/// Can optionally format numbers with comma separators (e.g. 1,234,567).
@immutable
class IntInputFormatter extends NumberInputFormatter<_ComparableInt> {
  /// Creates a new formatter for integer input
  ///
  /// [minValue] sets the minimum allowed value (inclusive, optional)
  /// [maxValue] sets the maximum allowed value (inclusive, optional)
  /// [commaSeparate] when true, formats numbers with comma separators
  /// (e.g. 1,234,567)
  IntInputFormatter({
    int? minValue,
    int? maxValue,
    bool commaSeparate = false,
  }) : super(
    minValue: minValue != null ? _ComparableInt(minValue) : null,
    maxValue: maxValue != null ? _ComparableInt(maxValue) : null,
    commaSeparate:
        commaSeparate ? ((_ComparableInt v) => v._value.commaSeparate()) : null,
    tryParse: (String v) {
      int? parsed = int.tryParse(v);
      return parsed != null ? _ComparableInt(parsed) : null;
    },
  );
}

/// Input formatter for BigInt values (for handling extremely large integers)
///
/// Restricts input to valid BigInt values and enforces min/max constraints.
/// Can optionally format numbers with comma separators.
@immutable
class BigIntInputFormatter extends NumberInputFormatter<BigInt> {
  /// Creates a new formatter for BigInt input
  ///
  /// [minValue] sets the minimum allowed value (inclusive, optional)
  /// [maxValue] sets the maximum allowed value (inclusive, optional)
  /// [commaSeparate] when true, formats numbers with comma separators
  BigIntInputFormatter({
    super.minValue,
    super.maxValue,
    bool commaSeparate = false,
  }) : super(
    commaSeparate: commaSeparate ? ((BigInt v) => v.commaSeparate()) : null,
    tryParse: BigInt.tryParse,
  );
}
