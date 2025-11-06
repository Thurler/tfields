import 'package:flutter/material.dart';

/// A simple wrapper around InputDecoration to standardize error and helper text
/// line count and border style
class TInputDecoration extends InputDecoration {
  const TInputDecoration({
    super.enabled,
    super.labelText,
    super.helperText,
    super.errorText,
    super.hintText,
    super.prefixIcon,
    super.suffixIcon,
    super.isDense,
    super.icon,
  }) : super(
    // We don't really want to limit the number of lines, but passing in "null"
    // forces them to be 1, so we need a large number...
    errorMaxLines: 999,
    helperMaxLines: 999,
    border: const OutlineInputBorder(),
  );
}
