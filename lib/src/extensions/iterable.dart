extension IterableExtension<T> on Iterable<T> {
  /// Deep copy a list's elements - caller is responsible for ensuring the
  /// provided function actually performs a deep copy
  Iterable<T> deepCopyElements(T Function(T) f) => map((T t) => f(t));

  /// Insert 'separator' in between each element of the list
  /// If 'separatorOnEnds' is provided, add it to start and end of list too
  List<T> separateWith(T? separator, {bool separatorOnEnds = false}) {
    if (separator == null) {
      return toList();
    }
    List<T> result = <T>[];
    if (separatorOnEnds) {
      result.add(separator);
    }
    for (int i = 0; i < length - 1; i++) {
      result.addAll(<T>[elementAt(i), separator]);
    }
    result.add(elementAt(length - 1));
    if (separatorOnEnds) {
      result.add(separator);
    }
    return result;
  }

  /// Return the first element that satisfies 'test', or null if none satisfy
  T? firstWhereOrNull(bool Function(T) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// Shorthand for calling the `contains` function on an iterable of T elements
  bool containsAny(Iterable<T>? values) => values?.any(contains) ?? false;

  /// Shorthand for calling the `contains` function on an iterable of T elements
  bool containsAll(Iterable<T>? values) => values?.every(contains) ?? true;

  /// A safe version of elementAt that returns null if the index is invalid
  T? elementAtSafe(int index) => index < length ? elementAt(index) : null;
}

extension IterableStringExtension on Iterable<String> {
  /// Return an iterable that filters out empty strings from this iterable
  Iterable<String> get nonEmpties => where((String value) => value.isNotEmpty);
}

extension IterableStringNullableExtension on Iterable<String?> {
  /// Return an iterable that filters out empty strings or null values from this
  /// iterable
  Iterable<String> get nonEmpties =>
      nonNulls.where((String value) => value.isNotEmpty);
}
