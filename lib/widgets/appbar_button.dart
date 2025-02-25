import 'package:flutter/material.dart';
import 'package:tfields/widgets/clickable.dart';

/// A button located inside an AppBar
class TAppBarButton extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// The icon to be displayed
  final IconData icon;

  /// The callback for when the widget is clicked on
  final void Function() onTap;

  const TAppBarButton({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TClickable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
