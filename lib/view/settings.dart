import 'dart:io' show Platform;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lists/view/theme_picker.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        Text("Settings", style: Theme.of(context).textTheme.titleLarge),
        const SettingEditingCard(label: "Theme", pickerWidget: ThemePicker()),
      ],
    );
  }
}

class SettingEditingCard extends StatelessWidget {
  final String label;
  final Widget pickerWidget;
  const SettingEditingCard(
      {super.key, required this.label, required this.pickerWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), pickerWidget],
        ),
      ),
    );
  }
}
