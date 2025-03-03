import 'package:tfields/extensions/int.dart';

extension DoubleExtendion on double {
  /// Formats a double value's integer part with comma separators. If
  /// [omitZeroDecimal] is provided as true, then the trailing .0 will always
  /// be omitted, as if formatting an integer
  ///
  /// Example: (1234.56).commaSeparate() returns "1,234.56"
  String commaSeparate({bool omitZeroDecimal = true}) {
    List<String> parts = toString().split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Parse and format the integer part with commas using the extension
    int? intValue = int.tryParse(integerPart);
    String formattedInteger =
        intValue != null ? intValue.commaSeparate() : integerPart;

    // If the decimal part is just a zero, we omit
    if (decimalPart == '0' && omitZeroDecimal) {
      return formattedInteger;
    }

    // Return with decimal places if they exist
    return '$formattedInteger.$decimalPart';
  }

  /// Omits the decimal part of the double number if it is equal to zero
  String toStringOmitZeroDecimal() {
    List<String> parts = toString().split('.');
    return parts.last == '0' ? parts.first : toString();
  }
}
