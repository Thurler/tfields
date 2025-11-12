import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/clickable.dart';

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
class TClickableRoundedBorder extends StatefulWidget {
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

  /// The callback for when the widget area is clicked on
  final void Function()? onTap;

  /// The callback that is called whenever the rounded border faces a state
  /// change, so it can be propagated upwards in the tree
  final void Function() stateUpdateCallback;

  /// Thw widget's child, that will be rendered inside the clickable area
  final Widget child;

  const TClickableRoundedBorder({
    required this.stateUpdateCallback,
    required this.child,
    this.childPadding = EdgeInsets.zero,
    this.highlightedWidth = 3,
    this.normalWidth = 1,
    this.highlightedColor,
    this.normalColor,
    this.onTap,
    super.key,
  });

  @override
  State<TClickableRoundedBorder> createState() =>
      _TClickableRoundedBorderState();
}

class _TClickableRoundedBorderState extends State<TClickableRoundedBorder> {
  bool _highlighted = false;

  void _changeHighlight({required bool newValue}) {
    setState(() {
      _highlighted = newValue;
    });
    widget.stateUpdateCallback();
  }

  @override
  Widget build(BuildContext context) {
    return TClickable(
      onTap: widget.onTap,
      // These callbacks are only really useful for web and desktop
      // environments, since mobile users have no mouse cursor to
      // enter and leave the Widget's region
      onEnter: (_) => _changeHighlight(newValue: true),
      onExit: (_) => _changeHighlight(newValue: false),
      child: TRoundedBorder(
        childPadding: widget.childPadding,
        // By piggybacking on a TClickable's onEnter and onExit events,
        // you can also highlight the border whenever the user's mouse
        // enters and leaves the TRoundedBorder's region
        color: _highlighted
          ? (widget.highlightedColor ?? Theme.of(context).colorScheme.primary)
          : widget.normalColor,
        width: _highlighted ? widget.highlightedWidth : widget.normalWidth,
        child: widget.child,
      ),
    );
  }
}
