import 'package:flutter/material.dart';
import 'package:tfields/mixins/standard_colorer.dart';
import 'package:tfields/widgets/badge.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/icons.dart';

/// A builder redirector to the constructors of _TButtonIconOnly. It is
/// callable directly to use the normal constructor, and presets are available
/// according to the TPresetIcon enum:
///
/// `TButton.iconOnly()` calls the regular constructor
/// `TButton.iconOnly.delete()` calls the preset icon constructor with
/// the delete icon
class TButtonIconOnlyBuilder {
  const TButtonIconOnlyBuilder();

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

  TButton refresh({
    bool forceDefaultIconColor = false,
    bool showBorder = false,
    String? textOverride,
    void Function()? onPressed,
    Key? key,
  }) {
    return _TButtonIconOnly.fromPreset(
      icon: TPresetIcon.refresh,
      forceDefaultIconColor: forceDefaultIconColor,
      textOverride: textOverride,
      onPressed: onPressed,
      showBorder: showBorder,
      key: key,
    );
  }
}

class _TButtonIconOnly extends TButton with TStandardColorer {
  static final int hoverAlpha = (255 * 0.3).toInt();
  static final int highlightAlpha = (255 * 0.3).toInt();
  static final int splashAlpha = (255 * 0.3).toInt();

  final bool showBorder;
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
