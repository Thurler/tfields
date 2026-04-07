extension StringExtension on String {
  /// Capitalizes the first character of this string
  ///
  /// Example: "hello".upperCaseFirstChar() returns "Hello"
  ///
  /// Returns a new string with the first character in uppercase
  String upperCaseFirstChar() => replaceRange(0, 1, this[0].toUpperCase());

  /// Returns the first character in the string, or empty if the string is
  /// empty
  String get first => isNotEmpty ? substring(0, 1) : '';

  /// Returns the last character in the string, or empty if the string is
  /// empty
  String get last => isNotEmpty ? substring(length - 1) : '';

  /// Returns the case-insentive version of the "contains" method, forcing both
  /// this and the pattern into lowercase versions before calling contains
  bool caseInsensitiveContains(Pattern other, [int startIndex = 0]) =>
      toLowerCase().contains(
    other is String ? other.toLowerCase() : other,
    startIndex,
  );

  /// Returns the case-insensitive version of the "compareTo" method, forcing
  /// both this and the other string into lowercase versions before comparing
  int caseInsensitiveCompareTo(String other) =>
      toLowerCase().compareTo(other.toLowerCase());
}
