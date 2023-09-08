import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/camera_page.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lists/view/confirmation_dialog.dart';
import 'package:lists/view/item_widget.dart';

// HandwrittenItemsExtractionPage:
//  - UI to extract items from handwritten lists and use those items
class HandwrittenItemsExtractionPage extends StatefulWidget {
  final Future<void> Function(List<Item> items) useItems;
  const HandwrittenItemsExtractionPage({super.key, required this.useItems});

  @override
  State<HandwrittenItemsExtractionPage> createState() =>
      _HandwrittenItemsExtractionPageState();
}

class _HandwrittenItemsExtractionPageState
    extends State<HandwrittenItemsExtractionPage> {
  Future<void>? scanItemsFuture;
  late List<Item> scannedItems;

  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _loadCameras().then((_) => _pushCameraPage());
  }

  Future<void> _loadCameras() async => cameras = await availableCameras();
  Future<void> _pushCameraPage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CameraPage(
              cameras: cameras,
              usePicture: (imageFile) =>
                  // NOTE:
                  // We cannot turn the function passed to setState into an arrow function, like:
                  //   setState(() => scanItemsFuture = extractItems(imageFile))
                  // because that is equivalent to:
                  //   setState(() {
                  //     return scanItemsFuture = extractItems(imageFile));
                  //   })
                  // which returns scanItemsFuture, and setState throws if the function passed to it returns a future.
                  // Giving the function a block body with no return statement avoids this problem.
                  setState(() {
                    scanItemsFuture = _extractItems(imageFile);
                  }))));

  Future<void> _extractItems(XFile imageFile) async {
    final recognizedText = await TextRecognizer()
        .processImage(InputImage.fromFilePath(imageFile.path));

    scannedItems = recognizedText.blocks
        .expand((block) => block.lines)
        .map((textLine) => Item(textLine.text))
        .toList();

    if (scannedItems.isEmpty && mounted) {
      await _showNoTextDetectedDialog();
    }
  }

  Future<void> _showNoTextDetectedDialog() async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('No text detected. Retake?'),
            actions: [
              TextButton(
                  onPressed: () {
                    // pop both the "no text detected dialog" and the scan handwritten list page
                    // when cancelling. It would be useless to have an empty results page that
                    // the user needs to close.
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(Colors.red)),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pushCameraPage();
                  },
                  child: const Text('Retake'))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    // TODO: improve OCR, allow for final picture edits.
    return FutureBuilder(
        future: scanItemsFuture,
        builder: (context, snapshot) => snapshot.connectionState !=
                ConnectionState.done
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : Scaffold(
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
                persistentFooterAlignment: AlignmentDirectional.center,
                persistentFooterButtons: [
                  IconButton(
                      tooltip: 'Discard',
                      icon: const Icon(Icons.cancel),
                      color: Colors.red,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                              description: 'Discard All Scanned Items?',
                              onConfirm: () => Navigator.pop(context)))),
                  IconButton(
                      icon: const Icon(Icons.camera_alt),
                      tooltip: 'Retake Picture',
                      onPressed: _pushCameraPage),
                  IconButton(
                      tooltip: 'Toggle whether all items are checkbox or text',
                      icon: const Icon(Icons.check_box),
                      onPressed: () => setState(() {
                            // set the new item type to the opposite of a sample item's type (i.e., toggle itemType).
                            final newItemType =
                                scannedItems.first.itemType == ItemType.checkbox
                                    ? ItemType.text
                                    : ItemType.checkbox;
                            for (final item in scannedItems) {
                              item.itemType = newItemType;
                            }
                          })),
                ],
              ));
  }
}
