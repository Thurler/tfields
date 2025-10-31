import 'package:flutter/material.dart';

/// Resize the child widget to a specific viewport width fraction or a specific
/// fixed width. Can also bind a minimum and maximum widths for the fraction
/// approach
class TWidthFractionBox extends StatelessWidget {
  /// Force a specific width (or viewport width fraction) as opposed to letting
  /// it automatically determine the width
  final double fixedWidth;

  /// Force a minimum width to the child
  final double? minWidth;

  /// Force a maximum width to the child
  final double? maxWidth;

  /// The child that will be stretched to have variable width
  final Widget child;

  const TWidthFractionBox({
    required this.child,
    required this.fixedWidth,
    this.minWidth,
    this.maxWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // If the fixed width is negative for whatever reason, do nothing
    if (fixedWidth < 0) {
      return child;
    }
    // Compute the final width based on the provided arguments
    double finalWidth = fixedWidth > 1
      ? fixedWidth
      : (MediaQuery.of(context).size.width * fixedWidth);
    if (minWidth != null && finalWidth < minWidth!) {
      finalWidth = minWidth!;
    }
    if (maxWidth != null && finalWidth > maxWidth!) {
      finalWidth = maxWidth!;
    }
    return SizedBox(width: finalWidth, child: child);
  }
}
