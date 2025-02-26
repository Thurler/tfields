import 'package:flutter/material.dart';

/// A Divider that displays a Text in the middle of the divider, eating up as
/// much width as necessary
class TTitleDivider extends StatelessWidget {
  final Color dividerColor;
  final String titleText;
  final double fontSize;
  final FontWeight fontWeight;

  const TTitleDivider({
    required this.titleText,
    this.dividerColor = Colors.grey,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w700,
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
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
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
