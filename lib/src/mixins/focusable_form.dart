import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/form/base.dart';

/// A mixin for a [TFormState] that marks the implementing class as having
/// a focusable text input.
///
/// Implementers acquire a [focusNode] member that can be bound to text inputs,
/// and a [requestFocus] method that allows external states to request focus on
/// the internal [FocusNode]. The [focusNode] is automatically disposed when the
/// state is disposed.
mixin FocusableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  /// The focus node associated with the text form
  FocusNode get focusNode;

  /// Requests focus on the text input
  void requestFocus() => focusNode.requestFocus();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
