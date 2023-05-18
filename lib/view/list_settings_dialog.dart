import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ListSettingsDialog:
///   - a dialog that allows the user to edit the settings of the list
class ListSettingsDialog extends StatefulWidget {
  final void Function(ListModel) onSubmit;
  final ListModel listModel;

  const ListSettingsDialog(
      {super.key, required this.onSubmit, required this.listModel});

  @override
  State<ListSettingsDialog> createState() => _ListSettingsDialogState();
}

class _ListSettingsDialogState extends State<ListSettingsDialog> {
  late final TextEditingController _editingController =
      TextEditingController(text: widget.listModel.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter New List Title', textAlign: TextAlign.center),
      content: TextFormField(
        controller: _editingController,
        autofocus: true,
        onFieldSubmitted: (_) => _submitNewItemValue(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _submitNewItemValue(),
          child: const Text('Submit'),
        )
      ],
    );
  }

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.listModel.title = _editingController.text;
    widget.onSubmit(widget.listModel);
  }
}
