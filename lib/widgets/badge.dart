import 'package:flutter/material.dart';
import 'package:tfields/widgets/spaced_row.dart';

class TBadge extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color textColor;
  final Color? iconColor;
  final IconData? icon;
  final double iconSize;

  const TBadge({
    required this.text,
    required this.color,
    required this.textColor,
    this.fontSize = 14,
    this.iconSize = 20,
    this.fontWeight = FontWeight.normal,
    this.iconColor,
    this.icon,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: TSpacedRow(
          spacer: const SizedBox(width: 5),
          children: <Widget>[
            if (icon != null)
              // Flex 0 allows the text to occupy all the width with its single
              // flex defined
              Flexible(
                flex: 0,
                child: Icon(icon, color: iconColor, size: iconSize),
              ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
