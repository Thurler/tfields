import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/input_formatters/number.dart';
import 'package:tfields/widgets/form/string.dart';

FilteringTextInputFormatter _makeNumberRegex(
  dynamic minValue,
  dynamic maxValue, {
  required bool userUnsigned,
}) {
  Type type = minValue != null ? minValue.runtimeType : maxValue.runtimeType;
  bool signed = switch (type) {
    const (int) => minValue as int < 0,
    const (double) => minValue as double < 0,
    const (BigInt) => minValue as BigInt < BigInt.zero,
    _ => !userUnsigned,
  };
  bool allowDot = minValue is double;
  return FilteringTextInputFormatter.allow(
    RegExp('[${signed ? '-' : ''}${allowDot ? '.' : ''}\\d]'),
  );
}

typedef FormatterBuildFunction<I> = NumberInputFormatter<dynamic> Function({
  I? minValue,
  I? maxValue,
  bool commaSeparate,
});

abstract class TFormNumber<I> extends TFormString {
  final I? minValue;
  final I? maxValue;
  final bool userUnsigned;
  final bool commaSeparate;
  final FilteringTextInputFormatter maskFormatter;
  final FormatterBuildFunction<I> formatterConstructor;

  TFormNumber({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    required this.userUnsigned,
    required this.formatterConstructor,
    required this.maskFormatter,
    this.minValue,
    this.maxValue,
    this.commaSeparate = false,
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(
    formatters: <TextInputFormatter>[
      maskFormatter,
      formatterConstructor(
        minValue: minValue,
        maxValue: maxValue,
        commaSeparate: commaSeparate,
      ),
    ],
  );
}

class TFormInteger extends TFormNumber<int> {
  TFormInteger({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.userUnsigned = true,
    super.minValue,
    super.maxValue,
    super.commaSeparate,
    super.errorMessage,
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(
    formatterConstructor: IntInputFormatter.new,
    maskFormatter: _makeNumberRegex(
      minValue,
      maxValue,
      userUnsigned: userUnsigned,
    ),
  );

  @override
  State<TFormInteger> createState() => TFormNumberState<int, TFormInteger>();
}

class TFormBigInteger extends TFormNumber<BigInt> {
  TFormBigInteger({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.userUnsigned = true,
    super.minValue,
    super.maxValue,
    super.commaSeparate,
    super.errorMessage,
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(
    formatterConstructor: BigIntInputFormatter.new,
    maskFormatter: _makeNumberRegex(
      minValue,
      maxValue,
      userUnsigned: userUnsigned,
    ),
  );

  @override
  State<TFormInteger> createState() => TFormNumberState<int, TFormInteger>();
}

class TFormDoubleInteger extends TFormNumber<double> {
  TFormDoubleInteger({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.userUnsigned = true,
    super.minValue,
    super.maxValue,
    super.commaSeparate,
    super.errorMessage,
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(
    formatterConstructor: DoubleInputFormatter.new,
    maskFormatter: _makeNumberRegex(
      minValue,
      maxValue,
      userUnsigned: userUnsigned,
    ),
  );

  @override
  State<TFormInteger> createState() => TFormNumberState<int, TFormInteger>();
}

class TFormNumberState<I, T extends TFormNumber<I>>
    extends TFormStringState<T> {
  I? _minValue;
  I? _maxValue;

  I? get minValue => _minValue;
  set minValue(I? newValue) {
    _minValue = newValue;
    formatters[0] = _makeNumberRegex(
      minValue,
      maxValue,
      userUnsigned: widget.userUnsigned,
    );
    formatters[1] = widget.formatterConstructor(
      minValue: _minValue,
      maxValue: _maxValue,
      commaSeparate: widget.commaSeparate,
    );
  }

  I? get maxValue => _maxValue;
  set maxValue(I? newValue) {
    _maxValue = newValue;
    formatters[0] = _makeNumberRegex(
      minValue,
      maxValue,
      userUnsigned: widget.userUnsigned,
    );
    formatters[1] = widget.formatterConstructor(
      minValue: _minValue,
      maxValue: _maxValue,
      commaSeparate: widget.commaSeparate,
    );
  }

  @override
  void initState() {
    super.initState();
    minValue = widget.minValue;
    maxValue = widget.maxValue;
  }
}
