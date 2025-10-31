import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A wrapper for a GestureDetector that handles mouse cursor manipulation and
/// tap callbacks. Also provides a wrapper for the onEnter and onExit events of
/// a MouseRegion, for e.g.: highlight effects
class TClickable extends StatelessWidget {
  /// The callback for when the widget area is clicked on
  final void Function()? onTap;

  /// The callback for when the mouse cursor enters the widget area
  final void Function(PointerEnterEvent)? onEnter;

  /// The callback for when the mouse cursor exits the widget area
  final void Function(PointerExitEvent)? onExit;

  /// Whether the clickable effects are enabled or not
  final bool enabled;

  /// Whether the clickable area should be wrapped in an InkWell or not
  final bool useInkWell;

  /// The widget's child
  final Widget child;

  const TClickable({
    required this.child,
    this.enabled = true,
    this.useInkWell = false,
    this.onTap,
    this.onEnter,
    this.onExit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MouseRegion mouseRegion = MouseRegion(
      cursor: enabled && onTap != null
        ? SystemMouseCursors.click
        : SystemMouseCursors.basic,
      onEnter: enabled ? onEnter : null,
      onExit: enabled ? onExit : null,
      child: enabled && onTap != null ? IgnorePointer(child: child) : child,
    );
    return useInkWell
      ? InkWell(onTap: enabled ? onTap : null, child: mouseRegion)
      : GestureDetector(onTap: enabled ? onTap : null, child: mouseRegion);
  }
}
