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

  T? elementAtSafe(int index) => index < length ? elementAt(index) : null;
}
