import 'dart:math';
import 'dart:typed_data';

/// Formats a number string with comma separators for thousands
///
/// Examples:
/// - 1234 becomes "1,234"
/// - -5678 becomes "-5,678"
///
/// [numberString] The string representation of the number
/// [negative] Whether the number is negative
String _commaSeparateNumber(String numberString, {required bool negative}) {
  String raw = numberString;
  if (negative) {
    raw = raw.substring(1);
  }
  int startingDigits = raw.length % 3;
  if (startingDigits == 0) {
    startingDigits = 3;
  }
  StringBuffer copy = StringBuffer();
  copy.write(raw.substring(0, startingDigits));
  for (int i = startingDigits; i < raw.length; i += 3) {
    copy.write(',${raw.substring(i, i + 3)}');
  }
  String sign = negative ? '-' : '';
  return '$sign$copy';
}

extension IntExtension on int {
  /// Formats this integer with comma separators for thousands
  ///
  /// Example: 1234.commaSeparate() returns "1,234"
  String commaSeparate() =>
      _commaSeparateNumber(toString(), negative: this < 0);

  /// Converts this integer to a 16-bit unsigned integer byte sequence
  ///
  /// [endianness] The byte order (Endian.little or Endian.big)
  ///
  /// Returns a 2-byte sequence representing the number
  Iterable<int> toU16(Endian endianness) {
    List<int> bytes = List<int>.filled(2, 0);
    bytes[0] = this % 256;
    bytes[1] = (this ~/ 256) % 256;
    return endianness == Endian.little ? bytes : bytes.reversed;
  }

  /// Converts this integer to a 32-bit unsigned integer byte sequence
  ///
  /// [endianness] The byte order (Endian.little or Endian.big)
  ///
  /// Returns a 4-byte sequence representing the number
  Iterable<int> toU32(Endian endianness) {
    List<int> bytes = List<int>.filled(4, 0);
    for (int i = 0; i < 4; i++) {
      bytes[i] = (this ~/ pow(256, i)) % 256;
    }
    return endianness == Endian.little ? bytes : bytes.reversed;
  }

  /// Converts this integer to a 16-bit signed integer byte sequence
  ///
  /// Handles negative values by using two's complement representation
  ///
  /// [endianness] The byte order (Endian.little or Endian.big)
  ///
  /// Returns a 2-byte sequence representing the number
  Iterable<int> toI16(Endian endianness) {
    int operand = this;
    if (operand < 0) {
      operand += pow(2, 16) as int;
    }
    return operand.toU16(endianness);
  }

  /// Converts this integer to a 32-bit signed integer byte sequence
  ///
  /// Handles negative values by using two's complement representation
  ///
  /// [endianness] The byte order (Endian.little or Endian.big)
  ///
  /// Returns a 4-byte sequence representing the number
  Iterable<int> toI32(Endian endianness) {
    int operand = this;
    if (operand < 0) {
      operand += pow(2, 32) as int;
    }
    return operand.toU32(endianness);
  }
}

extension BigIntExtension on BigInt {
  /// Formats this BigInt with comma separators for thousands
  ///
  /// Example: BigInt.from(1234).commaSeparate() returns "1,234"
  String commaSeparate() =>
      _commaSeparateNumber(toString(), negative: this < BigInt.from(0));

  /// Converts this BigInt to a 64-bit unsigned integer byte sequence
  ///
  /// [endianness] The byte order (Endian.little or Endian.big)
  ///
  /// Returns an 8-byte sequence representing the number
  Iterable<int> toU64(Endian endianness) {
    List<int> bytes = List<int>.filled(8, 0);
    for (int i = 0; i < 8; i++) {
      bytes[i] = ((this ~/ BigInt.from(256).pow(i)) % BigInt.from(256)).toInt();
    }
    return endianness == Endian.little ? bytes : bytes.reversed;
  }
}
