import 'package:flutter/material.dart';
import 'package:tfields/src/dialog.dart';
import 'package:tfields/widgets/icon_text.dart';

/// Standardized dialogs with pre-made constructors to further standardize
/// success and warning messages. A generic constructor is also provided for
/// some control over the widgets that are displayed - if you need a highly
/// customized dialog, just make your own AlertDialog
///
/// Includes a `show` and `showBool` methods, to display the widget in the
/// current context, and return the user's selected value. Can help remove some
/// boilerplate from Flutter's `showDialog` call
class TDialog extends StatelessWidget {
  final TAlertDialog _dialog;

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
  }) : _dialog = TAlertDialog(
    title: TIconText(
      text: title,
      icon: titleIcon,
      iconColor: titleIconColor,
    ),
    body: bodyText != null
      ? TDialogBody(text: bodyText, fixedWidth: fixedBodyWidth)
      : null,
    confirm: confirmText != null
      ? TDialogAction.confirm(text: confirmText, icon: confirmIcon)
      : null,
    cancel: cancelText != null
      ? TDialogAction.cancel(text: cancelText, icon: cancelIcon)
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
  }) : _dialog = TAlertDialog(
    title: TIconText.success(title),
    body: body != null
      ? TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
    confirm: showConfirmAction || confirmText != null
      ? TDialogAction.confirm(
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
  }) : _dialog = TAlertDialog(
    title: TIconText.loading(title),
    body: body != null
      ? TDialogBody(text: body, fixedWidth: fixedBodyWidth)
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
  }) : _dialog = TAlertDialog(
    title: TIconText.error(title, iconOverride: Icons.warning),
    body: body != null
      ? TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
    confirm: confirmText != null
      ? TDialogAction.confirm(text: confirmText, icon: iconOverride)
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
  }) : _dialog = TAlertDialog(
    title: TIconText.error(title, iconOverride: Icons.warning),
    body: body != null
      ? TDialogBody(text: body, fixedWidth: fixedBodyWidth)
      : null,
    confirm: TDialogAction.confirm(
      text: confirmText,
      icon: confirmIconOverride,
    ),
    cancel: TDialogAction.cancel(
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
