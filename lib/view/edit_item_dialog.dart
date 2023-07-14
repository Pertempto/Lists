import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lists/common/time_stamp_format.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/repeat_dialog.dart';

import 'package:lists/model/repeat_configuration.dart';

/// EditItemDialog:
///   - a dialog that allows the user to edit an `Item`
class EditItemDialog extends StatefulWidget {
  final void Function(Item) onSubmit;
  final Item item;

  const EditItemDialog({
    super.key,
    required this.onSubmit,
    required this.item,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController _editingController;
  late ItemType selectedItemType = widget.item.itemType;

  late bool isRepeating = widget.item.isRepeating;
  late RepeatConfiguration repeatConfig =
      widget.item.repeatConfiguration ?? RepeatConfiguration.fromNow();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _editingController,
            autofocus: true,
            onFieldSubmitted: (_) => _submitNewItemValue(),
          ),
          const SizedBox(height: 16),
          _buildItemTypeSwitcher(),
          const SizedBox(height: 8),
          _buildRepeatConfigWidget(),
          // _buildRepeatOptions()
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

  Widget _buildRepeatConfigWidget() => isRepeating
      ? InputChip(
          avatar: Icon(Icons.repeat, color: Theme.of(context).iconTheme.color),
          label: Text(timeStampFormat.format(repeatConfig.nextRepeat)),
          onDeleted: () => setState(() => isRepeating = false),
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
              repeatConfig = newRepeatConfig;
              isRepeating = true;
              setState(() {});
            },
            repeatConfig: repeatConfig));
  }

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.item.value = _editingController.text;
    widget.item.itemType = selectedItemType;
    if (isRepeating) {
      widget.item.repeatConfiguration = repeatConfig;
      widget.item.scheduledTimeStamp = repeatConfig.nextRepeat;
    } else {
      widget.item.scheduledTimer?.cancel();
      widget.item.scheduledTimer = null;
      widget.item.repeatConfiguration = null;
      widget.item.scheduledTimeStamp = null;
    }

    widget.onSubmit(widget.item);
  }
}
