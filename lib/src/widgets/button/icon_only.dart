import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tfields/src/mixins/standard_colorer.dart';
import 'package:tfields/src/widgets/badge.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/icons.dart';
import 'package:tlinter/annotations.dart';

/// A builder redirector to the constructors of _TButtonIconOnly. It is
/// callable directly to use the normal constructor, and presets are available
/// according to the TPresetIcon enum:
///
/// `TButton.iconOnly()` calls the regular constructor
/// `TButton.iconOnly.delete()` calls the preset icon constructor with
/// the delete icon
@internal
class TButtonIconOnlyBuilder {
  const TButtonIconOnlyBuilder();

  /// Creates an icon-only button with a custom icon.
  ///
  /// The [icon] parameter specifies which icon to display.
  /// Set [forceDefaultIconColor] to true to use the default icon color instead
  /// of theme-based coloring.
  /// Set [showBorder] to true to display a circular border around the button.
  /// The [onPressed] callback is triggered when the button is tapped.
  /// The [text] parameter provides a tooltip for the button.
  /// The [badge] parameter adds a notification badge to the icon.
  @TReflect(_TButtonIconOnly.new, validateReturnType: false)
  TButton call({
    required TIconInterface icon,
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    void Function()? onPressed,
    String? text,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly(
      icon: icon,
      onPressed: onPressed,
      forceDefaultIconColor: forceDefaultIconColor,
      text: text,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a download icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default download text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton download({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.download,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a upload icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default upload text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton upload({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.upload,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a filter icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default filter text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton filter({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.filter,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a close icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default close text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton close({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.close,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a cancel icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default cancel text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton cancel({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.cancel,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a save icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default save text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton save({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.save,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a delete icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default delete text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton delete({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.delete,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a add icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default add text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton add({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.add,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a edit icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default edit text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton edit({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.edit,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }

  /// Creates a refresh icon button with preset icon and default text.
  ///
  /// See [call] for parameter descriptions. The [textOverride] parameter can be
  /// used to override the default refresh text.
  @TReflect(
    _TButtonIconOnly.fromPreset,
    ignoreNamedArguments: <String>{'icon'},
    validateReturnType: false,
  )
  TButton refresh({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    TIconBadge? badge,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.refresh,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      badge: badge,
      key: key,
    );
  }
}

/// Internal implementation of an icon-only button widget.
///
/// This widget displays a circular icon button with optional border and badge.
/// It uses [TStandardColorer] mixin to apply consistent coloring based on
/// context. The button is customized with hover, highlight, and splash alpha
/// colors when a border is shown.
class _TButtonIconOnly extends TButton with TStandardColorer {
  /// Alpha value for hover state (30% opacity).
  static final int hoverAlpha = (255 * 0.3).toInt();

  /// Alpha value for highlight state (30% opacity).
  static final int highlightAlpha = (255 * 0.3).toInt();

  /// Alpha value for splash effect (30% opacity).
  static final int splashAlpha = (255 * 0.3).toInt();

  /// Whether to display a circular border around the button.
  final bool showBorder;

  /// Optional badge to display on the icon (e.g., notification count).
  final TIconBadge? badge;

  const _TButtonIconOnly({
    required TIconInterface super.icon,
    this.showBorder = false,
    super.onPressed,
    super.forceDefaultIconColor,
    super.text,
    this.badge,
    super.key,
  }) : super();

  /// Creates an icon-only button from a preset icon.
  ///
  /// Uses the default text from the [TPresetIcon] unless [textOverride] is
  /// provided.
  _TButtonIconOnly.fromPreset({
    required TPresetIcon super.icon,
    String? textOverride,
    this.showBorder = false,
    super.onPressed,
    super.forceDefaultIconColor,
    this.badge,
    super.key,
  }) : super(text: textOverride ?? icon.text);

  @override
  Widget build(BuildContext context) {
    double size = Theme.of(context).iconTheme.size ?? kDefaultFontSize;
    Color? color = colorFromContext(context);
    bool customizeColors = showBorder && color != null;

    return IconButton(
      onPressed: onPressed,
      icon: badge != null
        ? Badge(
            offset: const Offset(5, -5),
            label: badge?.label != null
              ? Text(
                  badge!.label!,
                  style: TextStyle(color: onNotificationSurfaceColor(context)),
                )
              : null,
            backgroundColor: badge?.color ?? notificationSurfaceColor(context),
            smallSize: 10,
            child: Icon(icon!.icon, color: color),
          )
        : Icon(icon!.icon, color: color),
      tooltip: (text != null) ? text : null,
      hoverColor: customizeColors ? color.withAlpha(hoverAlpha) : null,
      highlightColor: customizeColors ? color.withAlpha(highlightAlpha) : null,
      splashColor: customizeColors ? color.withAlpha(splashAlpha) : null,
      padding: EdgeInsets.zero,
      style: showBorder
        ? ButtonStyle(
            shape: WidgetStateProperty.all(
              CircleBorder(
                side: BorderSide(
                  color: color ?? Theme.of(context).iconTheme.color!,
                  width: 2,
                ),
              ),
            ),
            minimumSize: WidgetStateProperty.all(Size(size * 3, size * 3)),
            fixedSize: WidgetStateProperty.all(Size(size * 3, size * 3)),
          )
        : null,
    );
  }
}
