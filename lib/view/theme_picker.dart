import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

/// ThemePicker:
///   - a widget which allows the user to change the theme (light/dark mode)
class ThemePicker extends StatefulWidget {
  const ThemePicker({super.key});

  @override
  State<ThemePicker> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<AdaptiveThemeMode>(
        value: AdaptiveTheme.of(context).mode,
        onChanged: (newMode) {
          if (newMode != null) {
            AdaptiveTheme.of(context).setThemeMode(newMode);
          }
        },
        focusColor: Colors.transparent,
        items: const [
          DropdownMenuItem(
            value: AdaptiveThemeMode.system,
            child: Text('System'),
          ),
          DropdownMenuItem(
            value: AdaptiveThemeMode.light,
            child: Text('Light'),
          ),
          DropdownMenuItem(
            value: AdaptiveThemeMode.dark,
            child: Text('Dark'),
          )
        ]);
  }
}
