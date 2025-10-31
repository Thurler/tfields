import 'package:flutter/material.dart';
import 'package:tfields/src/buttons/elevated.dart';
import 'package:tfields/src/buttons/icon_and_label.dart';
import 'package:tfields/src/buttons/icon_only.dart';
import 'package:tfields/widgets/icons.dart';

/// A common interface for all kinds of Button widgets
///
/// It is declared as abstract to force callers to use one of the provided
/// builders that have different designs, which are more feature-complete than
/// a generic interface. The current implementations are:
///
/// - `iconOnly`: the button is rendered as a lone icon, optionally with a
/// rounded border and a tooltip
/// - `iconAndLabel`: the button is rendered as an icon followed by a small text
/// - `elevated`: the button is rendered as an elevated button, with the text
/// optionally being accompanied by an icon
///
/// All rendering modes have presets for using common icons in the PresetIcon
/// enum, and can be invoked as an extension of the builder:
///
/// - `TButton.iconOnly()` gives you full control over the icon
/// - `TButton.iconOnly.delete()` will use the preset delete icon
abstract class TButton extends StatelessWidget {
  final TIconInterface? icon;
  final String? text;
  final void Function()? onPressed;
  final bool forceDefaultIconColor;

  static TButtonIconOnlyBuilder get iconOnly => const TButtonIconOnlyBuilder();

  static TButtonIconAndLabelBuilder get iconAndLabel =>
      const TButtonIconAndLabelBuilder();

  static TButtonElevatedBuilder get elevated => const TButtonElevatedBuilder();

  Color? get colorLight =>
      forceDefaultIconColor || icon == null ? null : icon!.colorLight;

  Color? get colorDark =>
      forceDefaultIconColor || icon == null ? null : icon!.colorDark;

  Color? colorFromContext(BuildContext context) =>
      switch (Theme.of(context).brightness) {
    Brightness.light => colorLight,
    Brightness.dark => colorDark,
  };

  const TButton({
    this.icon,
    this.text,
    this.onPressed,
    this.forceDefaultIconColor = false,
    super.key,
  });
}
