import 'package:flutter/material.dart';
import 'package:tfields/src/mixins/settings.dart';
import 'package:tfields/src/settings.dart';

class _TTheme {
  /// The theme's primary seed color
  final Color _seedColor;

  _TTheme(this._seedColor);

  /// The ColorScheme used in light mode
  late final ColorScheme _lightScheme =
      ColorScheme.fromSeed(seedColor: _seedColor);

  /// The ColorScheme used in dark mode
  late final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  );

  /// The ThemeData used in light mode
  late final ThemeData light = ThemeData(
    colorScheme: _lightScheme,
    // This will make the scrollbar always visible
    scrollbarTheme: ScrollbarThemeData(
      trackColor: WidgetStateProperty.all(_lightScheme.surface),
      thumbColor: WidgetStateProperty.all(_lightScheme.inversePrimary),
      trackVisibility: WidgetStateProperty.all(true),
      thumbVisibility: WidgetStateProperty.all(true),
    ),
    useMaterial3: true,
  );

  /// The ThemeData used in dark mode
  late final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: _darkScheme,
    // This will make the scrollbar always visible
    scrollbarTheme: ScrollbarThemeData(
      trackColor: WidgetStateProperty.all(_darkScheme.surface),
      thumbColor: WidgetStateProperty.all(_darkScheme.inversePrimary),
      trackVisibility: WidgetStateProperty.all(true),
      thumbVisibility: WidgetStateProperty.all(true),
    ),
    useMaterial3: true,
  );
}

/// A wrapper to the light and dark Themes, that provides them to applications
/// through the ChangeNotifier mixin, that allows others to listen in on calls
/// to change the current theme in the app
class TTheme extends InheritedWidget {
  /// The theme's current mode - defaults to matching system mode
  final ThemeMode themeMode;

  /// The struct that holds light/dark color schemes and theme data
  final _TTheme _theme;

  TTheme(
    Color seedColor, {
    required super.child,
    this.themeMode = ThemeMode.system,
    super.key,
  }) : _theme = _TTheme(seedColor);

  /// The [ThemeData] to use when [ThemeMode.light] is the selected mode
  ThemeData get light => _theme.light;

  /// The [ThemeData] to use when [ThemeMode.dark] is the selected mode
  ThemeData get dark => _theme.dark;

  @override
  bool updateShouldNotify(covariant TTheme oldWidget) =>
      themeMode != oldWidget.themeMode;

  static TTheme? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TTheme>();

  static TTheme of(BuildContext context) => maybeOf(context)!;
}

/// An extension of [TTheme] that provides a callback to toggle the selected
/// [themeMode], acting as a provider of that state
class TThemeProvider extends TTheme {
  /// The callback that will toggle the theme mode in whichever state controls
  /// [themeMode]
  final void Function(ThemeMode) changeThemeMode;

  TThemeProvider(
    super.seedColor, {
    required this.changeThemeMode,
    required super.child,
    super.key,
  });

  static TThemeProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TThemeProvider>();

  static TThemeProvider of(BuildContext context) => maybeOf(context)!;
}

/// A wrapper around MaterialApp that allows easily toggling between themes,
/// specifically a light and dark one. It calls upon ThemeProvider to supply it
/// with any changes to the theme, re-rendering the app whenever it is toggled
class TThemedApp extends StatefulWidget {
  /// The title that will be passed to the MaterialApp
  final String title;

  /// The home widget that will be passed to the MaterialApp
  final Widget home;

  /// The color that seeds the theme's color scheme
  final Color seedColor;

  /// The builder function that will be passed along to the MaterialApp
  final Widget Function(
    BuildContext context,
    Widget? widget,
  )? materialAppBuilder;

  /// A callback to call whenever the current [ThemeMode] changes
  final void Function(ThemeMode)? changeThemeMode;

  /// The starting [ThemeMode] for when the application opens
  final ThemeMode initialThemeMode;

  const TThemedApp({
    required this.title,
    required this.home,
    required this.seedColor,
    this.initialThemeMode = ThemeMode.system,
    this.materialAppBuilder,
    this.changeThemeMode,
    super.key,
  });

  /// Initialize the themed app with a settings writer, so that toggles in theme
  /// mode are saved to a settings file
  static TThemedApp withSettings<S extends TCommonSettings>({
    required String title,
    required Widget home,
    required Color seedColor,
    required TSettingsWriter<S> settingsWriter,
    Widget Function(
      BuildContext context,
      Widget? widget,
    )? materialAppBuilder,
    Key? key,
  }) {
    return TThemedApp(
      title: title,
      home: home,
      seedColor: seedColor,
      initialThemeMode: settingsWriter.settings.themeMode,
      changeThemeMode: (ThemeMode themeMode) {
        settingsWriter.readSettings();
        settingsWriter.settings.themeMode = themeMode;
        settingsWriter.writeSettings();
      },
      materialAppBuilder: materialAppBuilder,
      key: key,
    );
  }

  @override
  State<StatefulWidget> createState() => _TThemedAppState();
}

class _TThemedAppState extends State<TThemedApp> {
  ThemeMode? _themeMode;

  void _changeTheme(ThemeMode newMode) {
    widget.changeThemeMode?.call(newMode);
    _themeMode = newMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TThemeProvider(
      widget.seedColor,
      changeThemeMode: _changeTheme,
      child: Builder(
        builder: (BuildContext themedContext) {
          _TTheme theme = TTheme.maybeOf(themedContext)?._theme ??
              _TTheme(widget.seedColor);
          return MaterialApp(
            title: widget.title,
            theme: theme.light,
            darkTheme: theme.dark,
            themeMode: _themeMode ?? widget.initialThemeMode,
            debugShowCheckedModeBanner: false,
            home: widget.home,
            builder: widget.materialAppBuilder,
          );
        },
      ),
    );
  }
}
