import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';

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
        child: Row(
          children: <Widget>[
            if (icon != null)
              Flexible(
                flex: 0,
                child: Icon(icon, color: iconColor, size: iconSize),
              ),
            Flexible(
              child: Text(
                text,
                style: styleOverride ?? Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ].separateWith(const SizedBox(width: 5)),
        ),
      ),
    );
  }
}

/// A badge that will be displayed alongside an icon / button
class TIconBadge {
  /// The color used by the badge. Defaults to a solid red if not defined
  final Color? color;

  /// An optional text to be shown inside the badge
  final String? label;

  const TIconBadge({this.label, this.color});
}
