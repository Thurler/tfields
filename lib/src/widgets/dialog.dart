import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/icon_text.dart';
import 'package:tfields/src/widgets/icons.dart';
import 'package:tfields/src/widgets/width_fraction.dart';

/// A dialog's body, comprising of a simple selectabletext that spans no more
/// than 2/3 of the viewport's width
class _TDialogBody extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// Force a specific width (or viewport width fraction) as opposed to letting
  /// it automatically determine the width
  final double? fixedWidth;

  const _TDialogBody({required this.text, this.fixedWidth});

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
class _TDialogAction extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// The icon to be displayed
  final IconData icon;

  /// The function to be called when pushing the button - it receives the
  /// BuildContext so calling Navigator pop is possible
  final void Function(BuildContext context) onPressed;

  const _TDialogAction({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  /// A dialog's confirm buton, comprising of nothing but a text and a callback
  /// that calls Navigator.pop with a TRUE value. The icon can be overriden, but
  /// defaults to check_circle_outlined
  const _TDialogAction.confirm({required this.text, IconData? icon}) :
    icon = icon ?? Icons.check_circle_outlined,
    onPressed = popTrue;

  /// A dialog's cancel buton, comprising of nothing but a text and a callback
  /// that calls Navigator.pop with a FALSE value. The icon can be overriden,
  /// but defaults to cancel_outlined
  const _TDialogAction.cancel({required this.text, IconData? icon}) :
    icon = icon ?? Icons.cancel_outlined,
    onPressed = popFalse;

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
class _TAlertDialog extends StatelessWidget {
  /// The title widget
  final TIconText title;

  /// The body widget
  final _TDialogBody? body;

  /// The confirm widget
  final _TDialogAction? confirm;

  /// The cancel widget
  final _TDialogAction? cancel;

  const _TAlertDialog({
    required this.title,
    this.body,
    this.confirm,
    this.cancel,
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

/// Standardized dialogs with pre-made constructors to further standardize
/// success and warning messages. A generic constructor is also provided for
/// some control over the widgets that are displayed - if you need a highly
/// customized dialog, just make your own AlertDialog
///
/// Includes a `show` and `showBool` methods, to display the widget in the
/// current context, and return the user's selected value. Can help remove some
/// boilerplate from Flutter's `showDialog` call
class TDialog extends StatelessWidget {
  final _TAlertDialog _dialog;

  /// A generic dialog with full control over the variables
  TDialog.generic({
    required String title,
    IconData? titleIcon,
    Color? titleIconColor,
    String? bodyText,
    String? confirmText,
    IconData? confirmIcon,
    String? cancelText,
    IconData? cancelIcon,
    double? fixedBodyWidth,
    super.key,
  }) : _dialog = _TAlertDialog(
    title: TIconText(
      text: title,
      icon: titleIcon,
      iconColor: titleIconColor,
    ),
    body: bodyText != null
      ? _TDialogBody(text: bodyText, fixedWidth: fixedBodyWidth)
      : null,
    confirm: confirmText != null
      ? _TDialogAction.confirm(text: confirmText, icon: confirmIcon)
      : null,
    cancel: cancelText != null
      ? _TDialogAction.cancel(text: cancelText, icon: cancelIcon)
      : null,
  );

  /// A success dialog with a simple green icon
  TDialog.success({
    required String title,
    String? body,
    IconData? iconOverride,
    double? fixedBodyWidth,
    String? confirmText,
    bool showConfirmAction = false,
    super.key,
  }) : _dialog = _TAlertDialog(
    title: TIconText.success(title),
    body: body != null
      ? _TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
    confirm: showConfirmAction || confirmText != null
      ? _TDialogAction.confirm(
          text: confirmText ?? 'OK',
          icon: iconOverride,
        )
      : null,
  );

  /// A loading dialog with a spinning icon
  TDialog.loading({
    required String title,
    String? body,
    double? fixedBodyWidth,
    super.key,
  }) : _dialog = _TAlertDialog(
    title: TIconText.loading(title),
    body: body != null
      ? _TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
  );

  /// A warning dialog with a simple red icon and some text
  TDialog.warning({
    required String title,
    String? confirmText,
    String? body,
    IconData? iconOverride,
    double? fixedBodyWidth,
    super.key,
  }) : _dialog = _TAlertDialog(
    title: TIconText.error(title, iconOverride: Icons.warning),
    body: body != null
      ? _TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
    confirm: confirmText != null
      ? _TDialogAction.confirm(text: confirmText, icon: iconOverride)
      : null,
  );

  /// A warning dialog with a simple red icon and some text, as well as buttons
  /// to confirm or cancel an action
  TDialog.warningChoice({
    required String title,
    required String confirmText,
    required String cancelText,
    double? fixedBodyWidth,
    String? body,
    IconData? confirmIconOverride,
    IconData? cancelIconOverride,
    super.key,
  }) : _dialog = _TAlertDialog(
    title: TIconText.error(title, iconOverride: Icons.warning),
    body: body != null
      ? _TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
    confirm: _TDialogAction.confirm(
      text: confirmText,
      icon: confirmIconOverride,
    ),
    cancel: _TDialogAction.cancel(
      text: cancelText,
      icon: cancelIconOverride,
    ),
  );

  @override
  Widget build(BuildContext context) => _dialog;

  /// Shows this dialog, without returning user input
  Future<void> show(BuildContext context) =>
      showDialog<void>(context: context, builder: (_) => this);

  /// Shows this dialog, returning user input as a boolean:
  ///
  /// - Clicking on the confirm button returns TRUE
  /// - Anything else returns FALSE
  Future<bool> showBool(BuildContext context) async =>
      (await showDialog<bool>(context: context, builder: (_) => this)) ?? false;
}
