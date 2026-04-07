import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/form/base.dart';

/// A mixin for a [TFormState] that allows the implementing class to freely
/// update its decorator icon property. Some forms might not allow for this to
/// be edited, which is why this is implemented as a mixin
mixin DecoratorIconUpdateableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  Widget? _decoratorIcon;

  Widget? get decoratorIcon => _decoratorIcon;
  set decoratorIcon(Widget? newValue) => setState(() {
    _decoratorIcon = newValue;
  });

  @override
  void initState() {
    super.initState();
    _decoratorIcon = widget.decoratorIcon;
  }
}

/// A mixin for a [TFormState] that allows the implementing class to freely
/// update its prefix icon property. Some forms might not allow for this to be
/// edited, which is why this is implemented as a mixin
mixin PrefixIconUpdateableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  Widget? _prefixIcon;

  Widget? get prefixIcon => _prefixIcon;
  set prefixIcon(Widget? newValue) => setState(() {
    _prefixIcon = newValue;
  });

  @override
  void initState() {
    super.initState();
    _prefixIcon = widget.prefixIcon;
  }
}

/// A mixin for a [TFormState] that allows the implementing class to freely
/// update its suffix icon property. Some forms might not allow for this to be
/// edited, which is why this is implemented as a mixin
mixin SuffixIconUpdateableForm<Value, AForm extends TForm<Value>>
    on TFormState<Value, AForm> {
  Widget? _suffixIcon;

  Widget? get suffixIcon => _suffixIcon;
  set suffixIcon(Widget? newValue) => setState(() {
    _suffixIcon = newValue;
  });

  @override
  void initState() {
    super.initState();
    _suffixIcon = widget.suffixIcon;
  }
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
