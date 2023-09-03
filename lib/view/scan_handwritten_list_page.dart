import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/camera_page.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lists/view/confirmation_dialog.dart';
import 'package:lists/view/item_widget.dart';
import 'package:lists/view/submit_button.dart';

// TODO: doc and better name
class ScanHandwrittenListPage extends StatefulWidget {
  final Future<void> Function(List<Item> items) useItems;
  const ScanHandwrittenListPage({super.key, required this.useItems});

  @override
  State<ScanHandwrittenListPage> createState() =>
      _ScanHandwrittenListPageState();
}

class _ScanHandwrittenListPageState extends State<ScanHandwrittenListPage> {
  Future<void>? scanItemsFuture;
  late List<Item> scannedItems;

  Future<void> scanItems(XFile imageFile) async {
    final recognizedText = await TextRecognizer()
        .processImage(InputImage.fromFilePath(imageFile.path));

    scannedItems = recognizedText.blocks
        .expand((block) => block.lines)
        .map((textLine) => Item(textLine.text))
        .toList();

    if (scannedItems.isEmpty) {
      if (mounted) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('No text detected. Retake?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          availableCameras().then((cameras) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraPage(
                                      cameras: cameras,
                                      usePicture: (imageFile) => setState(() {
                                            scanItemsFuture =
                                                scanItems(imageFile);
                                          })))));
                        },
                        child: const Text('Retake'))
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraPage(
                cameras: cameras,
                usePicture: (imageFile) => setState(() {
                      scanItemsFuture = scanItems(imageFile);
                    })))));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: improve OCR, allow for final picture edits.
    return FutureBuilder(
        future: scanItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: ListView(
                  children: scannedItems
                      .map((item) => ItemWidget(item,
                          onDelete: () =>
                              setState(() => scannedItems.remove(item)),
                          onEdited: () => setState(() {})))
                      .toList()),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: _showAddItemsDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Items')),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  void _showAddItemsDialog() {
    showDialog(
        context: context,
        builder: (context) => GIVEMEANAME(
            initialAreCheckbox: scannedItems.every(
                    (item) => scannedItems.first.itemType == item.itemType)
                ? scannedItems.first.itemType == ItemType.checkbox
                : null,
            onSubmit: (areCheckbox) async {
              Navigator.pop(context);
              await widget.useItems(areCheckbox != null
                  ? (scannedItems
                    ..forEach((item) => item.itemType =
                        areCheckbox ? ItemType.checkbox : ItemType.text))
                  : scannedItems);
            }));
  }
}

class GIVEMEANAME extends StatefulWidget {
  final void Function(bool?) onSubmit;
  const GIVEMEANAME(
      {super.key, required this.initialAreCheckbox, required this.onSubmit});

  final bool? initialAreCheckbox;

  @override
  State<GIVEMEANAME> createState() => _GIVEMEANAMEState();
}

class _GIVEMEANAMEState extends State<GIVEMEANAME> {
  late bool? areCheckbox = widget.initialAreCheckbox;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Final Edits'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Checkbox?'),
            Checkbox(
              value: areCheckbox,
              onChanged: (newAreCheckbox) =>
                  setState(() => areCheckbox = newAreCheckbox),
              tristate: areCheckbox == null,
            )
          ],
        )
      ]),
      actions: [
        SubmitButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(areCheckbox);
          },
        )
      ],
    );
  }
}
