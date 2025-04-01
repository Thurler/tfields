import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final void Function(ThemeMode newTheme) themeToggleCallback;

  const ThemeSwitch(this.themeToggleCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Switch(
      value: isDark,
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
        (Set<WidgetState> states) => !states.contains(WidgetState.selected)
          ? const Icon(Icons.sunny, color: Colors.white)
          : const Icon(Icons.mode_night, color: Colors.black),
      ),
      inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
      activeTrackColor: Theme.of(context).scaffoldBackgroundColor,
      inactiveThumbColor: Theme.of(context).colorScheme.primary,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: (bool value) =>
          themeToggleCallback(value ? ThemeMode.dark : ThemeMode.light),
    );
  }
}
