import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/hover.dart';

/// A wrapper for a DecoratedBox with rounded borders in all corners
class TRoundedBorder extends StatelessWidget {
  /// The border's color
  final Color? color;

  /// The border's width
  final double width;

  /// The padding to apply when drawing the child
  final EdgeInsets childPadding;

  /// The child widget
  final Widget child;

  const TRoundedBorder({
    required this.child,
    this.childPadding = EdgeInsets.zero,
    this.width = 1,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: color ?? Theme.of(context).colorScheme.onSurface,
          width: width,
        ),
      ),
      child: Padding(padding: childPadding, child: child),
    );
  }
}

/// A TRoundedBorder that keeps track of whether it is being highlighted or not,
/// while also providing clickable functionality thanks to requiring a
/// TClickable to have MouseRegion logic
class TClickableRoundedBorder extends THoverWidget {
  /// The padding to apply when drawing the child
  final EdgeInsets childPadding;

  /// How wide the border will be when not highlighted - defaults to 1
  final double normalWidth;

  /// How wide the border will be when highlighted - defaults to 3
  final double highlightedWidth;

  /// Which color the border will be when not highlighted - defaults to the
  /// regular surface color
  final Color? normalColor;

  /// Which color the border will be when highlighted - defaults to the primary
  /// color scheme color
  final Color? highlightedColor;

  /// Thw widget's child, that will be rendered inside the clickable area
  final Widget child;

  const TClickableRoundedBorder({
    required this.child,
    required super.stateUpdateCallback,
    required super.enabled,
    this.childPadding = EdgeInsets.zero,
    this.highlightedWidth = 3,
    this.normalWidth = 1,
    this.highlightedColor,
    this.normalColor,
    super.onTap,
    super.key,
  });

  @override
  State<TClickableRoundedBorder> createState() =>
      _TClickableRoundedBorderState();
}

class _TClickableRoundedBorderState
    extends THoverState<TClickableRoundedBorder> {
  @override
  Widget buildChild(BuildContext context) {
    return TRoundedBorder(
      childPadding: widget.childPadding,
      // By piggybacking on a TClickable's onEnter and onExit events,
      // you can also highlight the border whenever the user's mouse
      // enters and leaves the TRoundedBorder's region
      color: isHighlighted
        ? (widget.highlightedColor ?? Theme.of(context).colorScheme.primary)
        : widget.normalColor,
      width: isHighlighted ? widget.highlightedWidth : widget.normalWidth,
      child: widget.child,
    );
  }
}
