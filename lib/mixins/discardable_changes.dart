import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/widgets/dialog.dart';
import 'package:tfields/widgets/save_button.dart';

/// Mixing this into a State allows that State to automatically prompt the user
/// if they want to discard the changes they have made to the State before
/// navigating away from it. This is displayed as a boolean dialog, so mixing
/// AlertHandler is also required
///
/// A State mixed with this will require implementations for a hasChanges and a
/// saveChanges function, which will easily inform the state if there are
/// changes that would be lost on a Navigator pop, and a way to commit them
///
/// Is usually paired with a PopScope being the top level widget in the build
/// function, mapping !hasChanges to the canPop argument, and mapping
/// onPopInvoked to the onPopInvokedWithResult argument
///
/// The State is STILL responsible for properly handling the changes!
mixin DiscardableChanges<T extends StatefulWidget>
    on Loggable, AlertHandler<T> {
  /// Whether the user forced a pop, will skip the dialog check
  bool _forcedPop = false;

  /// Getter that returns whether there are changes in the state
  bool get hasChanges;

  /// Async function that will save the changes in the state, so that calling
  /// the hasChanges getter after this function will return FALSE
  Future<void> saveChanges();

  /// A TSaveButton wrapped as a FloatingActionButton for Scaffolds that want to
  /// easily add this mixin's functionality into their build
  FloatingActionButton? get saveButton {
    return hasChanges ? TSaveButton(onPressed: saveChanges) : null;
  }

  /// Shows the unsaved changes dialog to the user, returning whether it was
  /// accepted or dismissed
  Future<bool> _showUnsavedChangesDialog() {
    return showBoolDialog(
      TDialog.boolWarning(
        titleText: 'Você tem alterações não salvas!',
        bodyText: 'Tem certeza que deseja voltar e descartar suas alterações?',
        confirmText: 'Sim, pode descartar',
        cancelText: 'Não, permanecer aqui',
      ),
    );
  }

  /// The function invoked when pop is called in the Navigator. If there are no
  /// changes OR the user has forced a pop, will turn without doing anything.
  /// Otherwise, it displays the unsaved changes dialog, and if accepted, will
  /// call the Navigator pop
  Future<void> promptUnsavedChanges() async {
    if (!hasChanges || _forcedPop) {
      return;
    }
    NavigatorState state = Navigator.of(context);
    bool canDiscard = await _showUnsavedChangesDialog();
    if (canDiscard) {
      await log(LogLevel.info, 'Discarding changes');
      if (state.mounted) {
        _forcedPop = true;
        Navigator.of(context).pop();
      }
    }
  }

  /// Forces a Navigation pop, setting response as the pop return value
  void popWithoutPrompt(dynamic response) {
    _forcedPop = true;
    Navigator.of(context).pop(response);
  }

  /// A synchronous map to a prompUnsavedChanges unawaited call
  void onPopInvoked(_, __) => unawaited(promptUnsavedChanges());
}
