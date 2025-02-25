import 'package:flutter/material.dart';

/// An ElevatedButton that has been standardized
class TButton extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// The callback to call when the button is pressed
  final void Function()? onPressed;

  /// The icon to be displayed
  final IconData? icon;

  /// The icon widget to be displayed - will have priority over the icon data
  final Widget? iconWidget;

  /// The font size - defaults to 18
  final double fontSize;

  /// Whether the button will have infinite width - defaults to TRUE
  final bool usesMaxWidth;

  const TButton({
    required this.text,
    this.iconWidget,
    this.onPressed,
    this.icon,
    this.fontSize = 18,
    this.usesMaxWidth = true,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: usesMaxWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null || iconWidget != null) ...<Widget>[
              iconWidget != null ? iconWidget! : Icon(icon),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
