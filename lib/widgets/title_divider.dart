import 'package:flutter/material.dart';

/// A Divider that displays a Text in the middle of the divider, eating up as
/// much width as necessary
class TTitleDivider extends StatelessWidget {
  /// The text that will be displayed
  final String titleText;

  /// How much margin should be left on the left side, before the title. Will
  /// align the text to the left if defined
  final double? leftMargin;

  /// How much margin should be left on the right side, before the title. Will
  /// align the text to the right if defined
  final double? rightMargin;

  const TTitleDivider({
    required this.titleText,
    super.key,
  }) : leftMargin = null, rightMargin = null;

  /// Forces the title to align to the left
  const TTitleDivider.left({
    required this.titleText,
    double this.leftMargin = 20,
    super.key,
  }) : rightMargin = null;

  /// Forces the title to align to the right
  const TTitleDivider.right({
    required this.titleText,
    double this.rightMargin = 20,
    super.key,
  }) : leftMargin = null;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (leftMargin != null)
          Flexible(
            flex: 0,
            child: SizedBox(width: leftMargin, child: const Divider()),
          )
        else
          const Expanded(child: Divider()),
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              titleText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        if (rightMargin != null)
          Flexible(
            flex: 0,
            child: SizedBox(width: rightMargin, child: const Divider()),
          )
        else
          const Expanded(child: Divider()),
      ],
    );
  }
}
