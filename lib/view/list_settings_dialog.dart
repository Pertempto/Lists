import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ListSettingsDialog:
///   - a dialog that allows the user to edit the metadata of the list
class ListSettingsDialog extends StatefulWidget {
  final void Function(ListModel) onSubmit;
  final ListModel listModel;

  const ListSettingsDialog(
      {super.key, required this.onSubmit, required this.listModel});

  @override
  State<ListSettingsDialog> createState() => _ListSettingsDialogState();
}

class _ListSettingsDialogState extends State<ListSettingsDialog> {
  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.listModel.title);
    _editingController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter New List Title', textAlign: TextAlign.center),
      content: TextFormField(
        controller: _editingController,
        autofocus: true,
        onFieldSubmitted: (value) {
          // we don't want the user to be able to submit blank/empty items.
          if (!_isTitleBlank) _submitListModel();
        },
      ),
      actions: [
        ElevatedButton(
          // if the title is blank, this button is disabled (onPressed == null),
          // because we don't want the user to be able to submit lists with blank titles.
          onPressed: !_isTitleBlank ? _submitListModel : null,
          child: const Text('Submit'),
        )
      ],
    );
  }

  bool get _isTitleBlank => _editingController.text.trim().isEmpty;

  void _submitListModel() {
    Navigator.pop(context);
    widget.listModel.title = _editingController.text;
    widget.onSubmit(widget.listModel);
  }
}
