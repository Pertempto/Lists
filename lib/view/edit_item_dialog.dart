import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';

/// EditItemDialog:
///   - a dialog that allows the user to edit an `Item`
class EditItemDialog extends StatefulWidget {
  final void Function(Item) onSubmit;
  final void Function()? onDelete;
  final Item item;

  const EditItemDialog(
      {super.key, required this.onSubmit, this.onDelete, required this.item});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController _editingController;
  late ItemType selectedItemType = widget.item.itemType;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.item.value);
    // Update the state of the submit button when the user input changes
    _editingController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Item', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _editingController,
            autofocus: true,
            onFieldSubmitted: (value) {
              // we don't want the user to be able to add blank/empty items.
              if (!_isValueBlank) _submitNewItemValue();
            },
          ),
          const SizedBox(height: 16),
          _buildItemTypeSwitcher()
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call();
            },
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.red)),
            child: const Text('Delete'),
          ),
        ElevatedButton(
          // if the text value for the item is blank, this button is disabled (onPressed == null),
          // because we don't want the user to be able to submit blank/empty items.
          onPressed: !_isValueBlank ? _submitNewItemValue : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  bool get _isValueBlank => _editingController.text.trim().isEmpty;

  Widget _buildItemTypeSwitcher() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Checkbox?"),
          Switch(
              value: selectedItemType == ItemType.checkbox,
              onChanged: (isCheckbox) => setState(() => selectedItemType =
                  isCheckbox ? ItemType.checkbox : ItemType.text))
        ],
      );

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.item.value = _editingController.text;
    widget.item.itemType = selectedItemType;

    widget.onSubmit(widget.item);
  }
}
