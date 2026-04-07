import 'package:flutter/material.dart';

/// A mixin that makes a widget aware of some standardized colors
mixin TStandardColorer on Widget {
  /// The standardized success color
  Color? successColor(BuildContext context) =>
      switch (Theme.of(context).brightness) {
    Brightness.light => Colors.green[700],
    Brightness.dark => Colors.green[300],
  };

  /// The standardized error color
  Color? errorColor(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  /// The standardized notification surface color for badges
  Color? notificationSurfaceColor(BuildContext context) => Colors.red;

  /// The standardized on notification surface color for badge texts
  Color? onNotificationSurfaceColor(BuildContext context) => Colors.white;
}
