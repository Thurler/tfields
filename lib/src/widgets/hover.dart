import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tfields/src/widgets/clickable.dart';

/// A THoverWidget will wrap its child in a TClickable, to keep track of the
/// MouseRegion's onEnter and onExit calls, so that the associated State has a
/// getter informing whether the widget is being hovered over
mixin THoverWidget on StatefulWidget {
  /// Whether the hover detection will be enabled or not
  bool get hoverEnabled;

  /// A callback for when the user clicks on the widget
  void Function()? get onHoverTap;

  /// The callback that is called whenever the widget faces a state change, so
  /// it can be propagated upwards in the tree
  void Function() get hoverUpdateCallback;
}

/// The state assocated with a THoverWidget, which wraps the child in a
/// TClickable, keeping track of the hover state, which can be checked via the
/// [isHighlighted] getter
mixin THoverState<W extends THoverWidget> on State<W> {
  bool _highlighted = false;

  /// Whether this widget is being hovered over or not
  bool get isHighlighted => _highlighted;

  /// The child that will be drawn inside the TClickable
  Widget buildChild(BuildContext context);

  /// The callback that is called when the user clicks on the widget's hover
  /// area. By default, falls back to the function passed as an argument to the
  /// StatefulWidget
  void onHoverTap() => widget.onHoverTap?.call();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TClickable(
      enabled: widget.hoverEnabled,
      onTap: onHoverTap,
      // These callbacks are only really useful for web and desktop
      // environments, since mobile users have no mouse cursor to
      // enter and leave the Widget's region
      onEnter: (_) => setState(() {
        _highlighted = true;
        widget.hoverUpdateCallback();
      }),
      onExit: (_) => setState(() {
        _highlighted = false;
        widget.hoverUpdateCallback();
      }),
      child: buildChild(context),
    );
  }
}
