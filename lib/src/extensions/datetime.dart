extension DateTimeExtension on DateTime {
  /// Returns a human-readable string representing the time passed since this
  /// [DateTime].
  ///
  /// Format is "X unit(s) ago" where unit is the largest applicable time unit
  /// (days, hours, minutes, or seconds).
  ///
  /// If less than one second has passed, returns "less than a second ago".
  ///
  /// Optional [reference] parameter specifies the reference point for the
  /// calculation (defaults to the current time).
  String relativeTimestamp([DateTime? reference]) {
    DateTime base = reference ?? DateTime.now();
    Duration difference = base.difference(this);
    int? number;
    String? name;
    if (difference.inDays > 0) {
      number = difference.inDays;
      name = 'day';
    } else if (difference.inHours > 0) {
      number = difference.inHours;
      name = 'hour';
    } else if (difference.inMinutes > 0) {
      number = difference.inMinutes;
      name = 'minute';
    } else if (difference.inSeconds > 0) {
      number = difference.inSeconds;
      name = 'second';
    }
    if (number != null && name != null) {
      return '$number $name${number > 1 ? 's' : ''} ago';
    }
    return 'less than a second ago';
  }
}
