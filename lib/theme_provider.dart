import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void changeTheme(ThemeMode newMode) {
    themeMode = newMode;
    notifyListeners();
  }
}

class ThemedApp extends StatelessWidget {
  final String title;

  final Widget home;

  final Color seedColor;

  const ThemedApp({
    required this.title,
    required this.home,
    required this.seedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(seedColor),
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
