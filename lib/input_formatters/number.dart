import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/extensions/int.dart';

@immutable
abstract class NumberInputFormatter<T extends Comparable<T>>
    extends TextInputFormatter {
  final T? minValue;
  final T? maxValue;
  final T? Function(String) tryParse;
  final String Function(T)? commaSeparate;

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
    // Rollback empty value to zero
    if (baseText.isEmpty && minValue != null) {
      baseText = minValue.toString();
    }
    // Check if value is negative to properly handle comparisons
    bool isNegative = baseText[0] == '-';
    // Remove leading zeroes
    int firstIndex = isNegative ? 1 : 0;
    while (baseText.length > firstIndex + 1 && baseText[firstIndex] == '0') {
      baseText = (isNegative ? '-' : '') + baseText.substring(firstIndex + 1);
    }
    // Apply min and max rules
    T? value = tryParse(baseText);
    if (value == null) {
      return oldValue;
    }
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

class _ComparableInt implements Comparable<_ComparableInt> {
  final int _value;

  const _ComparableInt(this._value);

  @override
  int compareTo(_ComparableInt other) => _value.compareTo(other._value);
}

@immutable
class IntInputFormatter extends NumberInputFormatter<_ComparableInt> {
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

@immutable
class BigIntInputFormatter extends NumberInputFormatter<BigInt> {
  BigIntInputFormatter({
    super.minValue,
    super.maxValue,
    bool commaSeparate = false,
  }) : super(
    commaSeparate: commaSeparate ? ((BigInt v) => v.commaSeparate()) : null,
    tryParse: BigInt.tryParse,
  );
}
