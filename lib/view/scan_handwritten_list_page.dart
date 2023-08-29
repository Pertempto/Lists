import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/camera_page.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// TODO: doc and better name
class ScanHandwrittenListPage extends StatefulWidget {
  final Future<void> Function(List<Item> items) useItems;
  const ScanHandwrittenListPage({super.key, required this.useItems});

  @override
  State<ScanHandwrittenListPage> createState() =>
      _ScanHandwrittenListPageState();
}

class _ScanHandwrittenListPageState extends State<ScanHandwrittenListPage> {
  Future<List<Item>>? scanItemsFuture;

  Future<List<Item>> scanItems(XFile imageFile) async {
    final recognizedText = await TextRecognizer()
        .processImage(InputImage.fromFilePath(imageFile.path));

    return recognizedText.blocks
        .expand((block) => block.lines)
        .map((textLine) => Item(textLine.text))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: improve OCR, allow for final picture edits.
    return Scaffold(
        body: scanItemsFuture == null
            ? Center(
                child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 60.0),
                    onPressed: () async {
                      final cameras = await availableCameras();
                      if (!mounted) return;
                      final imageFile = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CameraPage(cameras: cameras)));

                      scanItemsFuture = scanItems(imageFile);

                      setState(() {});
                    }))
            : FutureBuilder(
                future: scanItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        children: snapshot.data!
                            .map((item) => ListTile(title: Text(item.value)))
                            .toList());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }));
  }
}
