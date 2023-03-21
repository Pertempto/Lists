import 'package:flutter/material.dart';
import 'package:lists/view/theme_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.titleLarge),
        const SettingsBox(label: 'Theme', settingController: ThemePicker()),
      ],
    );
  }
}

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
