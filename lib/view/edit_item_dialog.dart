import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model_item_group.dart';
import 'package:lists/model/list_model.dart';

/// EditItemDialog:
///   - a dialog that allows the user to edit an `Item`
class EditItemDialog extends StatefulWidget {
  final void Function(Item) onSubmit;
  final Item item;
  final ListModel containingListModel;

  const EditItemDialog(
      {super.key,
      required this.onSubmit,
      required this.item,
      required this.containingListModel});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController _editingController =
      TextEditingController(text: widget.item.value);
  late ItemType selectedItemType = widget.item.itemType;
  late ListModelItemGroup selectedGroup = widget.item.hasGroup
      ? widget.containingListModel.lookupGroup(widget.item.group)
      : widget.containingListModel.defaultItemGroup;

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
          DropdownMenu<ListModelItemGroup>(
              leadingIcon: const Icon(Icons.category),
              initialSelection: selectedGroup,
              onSelected: (newGroup) =>
                  selectedGroup = newGroup ?? selectedGroup,
              dropdownMenuEntries: widget.containingListModel
                  .groupsView()
                  .map((itemGroup) => DropdownMenuEntry(
                      value: itemGroup, label: itemGroup.title ?? '(None)'))
                  .toList())
        ],
      );

  void _submitNewItemValue() async {
    Navigator.pop(context);
    widget.item.value = _editingController.text;
    widget.item.itemType = selectedItemType;
    await widget.containingListModel.moveItem(widget.item, to: selectedGroup);

    widget.onSubmit(widget.item);
  }
}
