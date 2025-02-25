import 'package:flutter/material.dart';
import 'package:tfields/widgets/button.dart';

/// A dialog's title, comprising of an icon and a text with bigger font
class TDialogTitle extends StatelessWidget {
  /// The text to be displatyed
  final String text;

  /// The icon to use
  final IconData icon;

  /// The icon's color to use
  final Color iconColor;

  const TDialogTitle({
    required this.text,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

/// A dialog's body, comprising of a simple selectabletext that spans no more
/// than 2/3 of the viewport's width
class TDialogBody extends StatelessWidget {
  /// The text to be displayed
  final String text;

  const TDialogBody({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 2 / 3,
      child: SelectableText(text, textAlign: TextAlign.center),
    );
  }
}

/// A dialog's action, basically a button that will run a function relating to
/// dismissing the dialog when clicked
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
    this.icon = Icons.check_circle_outlined,
    super.key,
  }) : onPressed = popTrue;

  /// A dialog's cancel buton, comprising of nothing but a text and a callback
  /// that calls Navigator.pop with a FALSE value. The icon can be overriden,
  /// but defaults to cancel_outlined
  const TDialogAction.cancel({
    required this.text,
    this.icon = Icons.cancel_outlined,
    super.key,
  }) : onPressed = popFalse;

  /// Receives a BuildContext to call Navigator pop with TRUE
  static void popTrue(BuildContext context) => Navigator.of(context).pop(true);

  /// Receives a BuildContext to call Navigator pop with FALSE
  static void popFalse(BuildContext context) =>
      Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    return TButton(
      text: text,
      icon: icon,
      onPressed: () => onPressed(context),
      usesMaxWidth: false,
      fontSize: 16,
    );
  }
}

/// A generic AlertDialog wrapper that receives a DialogTitle, DialogBody, and
/// Confirm/Cancel actions - provides some constructors to help with common
/// pre-built dialogs
class TDialog extends StatelessWidget {
  /// The title widget
  final TDialogTitle title;

  /// The body widget
  final TDialogBody? body;

  /// The confirm widget
  final TDialogAction? confirm;

  /// The cancel widget
  final TDialogAction? cancel;

  const TDialog({
    required this.title,
    this.body,
    this.confirm,
    this.cancel,
    super.key,
  });

  /// A simple success dialog that displays a title and an OK button
  TDialog.success({
    required String titleText,
    super.key,
  }) :
    body = null,
    cancel = null,
    confirm = const TDialogAction.confirm(text: 'OK'),
    title = TDialogTitle(
      text: titleText,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    );

  /// A simple warning dialog that displays a title, a body and a confirm button
  TDialog.warning({
    required String titleText,
    required String bodyText,
    required String confirmText,
    super.key,
  }) :
    cancel = null,
    body = TDialogBody(text: bodyText),
    confirm = TDialogAction.confirm(text: confirmText),
    title = TDialogTitle(
      text: titleText,
      icon: Icons.warning,
      iconColor: Colors.red,
    );

  /// A warning dialog that displays a title, a body and prompts for a confirm
  /// and a cancel action
  TDialog.boolWarning({
    required String titleText,
    required String bodyText,
    required String confirmText,
    required String cancelText,
    IconData? confirmIcon,
    IconData? cancelIcon,
    super.key,
  }) :
    body = TDialogBody(text: bodyText),
    confirm = TDialogAction.confirm(
      text: confirmText,
      icon: confirmIcon ?? Icons.check_circle_outlined,
    ),
    cancel = TDialogAction.cancel(
      text: cancelText,
      icon: cancelIcon ?? Icons.cancel_outlined,
    ),
    title = TDialogTitle(
      text: titleText,
      icon: Icons.warning,
      iconColor: Colors.red,
    );

  @override
  Widget build(BuildContext context) {
    bool hasAction = confirm != null || cancel != null;
    return AlertDialog(
      title: title,
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
