import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/mixins/grid_breakpoint_aware.dart';
import 'package:tfields/widgets/grid/breakpoint.dart';
import 'package:tfields/widgets/grid/item.dart';
import 'package:tfields/widgets/grid/size.dart';

/// A class to help specify limits to an TGridRow, with the same fallbacks as
/// defined in that class
class TGridRowLimits {
  final int? _xs;
  final int? _sm;
  final int? _md;
  final int? _lg;
  final int? _xl;
  final int? _xxl;

  const TGridRowLimits({
    int? xs,
    int? sm,
    int? md,
    int? lg,
    int? xl,
    int? xxl,
  }) : _xs = xs, _sm = sm, _md = md, _lg = lg, _xl = xl, _xxl = xxl;

  int? get xxl => _xxl;
  int? get xl => _xl ?? _xxl;
  int? get lg => _lg ?? _xl ?? _xxl;
  int? get md => _md ?? _lg ?? _xl ?? _xxl;
  int? get sm => _sm ?? _md ?? _lg ?? _xl ?? _xxl;
  int? get xs => _xs ?? _sm ?? _md ?? _lg ?? _xl ?? _xxl;
}

/// A wrapper around StatelessWidget for a real TGridItem. Will wrap the
/// real item's child in either a Flexible or Expanded with the appropriate
/// flex, according to the specified GirdBreakpoint
class _TGridItem extends StatelessWidget {
  /// The item to be drawn
  final TGridItem item;

  /// The TGridBreakpoint to use when rendering
  final TGridBreakpoint breakpoint;

  /// The base flex for negative flex values
  final int baseFlex;

  const _TGridItem({
    required this.item,
    required this.breakpoint,
    required this.baseFlex,
  });

  @override
  Widget build(BuildContext context) {
    TGridSize size = item.sizes[breakpoint]!;
    // Make sure negative flex is cast into any positive integer
    int flex = size.flex >= 0 ? size.flex : baseFlex;
    return size.expanded
      ? Expanded(flex: flex, child: item.child)
      : Flexible(flex: flex, child: item.child);
  }
}

/// A Row that behaves in accordance to a grid sytem, governed by Flex values
/// specified by its children. Each child will have a different Flex value for
/// each TGridBreakpoint, and the entire Row will have a limit for how much Flex
/// "fits" in each physical row in the grid, splitting overflowed elements to
/// the next physical row
///
/// If limits are not specified to each TGridBreakpoint, they will accept any
/// number of elements inside them, only breaking physical rows in the grid when
/// an element specifically requests for an entire row (done via a negative flex
/// value). Specifying a limit for one TGridBreakpoint will apply that same
/// limit to any breakpoint smaller than it.
///
/// For example, specifying (sm: 1, xl: 3) results in:
///
/// - xs: 1 (inherited from sm)
/// - sm: 1 (specified directly)
/// - md: 3 (inherited from lg)
/// - lg: 3 (inherited from xl)
/// - xl: 3 (specified directly)
/// - xxl: null (accepts infinite flex)
///
/// Flex limits can be specified per TGridBreakpoint so that full control of how
/// the elements position themselves can be achieved. For example, let's say we
/// have the following item specifications:
///
/// - Item 1 (xs: 2, sm and up: 1)
/// - Item 2 (always 1)
/// - Item 3 (xs and sm: 2, md and up: 1)
/// - Item 4 (xs: 1, sm and up: 0)
///
/// We will have differing flex values for each TGridBreakpoint, and we can
/// fully control how the lines are broken by defining limits. For the example
/// above, defining `xsFlexLimit` to 2 will result in each item occupying its
/// own row, since no matter what two elements add up to 3 flex. But if we
/// instead set it to `xsFlexLimit` to 3, then we end up with two rows, with the
/// items grouped in pairs.
///
/// In the same example, setting `smFlexLimit` to 2 also results in two rows,
/// since Item 1 and Item 2 both have a flex of 1; and Item 3 has a flex of 2,
/// but Item 4 has a flex of 0, meaning it will "stick" to the row without
/// consuming any of its limit. Having it set to 1, however, would split items
/// 1 and 2, but not 3 and 4, since flex 0 ignores all limits
class TGridRow extends StatelessWidget with TGridBreakpointAware {
  /// The children that belong to this row. Must be TGridItem so we can
  /// be aware of how they will align their flex values with the
  /// TGridBreakpoints
  final List<TGridItem> children;

  /// How each row will align itself
  final MainAxisAlignment mainAxisAlignment;

  /// How each item will vertically align itself in its row
  final CrossAxisAlignment crossAxisAlignment;

  /// The widget that will space elements in the same row
  final Widget? horizontalSpacer;

  /// The widget that will space rows vertically
  final Widget? verticalSpacer;

  /// The map of allowed flex values for each TGridBreakpoint
  late final Map<TGridBreakpoint, int?> _allowedFlexes;

  /// Whether we're adapting the flex logic to bootstrap's fixed 12 limit or not
  final bool _usingBootstrapLogic;

  /// Whether we'll force intrinsic height for each row of content
  final bool _forceIntrinsicHeight;

  TGridRow({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.horizontalSpacer = const SizedBox(width: 20),
    this.verticalSpacer = const SizedBox(height: 20),
    bool forceIntrinsicHeight = false,
    TGridRowLimits? limits,
    int? xsFlexLimit,
    int? smFlexLimit,
    int? mdFlexLimit,
    int? lgFlexLimit,
    int? xlFlexLimit,
    int? xxlFlexLimit,
    super.key,
  }) :
    _usingBootstrapLogic = false,
    _forceIntrinsicHeight = forceIntrinsicHeight {
    // Map the given flexes to the sizes, cascading them downwards as they are
    // defined
    _allowedFlexes = <TGridBreakpoint, int?>{
      TGridBreakpoint.xxl: limits?.xxl ?? xxlFlexLimit,
      TGridBreakpoint.xl: limits?.xl ?? xlFlexLimit ?? xxlFlexLimit,
      TGridBreakpoint.lg:
          limits?.lg ?? lgFlexLimit ?? xlFlexLimit ?? xxlFlexLimit,
      TGridBreakpoint.md: limits?.md ?? mdFlexLimit ?? lgFlexLimit ??
          xlFlexLimit ?? xxlFlexLimit,
      TGridBreakpoint.sm: limits?.sm ?? smFlexLimit ?? mdFlexLimit ??
          lgFlexLimit ?? xlFlexLimit ?? xxlFlexLimit,
      TGridBreakpoint.xs: limits?.xs ?? xsFlexLimit ?? smFlexLimit ??
          mdFlexLimit ?? lgFlexLimit ?? xlFlexLimit ?? xxlFlexLimit,
    };
  }

  /// Specify the flex limit for every size should be 12, and that specific
  /// logic to mimic bootstrap behavior should be used
  TGridRow.bootstrap({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.horizontalSpacer = const SizedBox(width: 20),
    this.verticalSpacer = const SizedBox(height: 20),
    bool forceIntrinsicHeight = false,
    super.key,
  }) :
    _usingBootstrapLogic = true,
    _forceIntrinsicHeight = forceIntrinsicHeight,
    _allowedFlexes = <TGridBreakpoint, int?>{
      for (TGridBreakpoint point in TGridBreakpoint.values) point: 12,
    };

  @override
  Widget build(BuildContext context) {
    // First we compute our flex limit, if present
    TGridBreakpoint breakpoint = getBreakpoint(context);
    int? maxFlex = _allowedFlexes[breakpoint];
    // Then initialize the data that will be used to render several canvas rows
    List<List<Widget>> rows = <List<Widget>>[];
    List<Widget> currentRow = <Widget>[];
    int? remainingFlex = maxFlex;
    // Iterate on each item, applying the flex logic to the rows as needed
    for (TGridItem item in children) {
      int flex = item.sizes[breakpoint]!.flex;
      // If the item we are adding has negative flex, it will take up the whole
      // row, so we flush the previous row - we also do this if we have a
      // positive flex value, but not enough remaining flex in the current row
      if (
        flex < 0 || (remainingFlex != null && flex > 0 && flex > remainingFlex)
      ) {
        if (currentRow.isNotEmpty) {
          // If using bootstrap logic and there is some remaining flex for the
          // previous row, we pad it out to imitate bootstrap behavior of
          // leaving a blank space after the col
          if (
            _usingBootstrapLogic && remainingFlex != null && remainingFlex > 0
          ) {
            currentRow.add(
              Flexible(flex: remainingFlex, child: const SizedBox()),
            );
          }
          rows.add(currentRow);
          currentRow = <Widget>[];
        }
        remainingFlex = maxFlex;
      }
      // Add our current item to the current row
      currentRow.add(
        _TGridItem(
          item: item,
          breakpoint: breakpoint,
          baseFlex: _usingBootstrapLogic ? 12 : 1,
        ),
      );
      // If the item has negative flex, we must flush the current row to avoid
      // concatenating elements on next iteration - otherwise we just subtract
      // the current flex from the remaining one, if we have a limit
      if (flex < 0) {
        rows.add(currentRow);
        currentRow = <Widget>[];
        remainingFlex = maxFlex;
      } else if (remainingFlex != null) {
        remainingFlex -= flex;
      }
    }
    // After iterating, make sure to add the final row if it has elements
    if (currentRow.isNotEmpty) {
      if (_usingBootstrapLogic && remainingFlex != null && remainingFlex > 0) {
        currentRow.add(Flexible(flex: remainingFlex, child: const SizedBox()));
      }
      rows.add(currentRow);
    }
    // The result is a Column of Rows, divided according to our rows variable
    Iterable<Widget> widgetRows = rows.map<Widget>(
      (List<Widget> elements) => Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: elements.separateWith(horizontalSpacer),
      ),
    );
    // Make sure we wrap the rows in IntrinsicHeights if the flag calls for it
    if (_forceIntrinsicHeight) {
      widgetRows = widgetRows.map((Widget row) => IntrinsicHeight(child: row));
    }
    return Column(children: widgetRows.separateWith(verticalSpacer));
  }
}
