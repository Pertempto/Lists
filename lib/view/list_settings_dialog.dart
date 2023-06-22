import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/view/add_label_dialog.dart';

/// ListSettingsDialog:
///   - a dialog that allows the user to edit the metadata of the list
class ListSettingsDialog extends StatefulWidget {
  final void Function(ListModel) onSubmit;
  final ListModel listModel;
  final Iterable<String> allLabels;

  const ListSettingsDialog(
      {super.key,
      required this.onSubmit,
      required this.listModel,
      required this.allLabels});

  @override
  State<ListSettingsDialog> createState() => _ListSettingsDialogState();
}

class _ListSettingsDialogState extends State<ListSettingsDialog> {
  late final TextEditingController _editingController;
  late final selectedLabels = widget.listModel.labels.toList();

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.listModel.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter New List Title', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _editingController,
            autofocus: true,
            onFieldSubmitted: (_) => _submitNewItemValue(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: selectedLabels
                    .map((label) => Chip(
                        label: Text(label),
                        onDeleted: () {
                          selectedLabels.remove(label);
                          setState(() {});
                        }))
                    .cast<Widget>()
                    .followedBy([
                  TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add label'),
                      onPressed: () async {
                        final newLabel = await showDialog(
                          context: context,
                          builder: (context) => AddLabelDialog(
                              labels: widget.allLabels.where(
                                  (label) => !selectedLabels.contains(label))),
                        );
                        if (newLabel != null) {
                          selectedLabels.add(newLabel);
                          setState(() {});
                        }
                      })
                ]).toList()),
          )
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

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.listModel.title = _editingController.text;
    widget.listModel.labels = selectedLabels;
    widget.onSubmit(widget.listModel);
  }
}
