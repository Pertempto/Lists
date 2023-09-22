import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
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
            // a Textfield to enter the file name on android and ios (see _onExport())
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
            onPressed: () async {
              final capturedScaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              if (await Permission.storage.request() !=
                  PermissionStatus.granted) {
                return;
              }

              final markdown =
                  widget.listModel.asMarkdown(includeLabels: includeLabels);
              final filename = controller.text;
              final filePath = Platform.isAndroid || Platform.isIOS
                  ? (dirPath) {
                      return dirPath != null ? dirPath + '/$filename' : null;
                    }(await FilePicker.platform
                      .getDirectoryPath()) // `FilePicker.saveFile` isn't supported on android/ios'
                  : await FilePicker.platform.saveFile(
                      fileName: filename,
                      type: FileType.custom,
                      allowedExtensions: ['md']);

              if (filePath != null) {
                await File(filePath).writeAsString(markdown);
                capturedScaffoldMessenger.showSnackBar(const SnackBar(
                    content: Text('Exported as Markdown successfully')));
              }
            },
            child: const Text('Export'))
      ],
    );
  }
}
