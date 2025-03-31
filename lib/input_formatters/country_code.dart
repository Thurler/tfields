import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class for forcing country code formatting, restricting to two uppercase
/// A-Z characters
@immutable
class CountryCodeInputFormatter extends TextInputFormatter {
  const CountryCodeInputFormatter() : super();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String baseText = newValue.text.toUpperCase();
    if (baseText.length > 2) {
      return oldValue;
    }
    return newValue.copyWith(text: baseText);
  }
}
