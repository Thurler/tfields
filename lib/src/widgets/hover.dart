import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tfields/src/widgets/clickable.dart';

/// A THoverWidget will wrap its child in a TClickable, to keep track of the
/// MouseRegion's onEnter and onExit calls, so that the associated State has a
/// getter informing whether the widget is being hovered over
abstract class THoverWidget extends StatefulWidget {
  /// Whether the hover detection will be enabled or not
  final bool enabled;

  /// A callback for when the user clicks on the widget
  final void Function()? onTap;

  /// The callback that is called whenever the widget faces a state change, so
  /// it can be propagated upwards in the tree
  final void Function() stateUpdateCallback;

  const THoverWidget({
    required this.enabled,
    required this.stateUpdateCallback,
    this.onTap,
    super.key,
  });
}

/// The state assocated with a THoverWidget, which wraps the child in a
/// TClickable, keeping track of the hover state, which can be checked via the
/// [isHighlighted] getter
abstract class THoverState<W extends THoverWidget> extends State<W> {
  bool _highlighted = false;

  /// Whether this widget is being hovered over or not
  bool get isHighlighted => _highlighted;

  /// The child that will be drawn inside the TClickable
  Widget buildChild(BuildContext context);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TClickable(
      enabled: widget.enabled,
      onTap: widget.onTap,
      // These callbacks are only really useful for web and desktop
      // environments, since mobile users have no mouse cursor to
      // enter and leave the Widget's region
      onEnter: (_) => setState(() {
        _highlighted = true;
        widget.stateUpdateCallback();
      }),
      onExit: (_) => setState(() {
        _highlighted = false;
        widget.stateUpdateCallback();
      }),
      child: buildChild(context),
    );
  }
}
