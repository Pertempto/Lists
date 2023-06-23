import 'package:flutter/material.dart';

/// AddLabelDialog:
///   - dialog for adding a label to a list (used by `ListSettingsDialog`)
class AddLabelDialog extends StatefulWidget {
  final Iterable<String> labels;

  const AddLabelDialog(
      {super.key, required this.labels});

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
                autofocus: true,
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: 'Enter a label',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => Navigator.pop(
                            context, textEditingController.text))),
                onChanged: (value) => setState(() => searchQuery = value),
                onSubmitted: (newLabel) => Navigator.pop(context, newLabel))),
        SizedBox(
          height: 200,
          width:
              0, // to minimize the width of the `ListTile`s; without this, each `ListTile` would have infinite width.
          child: ListView(
              children: widget.labels
                  .where((label) =>
                      label.contains(searchQuery))
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
