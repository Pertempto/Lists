import 'package:flutter/material.dart';
import 'package:lists/view/theme_picker.dart';

/// SettingsWidget:
///   - This widget allows the user to change the settings
///     of the app.
///   - Use in `showSideModalSheet`. TODO: make into settings page
class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Settings', style: Theme.of(context).textTheme.titleLarge),
              const CloseButton()
            ],
          ),
          const SettingsBox(label: 'Theme', settingController: ThemePicker()),
        ],
      ),
    );
  }
}

/// SettingsBox:
///   - A widget which allows the user to edit a single setting
class SettingsBox extends StatelessWidget {
  final String label;
  final Widget settingController;
  const SettingsBox(
      {super.key, required this.label, required this.settingController});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), settingController],
        ),
      ),
    );
  }
}
