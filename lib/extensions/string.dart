extension StringExtension on String {
  /// Capitalizes the first character of this string
  ///
  /// Example: "hello".upperCaseFirstChar() returns "Hello"
  ///
  /// Returns a new string with the first character in uppercase
  String upperCaseFirstChar() {
    return replaceRange(0, 1, this[0].toUpperCase());
  }
}
