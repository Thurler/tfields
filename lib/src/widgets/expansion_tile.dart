import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/icon_chip.dart';
import 'package:tfields/src/widgets/text_overflow_tooltip.dart';

/// A simplification of ExpansionTile with standardized border and text handling
class TExpansionTile extends StatelessWidget {
  /// The title string used in the expansion header
  final String title;

  /// The subtitle string used in the expansion header
  final String subtitle;

  /// The widget to draw before the title in the expansion header
  final Widget? leading;

  /// The widget to draw just before the expansion arrow in the expansion header
  final Widget? trailing;

  /// The widget to draw after the title in the expansion header
  final Widget? titleSuffix;

  /// The border to use for when the expansion tile is collapsed. Defaults to
  /// [ColorScheme.inverseSurface] with 127 alpha
  final ShapeBorder? collapsedBorder;

  /// The border to use for when the expansion tile is expanded. Defaults to
  /// [ColorScheme.inverseSurface] with 200 alpha
  final ShapeBorder? expandedBorder;

  /// The children to display once the widget is expanded
  final List<Widget> children;

  /// Whether this will be rendered expanded initially or not. Defaults to FALSE
  final bool initiallyExpanded;

  /// Whether the children state will be preserved when the expansion tile
  /// collapses. Defaults to TRUE
  final bool maintainState;

  /// The cross-axis alignment to use for the expansion tile's children
  final CrossAxisAlignment crossAxisAlignment;

  /// A minimum height to reserve for the title widget, usually used so that it
  /// will not get resized when the suffix is rendered / hidden on demand
  final double? titleMinHeight;

  /// The background color to be used in the [ExpansionTile] widget
  final Color? backgroundColor;

  const TExpansionTile({
    required this.title,
    required this.children,
    this.subtitle = '',
    this.maintainState = true,
    this.initiallyExpanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.leading,
    this.trailing,
    this.titleSuffix,
    this.collapsedBorder,
    this.expandedBorder,
    this.titleMinHeight,
    this.backgroundColor,
    super.key,
  });

  TExpansionTile.withInformationChip({
    required this.title,
    required this.children,
    required String informationText,
    this.subtitle = '',
    this.maintainState = true,
    this.initiallyExpanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.backgroundColor,
    this.collapsedBorder,
    this.expandedBorder,
    this.leading,
    this.trailing,
    super.key,
  }) :
    titleMinHeight = 35,
    titleSuffix = informationText.isNotEmpty
      ? TIconChip.information(informationText)
      : null;

  TExpansionTile.withValidationErrorChip({
    required this.title,
    required this.children,
    required String validationErrorText,
    String informationText = '',
    this.subtitle = '',
    this.maintainState = true,
    this.initiallyExpanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.backgroundColor,
    this.collapsedBorder,
    this.expandedBorder,
    this.leading,
    this.trailing,
    super.key,
  }) :
    titleMinHeight = 35,
    titleSuffix = switch (null) {
      _ when (validationErrorText.isNotEmpty && informationText.isNotEmpty) =>
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            TIconChip.warning(validationErrorText),
            TIconChip.information(informationText),
          ],
        ),
      _ when validationErrorText.isNotEmpty =>
        TIconChip.warning(validationErrorText),
      _ when informationText.isNotEmpty =>
        TIconChip.information(informationText),
      _ => null,
    };

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: maintainState,
      initiallyExpanded: initiallyExpanded,
      backgroundColor: backgroundColor,
      collapsedBackgroundColor: backgroundColor,
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.inverseSurface.withAlpha(127),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.inverseSurface.withAlpha(200),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      leading: leading,
      title: ConstrainedBox(
        constraints: BoxConstraints(minHeight: titleMinHeight ?? 0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TTextOverflowTooltip(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (titleSuffix != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: titleSuffix,
              ),
            if (trailing != null) ...<Widget>[
              const Expanded(child: SizedBox(width: double.infinity)),
              trailing!,
            ],
          ],
        ),
      ),
      children: <Widget>[
        ColoredBox(
          color: Theme.of(context).colorScheme.inverseSurface.withAlpha(127),
          child: const SizedBox(width: double.infinity, height: 1),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ],
    );
  }
}
