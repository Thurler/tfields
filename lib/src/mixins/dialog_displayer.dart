import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tfields/src/logger.dart';
import 'package:tfields/src/mixins/loggable.dart';
import 'package:tfields/src/widgets/dialog.dart';
import 'package:tfields/src/widgets/icons.dart';

/// A mixin to handle the boilerplate of displaying a dialog in a stateful
/// widget, implementing some helper methods to handle common actions like
/// confirming a deletion on handling a request's possible response states
mixin TDialogDisplayer<T extends StatefulWidget> on State<T> {
  /// Show a simple success dialog, if the widget is still mounted
  Future<void> showSuccess(String message, {String? body}) async {
    if (mounted) {
      return TDialog.success(title: message, body: body).show(context);
    }
  }

  /// Show a simple warning dialog, if the widget is still mounted
  Future<void> showWarning(String message, {String? body}) async {
    if (mounted) {
      return TDialog.warning(title: message, body: body).show(context);
    }
  }

  /// Show a simple loading dialog, if the widget is still mounted
  Future<void> showLoading(String message, {String? body}) async {
    if (mounted) {
      return TDialog.loading(title: message, body: body).show(context);
    }
  }

  /// Show a simple warning dialog, and optionally log a message if this is an
  /// instance of Loggable
  Future<void> showException(
    String message, {
    String? body,
    String? logMessage,
  }) async {
    if (this is TLoggable && (logMessage?.isNotEmpty ?? false)) {
      await (this as TLoggable).log(TLogLevel.error, logMessage);
    }
    return showWarning(message, body: body);
  }

  /// Same as the above function, except a generic message is displayed, logging
  /// the exception and stack trace of the unexpected exception
  Future<void> showUnexpectedException(
    Object e,
    StackTrace s, {
    required String body,
  }) async {
    return showException(
      'An unexpected error occured!',
      logMessage: 'Unknown exception: $e | $s',
      body: body,
    );
  }

  /// Show a simple confirm dialog, if the widget is still mounted
  Future<bool> showConfirmation(
    String message, {
    String? title,
    String? confirmText,
    String? cancelText,
  }) async {
    if (mounted) {
      return TDialog.warningChoice(
        fixedBodyWidth: 500,
        title: title ?? 'Warning!',
        body: message,
        confirmText: confirmText ?? 'OK',
        cancelText: cancelText ?? 'Cancel',
      ).showBool(context);
    } else {
      return false;
    }
  }

  /// Show a simple delete confirm dialog, if the widget is still mounted
  Future<bool> showDeleteConfirm(
    String message, {
    String? title,
    String? confirmText,
    String? cancelText,
  }) async {
    if (mounted) {
      return TDialog.warningChoice(
        fixedBodyWidth: 500,
        title: title ?? 'Warning!',
        body: message,
        confirmText: confirmText ?? 'Delete',
        cancelText: cancelText ?? 'Cancel',
        confirmIconOverride: TPresetIcon.delete.icon,
      ).showBool(context);
    } else {
      return false;
    }
  }

  /// Dismisses any dialog currently being rendered
  void dismissDialog() {
    Navigator.of(context, rootNavigator: true).popUntil(
      (Route<dynamic> route) => route is! DialogRoute,
    );
  }
}
