import 'package:flutter/material.dart';
import 'package:tfields/theme.dart';

/// A widget that toggles between light and dark modes, informing the callback
/// of the newly selected mode. It presents itself as a Switch, with custom
/// icons for light and dark modes.
class TThemeSwitch extends StatelessWidget {
  const TThemeSwitch({super.key});

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
      activeThumbColor: Theme.of(context).colorScheme.primary,
      onChanged: (bool value) => TThemeProvider.of(context).changeThemeMode(
        value ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
