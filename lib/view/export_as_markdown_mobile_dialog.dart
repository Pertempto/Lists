import 'dart:typed_data';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ExportAsMarkdownOnMobileDialog:
///   - Dialog for exporting the passed-in list model as a markdown file on mobile.
///   - When this dialog is closed, it will pass either true, false, or null to
///     `Navigator.pop`
class ExportAsMarkdownOnMobileDialog extends StatefulWidget {
  ExportAsMarkdownOnMobileDialog({super.key, required this.listModel});

  final ListModel listModel;

  @override
  State<ExportAsMarkdownOnMobileDialog> createState() =>
      _ExportAsMarkdownOnMobileDialogState();
}

class _ExportAsMarkdownOnMobileDialogState
    extends State<ExportAsMarkdownOnMobileDialog> {
  bool includeLabels = true;

  late final TextEditingController controller =
      TextEditingController(text: '${widget.listModel.title}.md');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(child: TextField(controller: controller)),
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
            onPressed: () async {
              await DocumentFileSavePlus.saveFile(
                  Uint8List.fromList(widget.listModel
                      .asMarkdown(includeLabels: includeLabels)
                      .codeUnits),
                  controller.text,
                  'text/markdown');

              if (context.mounted) Navigator.pop(context, true);
            },
            child: const Text('Export'))
      ],
    );
  }
}
