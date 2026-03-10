import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/text_overflow_tooltip.dart';

/// A wrapper around a Chip that contains an icon and a text next to each other,
/// similar to TIconText but wrapped inside a Chip
class TIconChip extends StatelessWidget {
  /// The text that will be displayed
  final String text;

  /// The icon that will be displayed
  final IconData icon;

  /// The chip's background color - defaults to the primary container color
  final Color? backgroundColor;

  /// The chip's background color - defaults to the primary container text color
  final Color? textColor;

  /// Whether the default color used will be primary container or error
  /// container
  final bool _defaultToWarningColor;

  /// Whether the chip will expand horizontally or not
  final MainAxisSize mainAxisSize;

  const TIconChip({
    required this.text,
    required this.icon,
    this.mainAxisSize = MainAxisSize.min,
    this.backgroundColor,
    this.textColor,
    super.key,
  }) : _defaultToWarningColor = false;

  /// A specialization of the constructor that defaults to an information icon
  const TIconChip.information(
    this.text, {
    this.mainAxisSize = MainAxisSize.min,
    super.key,
  }) :
    icon = Icons.info,
    backgroundColor = null,
    textColor = null,
    _defaultToWarningColor = false;

  /// A specialization of the constructor that defaults to a warning icon, and
  /// swaps the colors with error colors (usually red for most color schemes)
  const TIconChip.warning(
    this.text, {
    this.mainAxisSize = MainAxisSize.min,
    super.key,
  }) :
    icon = Icons.warning,
    backgroundColor = null,
    textColor = null,
    _defaultToWarningColor = true;

  /// Collapses the members into a final background color
  Color _backgroundColor(BuildContext context) {
    return backgroundColor ?? (_defaultToWarningColor
      ? Theme.of(context).colorScheme.errorContainer
      : Theme.of(context).colorScheme.primaryContainer);
  }

  /// Collapses the members into a final text color
  Color _textColor(BuildContext context) {
    return textColor ?? (_defaultToWarningColor
      ? Theme.of(context).colorScheme.onErrorContainer
      : Theme.of(context).colorScheme.onPrimaryContainer);
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: _textColor(context)),
      label: SizedBox(
        width: switch (mainAxisSize) {
          MainAxisSize.max => double.infinity,
          MainAxisSize.min => null,
        },
        child: TextOverflowTooltip(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: _textColor(context),
          ),
        ),
      ),
      backgroundColor: _backgroundColor(context),
    );
  }
}
