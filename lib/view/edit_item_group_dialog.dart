import 'package:flutter/material.dart';
import 'package:lists/model/item_group_base.dart';

class EditItemGroupDialog extends StatefulWidget {
  final ItemGroupBase itemGroup;
  final void Function(ItemGroupBase) onSubmit;

  const EditItemGroupDialog(
      {super.key, required this.itemGroup, required this.onSubmit});

  @override
  State<EditItemGroupDialog> createState() => _EditItemGroupDialogState();
}

class _EditItemGroupDialogState extends State<EditItemGroupDialog> {
  final TextEditingController _editingController = TextEditingController();

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
