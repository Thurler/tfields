import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/form/base.dart';

/// A mixin for a [TFormState] that allows the implementing class to freely
/// update its decorator icon property. Some forms might not allow for this to
/// be edited, which is why this is implemented as a mixin
mixin DecoratorIconUpdateableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  bool _hasSetDecorator = false;

  Widget? _decoratorIcon;

  Widget? get decoratorIcon =>
      _hasSetDecorator ? _decoratorIcon : widget.decoratorIcon;
  set decoratorIcon(Widget? newValue) => setState(() {
    _decoratorIcon = newValue;
    _hasSetDecorator = true;
  });
}

/// A mixin for a [TFormState] that allows the implementing class to freely
/// update its prefix icon property. Some forms might not allow for this to be
/// edited, which is why this is implemented as a mixin
mixin PrefixIconUpdateableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  bool _hasSetPrefix = false;

  Widget? _prefixIcon;

  Widget? get prefixIcon => _hasSetPrefix ? _prefixIcon : widget.prefixIcon;
  set prefixIcon(Widget? newValue) => setState(() {
    _prefixIcon = newValue;
    _hasSetPrefix = true;
  });
}

/// A mixin for a [TFormState] that allows the implementing class to freely
/// update its suffix icon property. Some forms might not allow for this to be
/// edited, which is why this is implemented as a mixin
mixin SuffixIconUpdateableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  bool _hasSetSuffix = false;

  Widget? _suffixIcon;

  Widget? get suffixIcon => _hasSetSuffix ? _suffixIcon : widget.suffixIcon;
  set suffixIcon(Widget? newValue) => setState(() {
    _suffixIcon = newValue;
    _hasSetSuffix = true;
  });
}

/// A layer on top of [TFormState] that already applies all mixins that give
/// icon updating properties: [DecoratorIconUpdateableForm],
/// [PrefixIconUpdateableForm] and [SuffixIconUpdateableForm]
abstract class IconUpdateableTFormState<Value, AForm extends TForm<Value>>
    extends TFormState<Value, AForm>
    with
        DecoratorIconUpdateableForm<Value, AForm>,
        PrefixIconUpdateableForm<Value, AForm>,
        SuffixIconUpdateableForm<Value, AForm> {}
