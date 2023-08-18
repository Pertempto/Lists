import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String description;
  final void Function() onConfirm;

  const ConfirmationDialog(
      {super.key, required this.description, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(description, textAlign: TextAlign.start),
        content: const Text('This can not be undone'),
        icon: const Icon(Icons.warning),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red)),
              child: const Text('Confirm'))
        ]);
  }
}
