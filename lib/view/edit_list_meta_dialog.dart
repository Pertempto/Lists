import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// EditListDialog:
///   - a dialog that allows the user to edit the metadata of the list
class EditListMetaDialog extends StatefulWidget {
  final String title;
  final void Function(ListModel) onSubmit;
  final ListModel listModel;

  const EditListMetaDialog(
      {super.key,
      required this.title,
      required this.onSubmit,
      required this.listModel});

  @override
  State<EditListMetaDialog> createState() => _EditListMetaDialogState();
}

class _EditListMetaDialogState extends State<EditListMetaDialog> {
  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.listModel.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
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
