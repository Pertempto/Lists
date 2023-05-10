import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';

/// EditItemDialog:
///   - a dialog that allows the user to edit an `Item`
class EditItemDialog extends StatefulWidget {
  final void Function(Item) onSubmit;
  final Item item;
  final Iterable<ItemGroup> itemGroups;

  const EditItemDialog(
      {super.key,
      required this.onSubmit,
      required this.item,
      required this.itemGroups});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController _editingController;
  late ItemType selectedItemType = widget.item.itemType;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.item.value);
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
            onFieldSubmitted: (_) => _submitNewItemValue(),
          ),
          const SizedBox(height: 15),
          _buildItemTypeSwitcher(),
          const SizedBox(height: 15),
          _buildGroupPicker(),
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

  Widget _buildGroupPicker() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Group"),
          DropdownMenu<ItemGroup>(
              leadingIcon: const Icon(Icons.category),
              dropdownMenuEntries: widget.itemGroups
                  .map((itemGroup) => DropdownMenuEntry(
                      value: itemGroup, label: itemGroup.title ?? 'Cheese'))
                  .toList()),
        ],
      );

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.item.value = _editingController.text;
    widget.item.itemType = selectedItemType;

    widget.onSubmit(widget.item);
  }
}
