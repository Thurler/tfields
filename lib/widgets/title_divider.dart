import 'package:flutter/material.dart';

/// A Divider that displays a Text in the middle of the divider, eating up as
/// much width as necessary
class TTitleDivider extends StatelessWidget {
  final Color dividerColor;
  final String titleText;

  /// The button text style - defaults to titleLarge with bold
  final TextStyle? styleOverride;

  const TTitleDivider({
    required this.titleText,
    this.dividerColor = Colors.grey,
    this.styleOverride,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(color: dividerColor),
        ),
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              titleText,
              style: styleOverride ??
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Divider(color: dividerColor),
        ),
      ],
    );
  }
}
