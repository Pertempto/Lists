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
                  onPressed: () async {
                    Navigator.pop(context);
                    await widget.useItems(scannedItems);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Items')),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              persistentFooterButtons: [
                IconButton(
                    icon: const Icon(Icons.camera_alt),
                    tooltip: 'Retake Picture',
                    onPressed: () =>
                        availableCameras().then((cameras) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraPage(
                                    cameras: cameras,
                                    usePicture: (imageFile) => setState(() {
                                          scanItemsFuture =
                                              scanItems(imageFile);
                                        })))))),
                IconButton(
                    tooltip: 'Toggle whether all items are checkbox or text',
                    icon: const Icon(Icons.check_box),
                    onPressed: () => setState(() => scannedItems.forEach(
                        scannedItems.first.itemType == ItemType.checkbox
                            ? (element) {
                                element.itemType = ItemType.text;
                              }
                            : (element) {
                                element.itemType = ItemType.checkbox;
                              }))),
                IconButton(
                    tooltip: 'Discard',
                    icon: const Icon(Icons.cancel),
                    color: Colors.red,
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            description: 'Discard All Scanned Items?',
                            onConfirm: () => Navigator.pop(context)))),
              ],
            );
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
