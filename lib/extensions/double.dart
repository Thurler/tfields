import 'package:tfields/extensions/int.dart';

extension DoubleExtendion on double {
  /// Formats a double value's integer part with comma separators
  ///
  /// Example: (1234.56).commaSeparate() returns "1,234.56"
  String commaSeparate() {
    List<String> parts = toString().split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '.';

    // Parse and format the integer part with commas using the extension
    int? intValue = int.tryParse(integerPart);
    String formattedInteger =
        intValue != null ? intValue.commaSeparate() : integerPart;

    // Return with decimal places if they exist
    return '$formattedInteger$decimalPart';
  }
}
