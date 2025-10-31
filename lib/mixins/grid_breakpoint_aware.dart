import 'package:flutter/material.dart';
import 'package:tfields/widgets/grid/breakpoint.dart';

/// Mixes in a convenience function for a class to be aware of the current
/// TGridBreakpoint, provided it has access to the BuildContext to fetch the
/// viewport width
mixin TGridBreakpointAware {
  TGridBreakpoint getBreakpoint(BuildContext context) =>
      TGridBreakpoint.fromWidth(context);
}
