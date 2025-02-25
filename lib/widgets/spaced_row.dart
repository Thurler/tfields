import 'package:flutter/material.dart';
import 'package:tfields/tfields.dart';

/// A wrapper class for a Row whose elemnts all share the same flex number and
/// class (e.g.: Expanded). A spacer widget can also be provided to interleave
/// between children - usually a SizedBox with fixed width/height for Rows/Cols
class TSpacedRow extends StatelessWidget {
  /// The row's children
  final List<Widget> children;

  /// Whether the children should be Expanded (TRUE) or Flexible (FALSE)
  final bool expanded;

  /// The spacer to use between children
  final Widget? spacer;

  /// The row's MainAxisSize
  final MainAxisSize mainAxisSize;

  /// The row's MainAxisAlignment
  final MainAxisAlignment mainAxisAlignment;

  /// The row's CrossAxisAlignment
  final CrossAxisAlignment crossAxisAlignment;

  const TSpacedRow({
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.expanded = false,
    this.spacer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map<Widget>(
        (Widget w) => w is Flexible
          ? w
          : expanded
            ? Expanded(child: w)
            : Flexible(child: w),
      ).separateWith(spacer),
    );
  }
}
