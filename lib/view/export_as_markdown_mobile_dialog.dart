import 'dart:typed_data';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ExportAsMarkdownOnMobileDialog:
///   - Dialog for exporting the passed-in list model as a markdown file on mobile.
///   - When this dialog is closed, it will pass either true, false, or null to
///     `Navigator.pop`
class ExportAsMarkdownOnMobileDialog extends StatelessWidget {
  ExportAsMarkdownOnMobileDialog({super.key, required this.listModel});

  final ListModel listModel;
  late final TextEditingController controller =
      TextEditingController(text: '${listModel.title}.md');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(child: TextField(controller: controller)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () async {
              await DocumentFileSavePlus.saveFile(
                  Uint8List.fromList(listModel.asMarkdown().codeUnits),
                  controller.text,
                  'text/markdown');

              if (context.mounted) Navigator.pop(context, true);
            },
            child: const Text('Export'))
      ],
    );
  }
}
