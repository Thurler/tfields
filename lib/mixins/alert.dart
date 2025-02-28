import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/widgets/dialog.dart';

/// Mixing this into a State allows that State to call the helper AlertDialog
/// functions, which standardize the way alerts are displayed in views
mixin AlertHandler<T extends StatefulWidget> on Loggable, State<T> {
  /// Show a dialog that doesn't return anything, just presents an information
  ///
  /// The Future completes when the dialog is dismissed
  Future<void> showCommonDialog(TDialog dialog) => showDialog<void>(
    context: context,
    builder: (BuildContext context) => dialog,
  );

  /// Show a dialog that returns a boolean value. A confirm/cancel button is
  /// displayed to the user, and a TRUE value is returned if and only if the
  /// user clicked on the confirm button
  ///
  /// Clicking on the cancel button OR dismissing the dialogue will make this
  /// return FALSE
  ///
  /// The Future completes when the dialog is dismissed
  Future<bool> showBoolDialog(TDialog dialog) async {
    bool? canDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => dialog,
    );
    return canDiscard ?? false;
  }

  /// Logs a known exception and shows a dialog to the user, informing them of
  /// what happened
  Future<void> handleException({
    required String logMessage,
    required String dialogTitle,
    required String dialogBody,
  }) async {
    await log(LogLevel.error, logMessage);
    await showCommonDialog(
      TDialog.warning(
        titleText: dialogTitle,
        bodyText: dialogBody,
        confirmText: 'OK',
      ),
    );
  }

  /// Logs an unhandled exception and shows a dialog to the user, informing them
  /// of what happened
  Future<void> handleUnexpectedException(
    Exception e,
    StackTrace s, {
    required String dialogBody,
  }) {
    return handleException(
      logMessage: 'Unknown exception: $e | $s',
      dialogTitle: 'An unexpected error occured!',
      dialogBody: dialogBody,
    );
  }
}
