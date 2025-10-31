import 'package:flutter/material.dart';
import 'package:tfields/widgets/grid/item.dart';

/// A specialization of TGridItem that wraps the provided children widgets in a
/// Column, to avoid the boilerplate of specifying a Column as a child to
/// TGridItem. Much like TGridItem, this specifies how the item will behave
/// under each different GridBreakpoint, by assigning a flex value for each of
/// the possible breakpoints.
///
/// If a breakpoint is not directly specified, it will either:
///
/// - Inherit the size from a smaller GridBreakpoint
/// - Inherit the size from a bigger GridBreakpoint, if the size has negative
/// flex and will consume the entire row
/// - Inherit the default behaviour (flex 1, not expanded)
///
/// For example, specifying (sm: 2, lg: 3) will result in the following values:
///
/// - xs: 1 (default behaviour)
/// - sm: 2 (specified directly)
/// - md: 2 (inherited from sm)
/// - lg: 3 (specified directly)
/// - xl: 3 (inherited from lg)
/// - xxl: 3 (inherited from xl)
class TGridColumn extends TGridItem {
  TGridColumn({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    super.xs,
    super.sm,
    super.md,
    super.lg,
    super.xl,
    super.xxl,
  }) : super(
    child: Column(crossAxisAlignment: crossAxisAlignment, children: children),
  );

  /// Forces xs to have a flex of 12, to make sure every size respects
  /// bootstrap's limit of 12 for every size. Any size can still be overriden by
  /// the caller
  TGridColumn.bootstrap({
    required List<Widget> children,
    super.xs,
    super.sm,
    super.md,
    super.lg,
    super.xl,
    super.xxl,
  }) : super.bootstrap(child: Column(children: children));

  /// Assigns the same size to all possible GridBreakpoints
  TGridColumn.fixedSize({
    required List<Widget> children,
    required super.size,
  }) : super.fixedSize(child: Column(children: children));
}
