import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/circular_progress_icon.dart';
import 'package:tfields/widgets/icons.dart';

/// A builder redirector to the constructors of _TButtonElevated. It is
/// callable directly to use the normal constructor, and presets are available
/// according to the TPresetIcon enum:
///
/// `TButton.elevated()` calls the regular constructor
/// `TButton.elevated.delete()` calls the preset icon constructor with
/// the delete icon
class TButtonElevatedBuilder {
  const TButtonElevatedBuilder();

  TButton call({
    required String text,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TIconInterface? icon,
    TextStyle? textStyle,
    Widget? iconOverride,
    Key? key,
  }) {
    return _TButtonElevated(
      icon: icon,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      iconOverride: iconOverride,
      textStyle: textStyle,
      text: text,
      key: key,
    );
  }

  /// A shorthand for an elevated form submit button, that automatically
  /// disables itself and changes text when submitting. It will also standardize
  /// the icons used for submitting and loading
  TButton formSubmit({
    required String saveText,
    required String savingText,
    required bool saving,
    required void Function()? onSubmit,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.formSubmit(
      saveText: saveText,
      savingText: savingText,
      saving: saving,
      onSubmit: onSubmit,
      iconAlignment: iconAlignment,
      usesMaxWidth: usesMaxWidth,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton download({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.download,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton upload({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.upload,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton filter({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.filter,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton play({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.play,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton pause({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.pause,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton close({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.close,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton cancel({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.cancel,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton save({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.save,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton delete({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.delete,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton add({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.add,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  TButton edit({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.edit,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }
}

class _TButtonElevated extends TButton {
  final bool usesMaxWidth;
  final Widget? iconOverride;
  final TextStyle? textStyle;
  final IconAlignment iconAlignment;

  const _TButtonElevated({
    required String super.text,
    this.iconAlignment = IconAlignment.start,
    this.usesMaxWidth = false,
    this.iconOverride,
    this.textStyle,
    super.onPressed,
    super.icon,
    super.key,
  }) : super();

  const _TButtonElevated.formSubmit({
    required String saveText,
    required String savingText,
    required bool saving,
    required void Function()? onSubmit,
    this.iconAlignment = IconAlignment.start,
    this.usesMaxWidth = false,
    this.textStyle,
    super.key,
  }) :
    iconOverride = saving ? const TCircularProgressIcon(strokeWidth: 3) : null,
    super(
      onPressed: saving ? null : onSubmit,
      text: saving ? savingText : saveText,
      icon: saving ? null : const TIcon(icon: Icons.check_circle),
    );

  _TButtonElevated.fromPreset({
    required TPresetIcon super.icon,
    this.iconAlignment = IconAlignment.start,
    this.usesMaxWidth = false,
    this.textStyle,
    String? textOverride,
    super.onPressed,
    super.key,
  }) : iconOverride = null, super(text: textOverride ?? icon.text);

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget =
        iconOverride ?? (icon != null ? Icon(icon!.icon) : null);
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: usesMaxWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (iconAlignment == IconAlignment.start && iconWidget != null)
              iconWidget,
            Flexible(
              child: Text(
                text!,
                style: textStyle ?? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (iconAlignment == IconAlignment.end && iconWidget != null)
              iconWidget,
          ].separateWith(const SizedBox(width: 10)),
        ),
      ),
    );
  }
}
