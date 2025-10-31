import 'package:flutter/material.dart';
import 'package:tfields/extensions/comparable.dart';

/// The viewport widths we want to account for when making responsive grid
/// designs in Row widgets
enum TGridBreakpoint implements Comparable<TGridBreakpoint> {
  xs(0),
  sm(576),
  md(768),
  lg(992),
  xl(1200),
  xxl(1440);

  /// How many pixels will be used as a threshold for the viewport width
  final int width;

  const TGridBreakpoint(this.width);

  /// Get the breakpoint associated with the current viewport width
  factory TGridBreakpoint.fromWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // The values should already be sorted from their declaration
    for (TGridBreakpoint point in values.reversed) {
      if (width > point.width) {
        return point;
      }
    }
    return xs;
  }

  /// Returns the breakpoints that encode smaller screen sizes than this one
  Iterable<TGridBreakpoint> get smallerSizes =>
      values.where((TGridBreakpoint other) => other < this);

  @override
  int compareTo(TGridBreakpoint other) => width.compareTo(other.width);
}
