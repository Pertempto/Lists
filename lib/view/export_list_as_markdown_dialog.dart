import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

/// ExportListAsMarkdownDialog:
///   - Dialog for exporting the passed-in list model as a markdown file on mobile.
///   - When this dialog is closed, it will pass either true, false, or null to
///     `Navigator.pop`
class ExportListAsMarkdownDialog extends StatefulWidget {
  final ListModel listModel;

  const ExportListAsMarkdownDialog({super.key, required this.listModel});

  @override
  State<ExportListAsMarkdownDialog> createState() =>
      _ExportListAsMarkdownDialogState();
}

class _ExportListAsMarkdownDialogState
    extends State<ExportListAsMarkdownDialog> {
  bool includeLabels = true;
  late final TextEditingController fileNameController =
      TextEditingController(text: '${widget.listModel.title}.md');

  @override
  void initState() {
    super.initState();
    fileNameController.selection = TextSelection(
        baseOffset: 0, extentOffset: fileNameController.text.lastIndexOf('.'));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (Platform.isAndroid || Platform.isIOS)
            // a Textfield to enter the file name on android and ios (see _onExport())
            TextField(controller: fileNameController, autofocus: true),
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
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              if (await Permission.manageExternalStorage.request().isGranted) {
                final fileName = fileNameController.text;
                try {
                  final filePath = await _saveFile(fileName: fileName);
                  if (filePath != null) {
                    final markdown = widget.listModel
                        .asMarkdown(includeLabels: includeLabels);
                    await File(filePath).writeAsString(markdown);
                    scaffoldMessenger.showSnackBar(const SnackBar(
                        content: Text('Exported as Markdown successfully')));
                  }
                } on IOException catch (e) {
                  // report any io errors to the user
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text('Error, couldn\'t export as markdown: $e',
                          style: const TextStyle(color: Colors.red))));
                }
              }
            },
            child: const Text('Export'))
      ],
    );
  }

  Future<String?> _saveFile({required String fileName}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      // `FilePicker.saveFile` isn't supported on android/ios
      final dirPath = await FilePicker.platform.getDirectoryPath();
      return dirPath != null ? join(dirPath, fileName) : null;
    } else {
      return await FilePicker.platform.saveFile(
          fileName: fileName, type: FileType.custom, allowedExtensions: ['md']);
    }
  }
}
