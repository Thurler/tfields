import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/src/extensions/double.dart';
import 'package:tfields/src/extensions/int.dart';
import 'package:tfields/src/input_formatters/number.dart';
import 'package:tfields/src/mixins/focusable_form.dart';
import 'package:tfields/src/mixins/icon_updateable_form.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/input_decoration.dart';

/// Shorthands for all kinds of Number Form's state

typedef TIntegerFormKey = GlobalKey<TFormNumberState<int, TFormInteger>>;
typedef TDoubleFormKey = GlobalKey<TFormNumberState<double, TFormDouble>>;
typedef TBigIntegerFormKey
    = GlobalKey<TFormNumberState<BigInt, TFormBigInteger>>;

/// A typedef for the function that builds the NumberInputFormatter for a given
/// number type I. Accounts for min and max values, as well as comma separation
/// and snapping to min value in case of empty value
typedef TFormatterBuildFunction<I> = TNumberInputFormatter<dynamic> Function({
  I? minValue,
  I? maxValue,
  bool commaSeparate,
  bool snapToMinOnEmpty,
  bool snapToMaxWhenOver,
});

/// A wrapper around TForm that sets the common attributes that all number
/// forms share:
///
/// - Optional min and max values
/// - Whether the value must be signed or unsigned
/// - Whether to snap the input to the min value when empty
/// - Whether to comma separate the values (`1234567` becomes `1,234,567`)
/// - How to mask the user input to only allow certain characters
abstract class TFormNumber<I> extends TForm<I> {
  /// The minimum value accepted by this input. Will snap to this value if a
  /// smaller value is entered
  final I? minValue;

  /// The maximum value accepted by this input. Will snap to this value if a
  /// bigger value is entered
  final I? maxValue;

  /// Function to parse string input to target number type
  final I? Function(String) tryParse;

  /// Whether the value must be unsigned or not
  final bool userUnsigned;

  /// Whether the minimum value will be snapped to when the input is empty
  final bool snapToMinOnEmpty;

  /// Whether the maximum value will be snapped to when the input exceeds it
  final bool snapToMaxWhenOver;

  /// Whether to comma separate values larger than 999
  final bool commaSeparate;

  /// The function that builds the text formatting, to be used when any state
  /// is changed
  final TFormatterBuildFunction<I> formatterConstructor;

  /// A callback that will be called whenever the user hits the "Enter" key
  final void Function()? submitCallback;

  const TFormNumber({
    required super.enabled,
    required super.title,
    required super.initialValue,
    required bool unsigned,
    required this.formatterConstructor,
    required this.tryParse,
    this.submitCallback,
    this.minValue,
    this.maxValue,
    this.snapToMinOnEmpty = false,
    this.snapToMaxWhenOver = false,
    this.commaSeparate = false,
    super.readonly,
    super.subtitle,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) : userUnsigned = unsigned;

  @override
  TFormNumberState<I, TFormNumber<I>> createState();

  /// Whether this number type allows the dot character ('.') in its string form
  bool get allowsDotCharacter;

  /// Makes a regex for which characters are valid on a number input, based on
  /// the type that is being checked and whether the value is unsigned or not
  ///
  /// For example, will return `[-.\d]` for signed double values, to allow
  /// negatives(`-`) and floating point (`.`) digits (`\d`)
  FilteringTextInputFormatter makeNumberRegex(I? minValue) {
    bool signed = minValue != null
      ? switch (minValue) {
          int() => minValue < 0,
          double() => minValue < 0,
          BigInt() => minValue < BigInt.zero,
          _ => !userUnsigned,
        }
      : !userUnsigned;
    return FilteringTextInputFormatter.allow(
      RegExp('[${signed ? '-' : ''}${allowsDotCharacter ? '.' : ''}\\d]'),
    );
  }
}

/// A realization of the TFormNumber class for ints
class TFormInteger extends TFormNumber<int> {
  const TFormInteger({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.unsigned = true,
    super.submitCallback,
    super.minValue,
    super.maxValue,
    super.snapToMinOnEmpty,
    super.snapToMaxWhenOver,
    super.commaSeparate,
    super.readonly,
    super.subtitle,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.errorMessage,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) : super(
    tryParse: int.tryParse,
    formatterConstructor: TIntInputFormatter.new,
  );

  @override
  TFormNumberState<int, TFormInteger> createState() =>
      TFormNumberState<int, TFormInteger>();

  @override
  bool get allowsDotCharacter => false;
}

/// A realization of the TFormNumber class for BigInts
class TFormBigInteger extends TFormNumber<BigInt> {
  const TFormBigInteger({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.unsigned = true,
    super.submitCallback,
    super.minValue,
    super.maxValue,
    super.snapToMinOnEmpty,
    super.snapToMaxWhenOver,
    super.commaSeparate,
    super.readonly,
    super.subtitle,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.errorMessage,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) : super(
    tryParse: BigInt.tryParse,
    formatterConstructor: TBigIntInputFormatter.new,
  );

  @override
  TFormNumberState<BigInt, TFormBigInteger> createState() =>
      TFormNumberState<BigInt, TFormBigInteger>();

  @override
  bool get allowsDotCharacter => false;
}

/// A realization of the TFormNumber class for doubles
class TFormDouble extends TFormNumber<double> {
  const TFormDouble({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.unsigned = true,
    super.submitCallback,
    super.minValue,
    super.maxValue,
    super.snapToMinOnEmpty,
    super.snapToMaxWhenOver,
    super.commaSeparate,
    super.readonly,
    super.subtitle,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.errorMessage,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) : super(
    tryParse: double.tryParse,
    formatterConstructor: TDoubleInputFormatter.new,
  );

  @override
  TFormNumberState<double, TFormDouble> createState() =>
      TFormNumberState<double, TFormDouble>();

  @override
  bool get allowsDotCharacter => true;
}

/// The state that controls the additional functionality added by
/// TFormNumber
class TFormNumberState<I, T extends TFormNumber<I>>
    extends IconUpdateableTFormState<I, T> with FocusableForm<I, T> {
  /// The controller that the user will interact with
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  FocusNode get focusNode => _focusNode;

  /// The formatters that are currently being applied to the
  /// TextEditingController
  List<TextInputFormatter> get _formatters => <TextInputFormatter>[
    widget.makeNumberRegex(minValue),
    widget.formatterConstructor(
      minValue: minValue,
      maxValue: maxValue,
      commaSeparate: widget.commaSeparate,
      snapToMinOnEmpty: widget.snapToMinOnEmpty,
      snapToMaxWhenOver: widget.snapToMaxWhenOver,
    ),
  ];

  String _commaSeparate(I? value) => widget.commaSeparate
    ? switch (value) {
        int() => value.commaSeparate(),
        double() => value.commaSeparate(),
        BigInt() => value.commaSeparate(),
        _ => '',
      }
    : value?.toString() ?? '';

  @override
  set value(I? newValue) {
    // We override the value setter to make sure we copy the value into the
    // controller, mirroring the internal state with the controller
    _controller.text = _commaSeparate(newValue);
    super.value = newValue;
  }

  bool _hasSetMinValue = false;
  bool _hasSetMaxValue = false;
  I? _minValue;
  I? _maxValue;

  /// The current min value associated with the input. When this value is
  /// updated, it will update the formatters with the new limits, to ensure
  /// consistent behavior with the min/max snaps
  I? get minValue => _hasSetMinValue ? _minValue : widget.minValue;
  set minValue(I? newValue) {
    setState(() {
      _minValue = newValue;
      _hasSetMinValue = true;
    });
  }

  /// The current max value associated with the input. When this value is
  /// updated, it will update the formatters with the new limits, to ensure
  /// consistent behavior with the min/max snaps
  I? get maxValue => _hasSetMaxValue ? _maxValue : widget.maxValue;
  set maxValue(I? newValue) {
    setState(() {
      _maxValue = newValue;
      _hasSetMaxValue = true;
    });
  }

  @override
  void validate() {
    // If value and minValue are defined and value is less than minValue, we
    // force a validation error
    if (value != null && minValue != null) {
      bool belowMin = switch (value) {
        int() => (value! as int) < (minValue! as int),
        double() => (value! as double) < (minValue! as double),
        BigInt() => (value! as BigInt) < (minValue! as BigInt),
        _ => false,
      };
      if (belowMin) {
        setState(() {
          errorMessage = 'Value must be at least ${_commaSeparate(minValue)}';
        });
        return;
      }
    }
    // If value and maxValue are defined and value is more than maxValue, we
    // force a validation error
    if (value != null && maxValue != null) {
      bool aboveMax = switch (value) {
        int() => (value! as num) > (maxValue! as num),
        double() => (value! as num) > (maxValue! as num),
        BigInt() => (value! as BigInt) > (maxValue! as BigInt),
        _ => false,
      };
      if (aboveMax) {
        setState(() {
          errorMessage = 'Value must be at most ${_commaSeparate(maxValue)}';
        });
        return;
      }
    }
    super.validate();
  }

  @override
  void initState() {
    super.initState();
    // Copy the initial state from the widget
    _controller.text = _commaSeparate(widget.initialValue);
    // Add a listener to the controller's input, so that its changes are
    // propagated to the form's callbacks
    _controller.addListener(() {
      I? newValue = widget.tryParse(_controller.text.split(',').join());
      // We explicitly call super.value here to avoid a recursion with the
      // custom setter above, since that changes the controller's value, which
      // would just call this again infinitely
      super.value = newValue;
      widget.onValueChanged?.call(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      focusNode: focusNode,
      controller: _controller,
      inputFormatters: _formatters,
      onFieldSubmitted: (_) => widget.submitCallback?.call(),
      readOnly: readonly,
      decoration: TInputDecoration(
        enabled: enabled,
        labelText: title,
        helperText: subtitle,
        icon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (_) => errorMessage.isNotEmpty ? errorMessage : null,
    );
  }
}
