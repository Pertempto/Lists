import 'package:flutter/material.dart';
import 'package:lists/common/time_stamp_format.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_scheduling.dart';
import 'package:lists/view/repeat_dialog.dart';
import 'package:lists/view/submit_button.dart';

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

  late ItemScheduling? selectedScheduling = widget.item.scheduling?.copy();

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _buildItemTypeSwitcher(),
          const SizedBox(height: 8),
          _buildRepeatWidget()
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
        SubmitButton(
            // if the text value for the item is blank, this button is disabled (onPressed == null),
            // because we don't want the user to be able to submit blank/empty items.
            onPressed: !_isValueBlank ? _submitNewItemValue : null)
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

  Widget _buildRepeatWidget() => selectedScheduling != null
      ? InputChip(
          avatar: Icon(Icons.repeat, color: Theme.of(context).iconTheme.color),
          label: Text(
              timeStampFormat.format(selectedScheduling!.scheduledTimeStamp)),
          onDeleted: () => setState(() => selectedScheduling = null),
          onPressed: _showRepeatDialog)
      : ActionChip(
          avatar: Icon(Icons.repeat, color: Theme.of(context).iconTheme.color),
          label: const Text('Repeat'),
          onPressed: _showRepeatDialog);

  void _showRepeatDialog() {
    showDialog(
        context: context,
        builder: (context) => RepeatDialog(
            onSubmit: (newRepeatConfig) {
              selectedScheduling =
                  ItemScheduling.fromRepeatConfiguration(newRepeatConfig);
              setState(() {});
            },
            repeatConfig: selectedScheduling?.repeatConfiguration));
  }

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.item.value = _editingController.text;
    widget.item.itemType = selectedItemType;

    widget.item.scheduling = selectedScheduling;

    widget.onSubmit(widget.item);
  }
}
