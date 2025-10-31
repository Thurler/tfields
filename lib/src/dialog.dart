import 'package:flutter/material.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/icon_text.dart';
import 'package:tfields/widgets/icons.dart';
import 'package:tfields/widgets/width_fraction.dart';

/// A dialog's body, comprising of a simple selectabletext that spans no more
/// than 2/3 of the viewport's width
class TDialogBody extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// Force a specific width (or viewport width fraction) as opposed to letting
  /// it automatically determine the width
  final double? fixedWidth;

  const TDialogBody({required this.text, this.fixedWidth, super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool validFixedWidth =
        fixedWidth != null && fixedWidth! > 0 && fixedWidth! < width;
    return validFixedWidth
      ? TWidthFractionBox(
          fixedWidth: fixedWidth!,
          child: SelectableText(text, textAlign: TextAlign.center),
        )
      : Row(
          children: <Widget>[
            Expanded(child: SelectableText(text, textAlign: TextAlign.center)),
          ],
        );
  }
}

/// A dialog's action button, that will pop the scope once clicked
class TDialogAction extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// The icon to be displayed
  final IconData icon;

  /// The function to be called when pushing the button - it receives the
  /// BuildContext so calling Navigator pop is possible
  final void Function(BuildContext context) onPressed;

  const TDialogAction({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  /// A dialog's confirm buton, comprising of nothing but a text and a callback
  /// that calls Navigator.pop with a TRUE value. The icon can be overriden, but
  /// defaults to check_circle_outlined
  const TDialogAction.confirm({
    required this.text,
    IconData? icon,
    super.key,
  }) : icon = icon ?? Icons.check_circle_outlined, onPressed = popTrue;

  /// A dialog's cancel buton, comprising of nothing but a text and a callback
  /// that calls Navigator.pop with a FALSE value. The icon can be overriden,
  /// but defaults to cancel_outlined
  const TDialogAction.cancel({
    required this.text,
    IconData? icon,
    super.key,
  }) : icon = icon ?? Icons.cancel_outlined, onPressed = popFalse;

  /// Receives a BuildContext to call Navigator pop with TRUE
  static void popTrue(BuildContext context) => Navigator.of(context).pop(true);

  /// Receives a BuildContext to call Navigator pop with FALSE
  static void popFalse(BuildContext context) =>
      Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    return TButton.elevated(
      text: text,
      icon: TIcon(icon: icon),
      onPressed: () => onPressed(context),
    );
  }
}

/// A generic AlertDialog wrapper that receives a DialogTitle, DialogBody, and
/// Confirm/Cancel actions
class TAlertDialog extends StatelessWidget {
  /// The title widget
  final TIconText title;

  /// The body widget
  final TDialogBody? body;

  /// The confirm widget
  final TDialogAction? confirm;

  /// The cancel widget
  final TDialogAction? cancel;

  const TAlertDialog({
    required this.title,
    this.body,
    this.confirm,
    this.cancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool hasAction = confirm != null || cancel != null;
    return AlertDialog(
      title: Center(child: title),
      content: body,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, hasAction ? 18 : 5),
      actions: <Widget>[
        // A wrap helps things line up in case the confirm/cancel texts are too
        // long for 1/3 of the viewport's width
        Wrap(
          runSpacing: 10,
          spacing: 20,
          children: <Widget>[
            if (confirm != null) confirm!,
            if (cancel != null) cancel!,
          ],
        ),
      ],
    );
  }
}
