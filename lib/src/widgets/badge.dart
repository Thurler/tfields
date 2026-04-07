import 'package:flutter/material.dart';

/// A badge that will be displayed alongside an icon / button
class TIconBadge {
  /// The color used by the badge. Defaults to a solid red if not defined
  final Color? color;

  /// An optional text to be shown inside the badge
  final String? label;

  const TIconBadge({this.label, this.color});
}
