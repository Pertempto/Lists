import 'dart:io';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';

/// ExportListAsMarkdownDialog:
///   - Dialog for exporting the passed-in list model as a markdown file on mobile.
///   - When this dialog is closed, it will pass either true, false, or null to
///     `Navigator.pop`
class ExportListAsMarkdownDialog extends StatefulWidget {
  final ListModel listModel;
  final void Function() onSuccessfulExport;

  const ExportListAsMarkdownDialog(
      {super.key, required this.listModel, required this.onSuccessfulExport});

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
          if (Platform.isAndroid || Platform.isIOS)
            TextField(controller: controller, autofocus: true),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Include Labels'),
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
              _onExport();
            },
            child: const Text('Export'))
      ],
    );
  }

  void _onExport() async {
    final markdown = widget.listModel.asMarkdown(includeLabels: includeLabels);
    final filename = controller.text;
    // We have to have to use a different package for mobile and desktop
    // because the file_picker package (https://pub.dev/packages/file_picker) only
    // supports saving files in desktop (with a native file picker). This package
    // seemed far superior to its competitors.
    if (Platform.isAndroid || Platform.isIOS) {
      await DocumentFileSavePlus.saveFile(
          Uint8List.fromList(markdown.codeUnits), filename, 'text/markdown');
      widget.onSuccessfulExport();
    } else {
      final filePath = await FilePicker.platform.saveFile(
          fileName: filename, type: FileType.custom, allowedExtensions: ['md']);

      if (filePath != null) {
        await File(filePath).writeAsString(markdown);
        widget.onSuccessfulExport();
      }
    }
  }
}
