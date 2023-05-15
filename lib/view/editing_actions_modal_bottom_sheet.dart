import 'package:flutter/material.dart';

/// EditingActionsModalBottomSheet:
///   - A widget which displays the passed `EditingActionButton`'s
///     in a modal bottom sheet.
///   - Typically, should be used with `showModalBottomSheet`
class EditingActionsModalBottomSheet extends StatelessWidget {
  final List<EditingActionButton> actionButtons;
  const EditingActionsModalBottomSheet(
      {super.key, required this.actionButtons});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actionButtons
      ),
    );
  }
}

/// EditingActionButton:
///   - A button representing an "editing action" (deleting, renaming, etc.)
class EditingActionButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final String label;
  final Color? color;

  const EditingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label = '',
    this.color,
  });

  factory EditingActionButton.makeDeleteButton(
          {required void Function() onDelete}) =>
      EditingActionButton(
          onPressed: onDelete,
          icon: Icons.delete,
          label: 'Delete',
          color: Colors.red);

  factory EditingActionButton.makeEditButton(
          {required void Function() onPressed}) =>
      EditingActionButton(
          onPressed: onPressed,
          icon: Icons.edit,
          label: 'Edit',
          color: Colors.lightGreen);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          Navigator.pop(context);
          onPressed();
        },
        icon: Icon(icon),
        label: Text(label),
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color?>(color)));
  }
}
