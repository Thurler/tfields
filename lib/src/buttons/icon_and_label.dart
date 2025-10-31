import 'package:flutter/material.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/icons.dart';

/// A builder redirector to the constructors of _TButtonIconAndLabel. It is
/// callable directly to use the normal constructor, and presets are available
/// according to the TPresetIcon enum:
///
/// `TButton.iconAndLabel()` calls the regular constructor
/// `TButton.iconAndLabel.delete()` calls the preset icon constructor with
/// the delete icon
class TButtonIconAndLabelBuilder {
  const TButtonIconAndLabelBuilder();

  TButton call({
    required TIconInterface icon,
    required String text,
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel(
      icon: icon,
      onPressed: onPressed,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      text: text,
      key: key,
    );
  }

  TButton download({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.download,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton upload({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.upload,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton filter({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.filter,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton play({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.play,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton pause({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.pause,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton close({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.close,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton cancel({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.cancel,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton save({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.save,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton delete({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.delete,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton add({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.add,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  TButton edit({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.edit,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }
}

class _TButtonIconAndLabel extends TButton {
  final IconAlignment iconAlignment;

  const _TButtonIconAndLabel({
    required TIconInterface super.icon,
    required String super.text,
    this.iconAlignment = IconAlignment.start,
    super.onPressed,
    super.forceDefaultIconColor,
    super.key,
  }) : super();

  _TButtonIconAndLabel.fromPreset({
    required TPresetIcon super.icon,
    this.iconAlignment = IconAlignment.start,
    String? textOverride,
    super.onPressed,
    super.forceDefaultIconColor,
    super.key,
  }) : super(text: textOverride ?? icon.text);

  @override
  Widget build(BuildContext context) {
    Color? color = colorFromContext(context);
    return TextButton.icon(
      iconAlignment: iconAlignment,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(14)),
        backgroundColor:
            color == null ? null : WidgetStateProperty.all<Color>(color),
        foregroundColor: WidgetStateProperty.all<Color>(
          color == null ? Theme.of(context).colorScheme.primary : Colors.white,
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon!.icon),
      label: Text(text!),
    );
  }
}
