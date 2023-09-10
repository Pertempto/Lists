import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ExportListAsMarkdownDialog:
///   - Dialog for exporting the passed-in list model as a markdown file on mobile.
///   - When this dialog is closed, it will pass either true, false, or null to
///     `Navigator.pop`
class ExportListAsMarkdownDialog extends StatefulWidget {
  final ListModel listModel;
  final bool includeFileNameTextField;
  final void Function(String filename, String markdown) onExport;

  const ExportListAsMarkdownDialog(
      {super.key,
      required this.listModel,
      required this.includeFileNameTextField,
      required this.onExport});

  @override
  State<ExportListAsMarkdownDialog> createState() =>
      _ExportListAsMarkdownDialogState();
}

class _ExportListAsMarkdownDialogState
    extends State<ExportListAsMarkdownDialog> {
  bool includeLabels = true;
  late final TextEditingController controller =
      TextEditingController(text: '${widget.listModel.title}.md');

  @override
  void initState() {
    super.initState();
    controller.selection = TextSelection(
        baseOffset: 0, extentOffset: controller.text.lastIndexOf('.'));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.includeFileNameTextField)
            TextField(controller: controller, autofocus: true),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Include Labels?'),
            Checkbox(
                value: includeLabels,
                onChanged: (newValue) =>
                    setState(() => includeLabels = newValue!))
          ])
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onExport(controller.text,
                  widget.listModel.asMarkdown(includeLabels: includeLabels));
            },
            child: const Text('Export'))
      ],
    );
  }
}
