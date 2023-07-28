import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/view/add_label_dialog.dart';
import 'package:lists/view/editing_actions_modal_bottom_sheet.dart';
import 'package:lists/view/submit_button.dart';

/// ListSettingsDialog:
///   - a dialog that allows the user to edit the settings of the list
class ListSettingsDialog extends StatefulWidget {
  final void Function(ListModel) onSubmit;
  final ListModel listModel;
  final Iterable<String> allLabels;
  final void Function()? onDelete;

  const ListSettingsDialog(
      {super.key,
      required this.onSubmit,
      required this.listModel,
      required this.allLabels,
      this.onDelete});

  @override
  State<ListSettingsDialog> createState() => _ListSettingsDialogState();
}

class _ListSettingsDialogState extends State<ListSettingsDialog> {
  late final TextEditingController _editingController;
  late final selectedLabels = widget.listModel.labels.toList();

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.listModel.title);
    // Update the state of the submit button when the user input changes
    _editingController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit List Settings', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _editingController,
            autofocus: true,
            onFieldSubmitted: (_) {
              // we don't want the user to be able to submit blank/empty items.
              if (!_isTitleBlank) _submitListModel();
            },
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
        if (widget.onDelete != null)
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete?.call();
              },
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red)),
              child: const Text('Delete')),
        SubmitButton(
          // if the title is blank, this button is disabled (onPressed == null),
          // because we don't want the user to be able to submit lists with blank titles.
          onPressed: !_isTitleBlank ? _submitListModel : null
        ),
      ],
    );
  }

  bool get _isTitleBlank => _editingController.text.trim().isEmpty;

  void _submitListModel() {
    Navigator.pop(context);
    widget.listModel.title = _editingController.text;
    widget.listModel.labels = selectedLabels;
    widget.onSubmit(widget.listModel);
  }
}
