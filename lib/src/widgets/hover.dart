import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

/// The state associated with a THoverWidget, which wraps the child in a
/// TClickable, keeping track of the hover state, which can be checked via the
/// [isHighlighted] getter
mixin THoverState<W extends THoverWidget> on State<W> {
  bool _highlighted = false;

  /// Whether the hover detection is currently enabled or not
  bool get hoverEnabled => widget.hoverEnabled;

  /// Whether this widget is being hovered over or not
  bool get isHighlighted => _highlighted;

  /// The child that will be drawn inside the TClickable
  Widget buildChild(BuildContext context);

  /// A wrapper around the [TClickable.onEnter] event binding, so that mixin
  /// implementers can override the behavior
  void onHoverEnter(PointerEnterEvent event) {
    setState(() {
      _highlighted = true;
    });
  }

  /// A wrapper around the [TClickable.onExit] event binding, so that mixin
  /// implementers can override the behavior
  void onHoverExit(PointerExitEvent event) {
    setState(() {
      _highlighted = false;
    });
  }

  /// The callback that is called when the user clicks on the widget's hover
  /// area. By default, falls back to the function passed as an argument to the
  /// StatefulWidget
  void onHoverTap() => widget.onHoverTap?.call();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TClickable(
      enabled: hoverEnabled,
      onTap: onHoverTap,
      // These callbacks are only really useful for web and desktop
      // environments, since mobile users have no mouse cursor to
      // enter and leave the Widget's region
      onEnter: (PointerEnterEvent event) {
        onHoverEnter(event);
        widget.hoverUpdateCallback();
      },
      onExit: (PointerExitEvent event) {
        onHoverExit(event);
        widget.hoverUpdateCallback();
      },
      child: buildChild(context),
    );
  }
}

/// The state associated with a THoverWidget, which wraps the child in a
/// TClickable, keeping track of the hover state and position, which can be
/// checked via the [isHighlighted] and [hoverPosition] getters, respectively
mixin THoverTrackerState<W extends THoverWidget> on THoverState<W> {
  Offset _hoverPosition = Offset.zero;

  /// The current hover position, widget coordinates
  ///
  /// Null when the cursor is not hovering over the widget
  Offset? get hoverPosition =>
      hoverEnabled && isHighlighted ? _hoverPosition : null;

  /// A wrapper around the [TClickable.onHover] event binding, so that mixin
  /// implementers can override the behavior
  void onHoverEvent(PointerHoverEvent hoverEvent) {
    setState(() {
      _hoverPosition = hoverEvent.localPosition;
    });
  }

  @override
  @nonVirtual
  // ignore: invalid_override_of_non_virtual_member
  Widget build(BuildContext context) {
    return TClickable(
      enabled: hoverEnabled,
      onTap: onHoverTap,
      // These callbacks are only really useful for web and desktop
      // environments, since mobile users have no mouse cursor to
      // enter and leave the Widget's region
      onEnter: (PointerEnterEvent event) {
        onHoverEnter(event);
        widget.hoverUpdateCallback();
      },
      onExit: (PointerExitEvent event) {
        onHoverExit(event);
        widget.hoverUpdateCallback();
      },
      onHover: (PointerHoverEvent event) {
        onHoverEvent(event);
        widget.hoverUpdateCallback();
      },
      child: buildChild(context),
    );
  }
}
