import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/settings.dart';

typedef ThemeBuilder = ThemeProvider Function(
  Color seedColor,
  BuildContext context,
);

class ThemeProvider with ChangeNotifier {
  final Color seedColor;

  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider(this.seedColor);

  late final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
  );

  late final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

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

  @mustCallSuper
  void changeTheme(ThemeMode newMode) {
    themeMode = newMode;
    notifyListeners();
  }
}

abstract class SettingsThemeProvider<S extends CommonSettings>
    extends ThemeProvider with SettingsReader<S> {
  SettingsThemeProvider(super.seedColor) {
    loadSettings();
    themeMode = settings.themeMode;
  }

  @override
  void changeTheme(ThemeMode newMode) {
    super.changeTheme(newMode);
    settings.themeMode = newMode;
    try {
      File settingsFile = File('./settings.json');
      settingsFile.writeAsStringSync('${json.encode(settings.toJson())}\n');
    } on Exception catch (_) {
      // Not a big deal if we don't save here - just a simple toggle
    }
  }
}

class ThemedApp extends StatelessWidget {
  final String title;

  final Widget home;

  final Color seedColor;

  final ThemeBuilder themeBuilder;

  const ThemedApp({
    required this.title,
    required this.home,
    required this.seedColor,
    required this.themeBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext c) => themeBuilder(seedColor, c),
      child: Consumer<ThemeProvider>(
        builder: (_, ThemeProvider themeProvider, __) => MaterialApp(
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
