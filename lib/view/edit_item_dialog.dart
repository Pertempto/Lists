import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';

/// EditItemDialog:
///   - a dialog that allows the user to edit an `Item`
class EditItemDialog extends StatefulWidget {
  final String title;
  final void Function(Item) onSubmit;
  final Item item;

  const EditItemDialog(
      {super.key,
      required this.title,
      required this.onSubmit,
      required this.item});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.item.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _editingController,
            autofocus: true,
            onFieldSubmitted: (_) => _submitNewItemValue(),
          ),
          const SizedBox(height: 15),
          _buildItemTypeSwitcher()
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _submitNewItemValue(),
          child: const Text('Submit'),
        )
      ],
    );
  }

  Row _buildItemTypeSwitcher() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Checkbox?"),
          Switch(
              value: widget.item.itemType == ItemType.checkbox,
              onChanged: (isCheckbox) => setState(() => widget.item.itemType =
                  isCheckbox ? ItemType.checkbox : ItemType.text))
        ],
      );

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.item.value = _editingController.text;

    widget.onSubmit(widget.item);
  }
}
