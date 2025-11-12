import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfields/src/mixins/settings.dart';
import 'package:tfields/src/settings.dart';

/// A type declaration to simplify declaration of the ThemeProvider build
/// function
typedef TThemeBuilder = TThemeProvider Function(
  Color seedColor,
  BuildContext context,
);

/// A wrapper to the light and dark Themes, that provides them to applications
/// through the ChangeNotifier mixin, that allows others to listen in on calls
/// to change the current theme in the app
class TThemeProvider with ChangeNotifier {
  /// The theme's primary seed color
  final Color seedColor;

  /// The theme's current mode - defaults to matching system mode
  ThemeMode themeMode = ThemeMode.system;

  TThemeProvider(this.seedColor);

  /// The ColorScheme used in light mode
  late final ColorScheme lightScheme =
      ColorScheme.fromSeed(seedColor: seedColor);

  /// The ColorScheme used in dark mode
  late final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  /// The ThemeData used in light mode
  late final ThemeData light = ThemeData(
    colorScheme: lightScheme,
    // This will make the scrollbar always visible
    scrollbarTheme: ScrollbarThemeData(
      trackColor: WidgetStateProperty.all(lightScheme.surface),
      thumbColor: WidgetStateProperty.all(lightScheme.inversePrimary),
      trackVisibility: WidgetStateProperty.all(true),
      thumbVisibility: WidgetStateProperty.all(true),
    ),
    useMaterial3: true,
  );

  /// The ThemeData used in dark mode
  late final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: darkScheme,
    // This will make the scrollbar always visible
    scrollbarTheme: ScrollbarThemeData(
      trackColor: WidgetStateProperty.all(darkScheme.surface),
      thumbColor: WidgetStateProperty.all(darkScheme.inversePrimary),
      trackVisibility: WidgetStateProperty.all(true),
      thumbVisibility: WidgetStateProperty.all(true),
    ),
    useMaterial3: true,
  );

  /// The function that toggles different ThemeModes for the application
  @mustCallSuper
  void changeTheme(ThemeMode newMode) {
    themeMode = newMode;
    notifyListeners();
  }
}

/// An extension of ThemeProvider that integrates itself with the CommonSettings
/// structure, including the currently selected theme in the settings.json file
/// used by the app's settings
abstract class TSettingsThemeProvider<S extends TCommonSettings>
    extends TThemeProvider with TSettingsJsonWriter<S> {
  TSettingsThemeProvider(super.seedColor) {
    readSettings();
    themeMode = settings.themeMode;
  }

  @override
  void changeTheme(ThemeMode newMode) {
    super.changeTheme(newMode);
    settings.themeMode = newMode;
    writeSettings();
  }

  @override
  void handleWriteError(Object exception, StackTrace stackTrace) {
    // Not a big deal if we error here - just a simple toggle
  }
}

/// A wrapper around MaterialApp that allows easily toggling between themes,
/// specifically a light and dark one. It calls upon ThemeProvider to supply it
/// with any changes to the theme, re-rendering the app whenever it is toggled
class TThemedApp extends StatelessWidget {
  /// The title that will be passed to the MaterialApp
  final String title;

  /// The home widget that will be passed to the MaterialApp
  final Widget home;

  /// The color that seeds the theme's color scheme
  final Color seedColor;

  /// A function that properly builds the Theme used in the MaterialApp
  final TThemeBuilder themeBuilder;

  const TThemedApp({
    required this.title,
    required this.home,
    required this.seedColor,
    required this.themeBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TThemeProvider>(
      create: (BuildContext c) => themeBuilder(seedColor, c),
      child: Consumer<TThemeProvider>(
        builder: (_, TThemeProvider themeProvider, __) => MaterialApp(
          title: title,
          theme: themeProvider.light,
          darkTheme: themeProvider.dark,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: home,
        ),
      ),
    );
  }
}
