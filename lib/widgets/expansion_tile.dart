import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';

/// A simplification of ExpansionTile with standardized border and text handling
class TExpansionTile extends StatelessWidget {
  /// The title string used in the expansion header
  final String title;

  /// The subtitle string used in the expansion header
  final String subtitle;

  /// The widget to draw before the title in the expansion header
  final Widget? leading;

  /// The widget to draw after the title in the expansion header
  final Widget? titleSuffix;

  /// The children to display once the widget is expanded
  final List<Widget> children;

  /// Whether this will be rendered expanded initially or not. Defaults to FALSE
  final bool initiallyExpanded;

  /// Whether the children state will be preserved when the expansion tile
  /// collapses. Defaults to TRUE
  final bool maintainState;

  const TExpansionTile({
    required this.title,
    required this.children,
    this.subtitle = '',
    this.maintainState = true,
    this.initiallyExpanded = false,
    this.leading,
    this.titleSuffix,
    super.key,
  });

  TExpansionTile.withValidationErrorChip({
    required this.title,
    required this.children,
    required String validationErrorText,
    this.subtitle = '',
    this.maintainState = true,
    this.initiallyExpanded = false,
    this.leading,
    super.key,
  }) : titleSuffix = validationErrorText.isNotEmpty
    ? _ValidationErrorChip(validationErrorText)
    : null;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: maintainState,
      initiallyExpanded: initiallyExpanded,
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
      title: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (titleSuffix != null) titleSuffix!,
        ].separateWith(const SizedBox(width: 10)),
      ),
      children: <Widget>[
        ColoredBox(
          color: Theme.of(context).colorScheme.inverseSurface.withAlpha(127),
          child: const SizedBox(width: double.infinity, height: 1),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ValidationErrorChip extends StatelessWidget {
  final String validationErrorText;

  const _ValidationErrorChip(this.validationErrorText);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.warning,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
      label: Text(
        validationErrorText,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
    );
  }
}
