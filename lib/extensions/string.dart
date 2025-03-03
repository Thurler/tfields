extension StringExtension on String {
  /// Capitalizes the first character of this string
  ///
  /// Example: "hello".upperCaseFirstChar() returns "Hello"
  ///
  /// Returns a new string with the first character in uppercase
  String upperCaseFirstChar() {
    return replaceRange(0, 1, this[0].toUpperCase());
  }

  /// Returns the first character in the string, or empty if the string is
  /// empty
  String get first => isNotEmpty ? substring(0, 1) : '';

  /// Returns the last character in the string, or empty if the string is
  /// empty
  String get last => isNotEmpty ? substring(length - 1) : '';
}
