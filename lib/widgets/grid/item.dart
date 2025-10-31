import 'package:flutter/material.dart';
import 'package:tfields/widgets/grid/breakpoint.dart';
import 'package:tfields/widgets/grid/size.dart';

/// A specialized map that will hold values for all possible TGridBreakpoints
typedef TSizeMap = Map<TGridBreakpoint, TGridSize>;

/// A specialized map that will hold values for all possible TGridBreakpoints
typedef _NullSizeMap = Map<TGridBreakpoint, TGridSize?>;

/// The item positioned in a grid. Specifies how the item will behave under each
/// different TGridBreakpoint, by assigning a flex value for each of the
/// possible breakpoints
///
/// If a breakpoint is not directly specified, it will either:
///
/// - Inherit the size from a smaller TGridBreakpoint
/// - Inherit the size from a bigger TGridBreakpoint, if the size has negative
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
class TGridItem {
  /// By default, if nothing is specified, an item will be Flexible with a flex
  /// value of 1
  static const TGridSize _defaultFlex = TGridSize(1);

  /// By default, if nothing is specified, an item will be Flexible with a flex
  /// value of 12 in bootstrap logic
  static const TGridSize _defaultBootstrap = TGridSize(12);

  /// The sizes associated with each TGridBreakpoint
  late final TSizeMap sizes;

  /// The child that will be rendered in the grid
  final Widget child;

  TGridItem({
    required this.child,
    TGridSize? xs,
    TGridSize? sm,
    TGridSize? md,
    TGridSize? lg,
    TGridSize? xl,
    TGridSize? xxl,
  }) {
    // Take the sizes and cascade them upwards as they are defined
    _NullSizeMap nullableSizes = <TGridBreakpoint, TGridSize?>{
      TGridBreakpoint.xs: xs,
      TGridBreakpoint.sm: sm ?? xs,
      TGridBreakpoint.md: md ?? sm ?? xs,
      TGridBreakpoint.lg: lg ?? md ?? sm ?? xs,
      TGridBreakpoint.xl: xl ?? lg ?? md ?? sm ?? xs,
      TGridBreakpoint.xxl: xxl ?? xl ?? lg ?? md ?? sm ?? xs,
    };
    // Cascade any fills downwards too, in case we have nulls
    for (TGridBreakpoint point in TGridBreakpoint.values) {
      if ((nullableSizes[point]?.flex ?? 0) < 0) {
        for (TGridBreakpoint smaller in point.smallerSizes) {
          nullableSizes[smaller] ??= nullableSizes[point];
        }
      }
    }
    // If anything is still null, we set the default behavior
    sizes = <TGridBreakpoint, TGridSize>{
      for (TGridBreakpoint point in TGridBreakpoint.values)
        point: nullableSizes[point] ?? _defaultFlex,
    };
  }

  /// Forces xs to have a flex of 12, to make sure every size respects
  /// bootstrap's limit of 12 for every size. Any size can still be overriden by
  /// the caller
  TGridItem.bootstrap({
    required Widget child,
    TGridSize xs = _defaultBootstrap,
    TGridSize? sm,
    TGridSize? md,
    TGridSize? lg,
    TGridSize? xl,
    TGridSize? xxl,
  }) : this(child: child, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Assigns the same size to all possible TGridBreakpoints
  TGridItem.fixedSize({required Widget child, required TGridSize size}) :
    this(child: child, xs: size);
}
