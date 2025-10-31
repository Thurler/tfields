import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/mixins/standard_colorer.dart';

enum _DialogColorType {
  success,
  error,
  custom;
}

typedef _DialogColor = ({_DialogColorType type, Color? color});

/// A row that puts a large title text next to another widget - usually an icon,
/// but a constructor for a custom widget is available as well
class TIconText extends StatelessWidget with TStandardColorer {
  /// The text that will be displayed next to the icon/widget
  final String text;

  /// The widget that will be displayed next to the text - null means we'll use
  /// an icon instead
  final Widget? widget;

  /// The icon to use
  final IconData? icon;

  /// The icon's color to use
  final _DialogColor _iconColor;

  const TIconText({
    required this.text,
    this.icon,
    Color? iconColor,
    super.key,
  }) :
    widget = null,
    _iconColor = (type: _DialogColorType.custom, color: iconColor);

  /// Construct this with a green check_circle icon
  const TIconText.success(this.text, {IconData? iconOverride, super.key}) :
    icon = iconOverride ?? Icons.check_circle,
    _iconColor = (type: _DialogColorType.success, color: null),
    widget = null;

  /// Construct this with a red cancel icon
  const TIconText.error(this.text, {IconData? iconOverride, super.key}) :
    icon = iconOverride ?? Icons.cancel,
    _iconColor = (type: _DialogColorType.error, color: null),
    widget = null;

  /// Construct this with a custom widget instead of an icon
  const TIconText.widget({
    required this.text,
    required this.widget,
    super.key,
  }) : icon = null, _iconColor = (type: _DialogColorType.error, color: null);

  /// Construct this with a CircularProgressIndicator instead of an icon
  const TIconText.loading(String text, {Key? key}) :
    this.widget(
      text: text,
      widget: const CircularProgressIndicator(),
      key: key,
    );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget != null || icon != null)
          Flexible(
            flex: 0,
            child: widget ?? Icon(
              icon,
              size: 30,
              color: switch (_iconColor.type) {
                _DialogColorType.custom => _iconColor.color,
                _DialogColorType.error => errorColor(context),
                _DialogColorType.success => successColor(context),
              },
            ),
          ),
        Flexible(
          child: SelectableText(
            text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ].separateWith(const SizedBox(width: 10)),
    );
  }
}
