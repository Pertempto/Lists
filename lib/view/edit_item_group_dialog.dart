import 'package:flutter/material.dart';
import 'package:lists/model/item_group.dart';

/// EditItemDialog:
///   - a dialog that allows the user to edit an `ItemGroup`
class EditItemGroupDialog extends StatefulWidget {
  final ItemGroup itemGroup;
  final void Function(ItemGroup) onSubmit;

  const EditItemGroupDialog(
      {super.key, required this.itemGroup, required this.onSubmit});

  @override
  State<EditItemGroupDialog> createState() => _EditItemGroupDialogState();
}

class _EditItemGroupDialogState extends State<EditItemGroupDialog> {
  late final TextEditingController _editingController =
      TextEditingController(text: widget.itemGroup.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Item Group', textAlign: TextAlign.center),
      content: TextFormField(
        controller: _editingController,
        autofocus: true,
        onFieldSubmitted: (_) => _submitNewItemGroup(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _submitNewItemGroup(),
          child: const Text('Submit'),
        )
      ],
    );
  }

  void _submitNewItemGroup() {
    Navigator.pop(context);
    widget.itemGroup.title = _editingController.text;
    widget.onSubmit(widget.itemGroup);
  }
}
