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
    return DropdownMenu(
        initialSelection: AdaptiveTheme.of(context).mode,
        onSelected: (newMode) {
          if (newMode != null) {
            AdaptiveTheme.of(context).setThemeMode(newMode);
          }
        },
        dropdownMenuEntries: const [
          DropdownMenuEntry(
            label: 'System',
            value: AdaptiveThemeMode.system,
          ),
          DropdownMenuEntry(
            label: 'Light',
            value: AdaptiveThemeMode.light,
          ),
          DropdownMenuEntry(
            label: 'Dark',
            value: AdaptiveThemeMode.dark,
          )
        ]);
  }
}
