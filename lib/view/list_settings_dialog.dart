import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ListSettingsDialog:
///   - a dialog that allows the user to edit the metadata of the list
class ListSettingsDialog extends StatefulWidget {
  final void Function(ListModel) onSubmit;
  final ListModel listModel;
  final Iterable<String> labels;

  const ListSettingsDialog(
      {super.key,
      required this.onSubmit,
      required this.listModel,
      required this.labels});

  @override
  State<ListSettingsDialog> createState() => _ListSettingsDialogState();
}

class _ListSettingsDialogState extends State<ListSettingsDialog> {
  late final TextEditingController _editingController;
  // late Set<String> labels = widget.labels.toSet();

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
          Wrap(
              spacing: 4,
              runSpacing: 4,
              children: widget.listModel.labels
                  .map((label) => Chip(
                      label: Text(label),
                      onDeleted: () {
                        widget.listModel.removeLabel(label);
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
                            labels: widget.labels, listModel: widget.listModel),
                      );
                      if (newLabel != null) {
                        widget.listModel.addLabel(newLabel);
                        setState(() {});
                      }
                      //   .map((label) =>
                      //       PopupMenuItem(value: label, child: Text(label)))
                      //   .followedBy([
                      // PopupMenuItem(child: TextFormField(
                      //   onFieldSubmitted: (label) async {
                      //     print('adding label $label');
                      //     widget.listModel.addLabel(label);
                      //     if (context.mounted) Navigator.pop(context);
                      //     labels.add(label);
                      //     setState(() {});
                      //   },
                      // ))
                      // ]).toList()),
                    })
              ]).toList())
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
    widget.onSubmit(widget.listModel);
  }
}

class AddLabelDialog extends StatefulWidget {
  final Iterable<String> labels;
  final ListModel listModel;

  const AddLabelDialog(
      {super.key, required this.labels, required this.listModel});

  @override
  State<AddLabelDialog> createState() => _AddLabelDialogState();
}

class _AddLabelDialogState extends State<AddLabelDialog> {
  String searchQuery = '';
  late TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ListTile(
            title: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: 'Enter a label',
                    prefixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() {
                              textEditingController.clear();
                              searchQuery = '';
                            })),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => Navigator.pop(
                            context, textEditingController.text))),
                onChanged: (value) => setState(() => searchQuery = value),
                onSubmitted: (newLabel) => Navigator.pop(context, newLabel))),
        SizedBox(
          height: 200,
          width: 0,
          child: ListView(
              children: widget.labels
                  .where((label) =>
                      label.contains(searchQuery) &&
                      !widget.listModel.hasLabel(label))
                  .map((label) => ListTile(
                      title: Text(label),
                      onTap: () => Navigator.pop(context, label)))
                  .toList()),
        ),
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
