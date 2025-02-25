import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/widgets/appbar_button.dart';

/// A wrapper for a Scaffold that standardizes the way widgets create Scaffolds,
/// to ensure consistency. Some variation is still allowed through the
/// standardized footer and background arguments
class CommonScaffold extends StatelessWidget {
  /// How many pixels the AppBar takes, to properly offset viewport height when
  /// computing the footer's Stack offset
  static const int footerOffset = 56;

  /// The title to be displyed in the AppBar
  final String title;

  /// The stardardized Scaffold's ListView's Column's children
  final List<Widget> children;

  /// The callback to navgate to the settings widget - if left null, no link to
  /// settings will be provided
  final void Function()? settingsLink;

  /// The widget to be used as background for the Stack
  final Widget? background;

  /// An instance of FloatongActionButton to draw in the Scaffold
  final FloatingActionButton? floatingActionButton;

  /// The padding used for the ListView - defaults to 20px horizontal
  final EdgeInsets padding;

  /// The CrossAxisAlignment for the Column
  final CrossAxisAlignment crossAxisAlignment;

  /// A footer must specify a widget and the desired height
  final ({Widget widget, double height})? footer;

  const CommonScaffold({
    required this.title,
    required this.children,
    this.settingsLink,
    this.background,
    this.floatingActionButton,
    this.footer,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          if (settingsLink != null)
            // Only add settings action if we pass the function in
            TAppBarButton(
              text: 'Settings',
              icon: Icons.settings,
              onTap: settingsLink!,
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: <Widget>[
          if (background != null) background!,
          Positioned.fill(
            bottom: footer != null ? footer!.height : 0,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: children.separateWith(
                      const SizedBox(height: 20),
                      separatorOnEnds: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (footer != null)
            Positioned.fill(
              top: height - footerOffset - footer!.height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
                    ),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Padding(
                  padding: padding,
                  child: footer!.widget,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
