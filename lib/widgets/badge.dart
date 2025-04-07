import 'package:flutter/material.dart';
import 'package:tfields/widgets/spaced_row.dart';

class TBadge extends StatelessWidget {
  final String text;
  final TextStyle? styleOverride;
  final Color? backgroundColorOverride;
  final Color? iconColor;
  final IconData? icon;
  final double iconSize;

  const TBadge({
    required this.text,
    this.iconSize = 20,
    this.iconColor,
    this.icon,
    this.backgroundColorOverride,
    this.styleOverride,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: backgroundColorOverride ??
            Theme.of(context).colorScheme.inversePrimary,
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
              style: styleOverride ?? Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
