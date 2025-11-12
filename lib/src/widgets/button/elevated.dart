import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tfields/src/extensions/iterable.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/circular_progress_icon.dart';
import 'package:tfields/src/widgets/icons.dart';

/// A builder redirector to the constructors of _TButtonElevated. It is
/// callable directly to use the normal constructor, and presets are available
/// according to the TPresetIcon enum:
///
/// `TButton.elevated()` calls the regular constructor
/// `TButton.elevated.delete()` calls the preset icon constructor with
/// the delete icon
@internal
class TButtonElevatedBuilder {
  const TButtonElevatedBuilder();

  /// Creates an elevated button with optional icon and text.
  ///
  /// The [text] parameter provides the button's label (required).
  /// The [icon] parameter specifies an optional icon to display.
  /// Set [usesMaxWidth] to true to make the button expand to fill available
  /// width.
  /// The [iconAlignment] determines whether the icon appears at the start or
  /// end of the button.
  /// The [textStyle] allows customization of the text appearance.
  /// The [iconOverride] can be used to provide a custom widget in place of the
  /// icon (e.g., a loading indicator).
  /// The [onPressed] callback is triggered when the button is tapped.
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

  /// Creates a download elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default download text.
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

  /// Creates a upload elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default upload text.
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

  /// Creates a filter elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default filter text.
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

  /// Creates a close elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default close text.
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

  /// Creates a cancel elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default cancel text.
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

  /// Creates a save elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default save text.
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

  /// Creates a delete elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default delete text.
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

  /// Creates a add elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default add text.
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

  /// Creates a refresh elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default refresh text.
  TButton refresh({
    String? textOverride,
    void Function()? onPressed,
    IconAlignment iconAlignment = IconAlignment.start,
    bool usesMaxWidth = false,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _TButtonElevated.fromPreset(
      icon: TPresetIcon.refresh,
      textOverride: textOverride,
      onPressed: onPressed,
      usesMaxWidth: usesMaxWidth,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      key: key,
    );
  }

  /// Creates a edit elevated button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default edit text.
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

/// Internal implementation of an elevated button widget.
///
/// This widget displays an ElevatedButton with optional icon and customizable
/// text styling. The button can expand to fill available width via
/// [usesMaxWidth]. The icon position can be customized via [iconAlignment].
/// Supports custom icon widgets via [iconOverride], useful for displaying
/// loading indicators or other custom widgets in place of icons.
class _TButtonElevated extends TButton {
  /// Whether the button should expand to fill available width.
  final bool usesMaxWidth;

  /// Custom widget to display in place of the icon (e.g., loading indicator).
  final Widget? iconOverride;

  /// Custom text style for the button label.
  final TextStyle? textStyle;

  /// Determines whether the icon is positioned at the start or end of the label
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

  /// Creates a form submit button that displays loading state.
  ///
  /// When [saving] is true, the button is disabled, displays [savingText], and
  /// shows a loading indicator. When [saving] is false, the button is enabled,
  /// displays [saveText], and shows a check circle icon. This provides a
  /// standard UX pattern for form submission buttons.
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

  /// Creates an elevated button from a preset icon.
  ///
  /// Uses the default text from the [TPresetIcon] unless [textOverride] is
  /// provided.
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
