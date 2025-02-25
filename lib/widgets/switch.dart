import 'package:flutter/material.dart';

/// A wrapper around the Switch class, that expands on it by drawing text for
/// each of its states, leaving it perfectly clear what each state does
class TSwitch extends StatelessWidget {
  /// Style to use for the optional title
  static const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.w700);

  /// Style to use for the disabled text
  static const TextStyle disableStyle = TextStyle(color: Colors.grey);

  /// The callback to call when the Switch's state is changed
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool)? onChanged;

  /// The text to display when the Switch is OFF
  final String offText;

  /// The text to display when the Switch is ON
  final String onText;

  /// The title to display above the Switch
  final String title;

  /// The Switch's current value
  final bool value;

  /// Whether the Row housing the elements should have MainAxisSize max or min
  final bool expanded;

  const TSwitch({
    required this.value,
    this.expanded = true,
    this.offText = '',
    this.onText = '',
    this.title = '',
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget mainRow = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        if (offText != '')
          Expanded(
            child: Text(
              offText,
              textAlign: TextAlign.right,
              style: value ? disableStyle : null,
            ),
          ),
        Switch(
          value: value,
          activeTrackColor: Colors.green.withOpacity(0.4),
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
        if (onText != '')
          Expanded(
            child: Text(
              onText,
              style: value ? null : disableStyle,
            ),
          ),
      ],
    );
    if (!expanded) {
      mainRow = IntrinsicWidth(child: mainRow);
    }
    return Column(
      children: <Widget>[
        if (title != '') Text(title, style: titleStyle),
        mainRow,
      ],
    );
  }
}
