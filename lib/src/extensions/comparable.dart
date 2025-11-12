// It is honestly a mystery why these aren't already overloaded, but oh well

extension ComparableExtension<T> on Comparable<T> {
  bool operator <(T other) => compareTo(other) < 0;

  bool operator >(T other) => compareTo(other) > 0;

  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >=(T other) => compareTo(other) >= 0;
}
