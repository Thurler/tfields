import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/icons.dart';
import 'package:tlinter/annotations.dart';

/// A builder redirector to the constructors of _TButtonIconAndLabel. It is
/// callable directly to use the normal constructor, and presets are available
/// according to the TPresetIcon enum:
///
/// `TButton.iconAndLabel()` calls the regular constructor
/// `TButton.iconAndLabel.delete()` calls the preset icon constructor with
/// the delete icon
@internal
class TButtonIconAndLabelBuilder {
  const TButtonIconAndLabelBuilder();

  /// Creates a button with both an icon and a text label.
  ///
  /// The [icon] parameter specifies which icon to display.
  /// The [text] parameter provides the button's label.
  /// Set [forceDefaultIconColor] to true to use the default icon color instead
  /// of theme-based coloring.
  /// The [iconAlignment] determines whether the icon appears at the start or
  /// end of the button.
  /// The [onPressed] callback is triggered when the button is tapped.
  @TReflect(_TButtonIconAndLabel.new, validateReturnType: false)
  TButton call({
    required TIconInterface icon,
    required String text,
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    void Function()? onPressed,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonIconAndLabel(
      icon: icon,
      onPressed: onPressed,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      text: text,
      key: key,
    );
  }

  /// Creates a download button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default download text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a upload button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default upload text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a filter button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default filter text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a close button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default close text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a cancel button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default cancel text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a save button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default save text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a delete button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default delete text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a add button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default add text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

  /// Creates a refresh button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default refresh text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton refresh({
    bool forceDefaultIconColor = false,
    IconAlignment iconAlignment = IconAlignment.start,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconAndLabel.fromPreset(
      icon: TPresetIcon.refresh,
      forceDefaultIconColor: forceDefaultIconColor,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
      textOverride: textOverride,
      key: key,
    );
  }

  /// Creates a edit button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default edit text.
  @TReflect(
    _TButtonIconAndLabel.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
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

/// Internal implementation of a button with both icon and text label.
///
/// This widget displays a TextButton with an icon and label. The icon position
/// can be customized via [iconAlignment]. The button supports theme-based
/// coloring and will use a colored background if a color is determined from
/// the context.
class _TButtonIconAndLabel extends TButton {
  /// Determines whether the icon is positioned at the start or end of the label
  final IconAlignment iconAlignment;

  /// The style that will be applied to the text rendered inside the label
  final TextStyle? textStyle;

  const _TButtonIconAndLabel({
    required TIconInterface super.icon,
    required String super.text,
    this.iconAlignment = IconAlignment.start,
    this.textStyle,
    super.onPressed,
    super.forceDefaultIconColor,
    super.key,
  }) : super();

  /// Creates a button with icon and label from a preset icon.
  ///
  /// Uses the default text from the [TPresetIcon] unless [textOverride] is
  /// provided.
  _TButtonIconAndLabel.fromPreset({
    required TPresetIcon super.icon,
    this.iconAlignment = IconAlignment.start,
    String? textOverride,
    super.onPressed,
    super.forceDefaultIconColor,
    super.key,
  }) : textStyle = null, super(text: textOverride ?? icon.text);

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
          color == null
            ? Theme.of(context).colorScheme.primary
            : (textStyle?.color ?? Colors.white),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon!.icon),
      label: Text(text!, style: textStyle),
    );
  }
}
