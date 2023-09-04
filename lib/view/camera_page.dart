import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';

// TODO: doc and manage cam lifetime
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final void Function(XFile) usePicture;
  const CameraPage(
      {super.key, required this.cameras, required this.usePicture});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  bool hasError = false;
  bool takingPicture = false;

  Future<void> _initCameraController(CameraDescription camera) async {
    controller =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    try {
      await controller.initialize();
    } on CameraException {
      hasError = true;
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initCameraController(widget.cameras.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          Expanded(child: _buildCameraPreview()),
          //TODO fix for flipped screens.
          Container(
              width: double.infinity,
              height: 100,
              child: Center(
                child: !takingPicture
                    ? FloatingActionButton(
                        onPressed: controller.value.isInitialized
                            ? () async {
                                setState(() => takingPicture = true);
                                final picture = await controller.takePicture();
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                                widget.usePicture(picture);
                              }
                            : null,
                        child: const Icon(Icons.camera_alt))
                    : const FloatingActionButton(
                        onPressed: null, child: CircularProgressIndicator()),
              ))
        ],
      ),
    ]));
  }

  Widget _buildCameraPreview() {
    if (controller.value.isInitialized) {
      return CameraPreview(controller);
    } else if (hasError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.error, color: Colors.red),
          Text('Camera Error', style: TextStyle(color: Colors.red)),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraController(controller.description);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}