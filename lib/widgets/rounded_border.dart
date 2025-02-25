import 'package:flutter/material.dart';

/// A wrapper for a DecoratedBox with rounded borders in all corners
class TRoundedBorder extends StatelessWidget {
  /// The border's color
  final Color color;

  /// The border's width
  final double width;

  /// The padding to apply when drawing the child
  final EdgeInsets childPadding;

  /// The child widget
  final Widget child;

  const TRoundedBorder({
    required this.child,
    required this.color,
    this.width = 1.0,
    this.childPadding = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: width),
      ),
      child: Padding(
        padding: childPadding,
        child: child,
      ),
    );
  }
}
