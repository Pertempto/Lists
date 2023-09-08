import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// CameraPage:
//  - a page where the user can use their camera to take a picture
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final void Function(XFile) usePicture;
  const CameraPage(
      {super.key, required this.cameras, required this.usePicture});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraController controller;
  bool hasError = false;
  bool takingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCameraController(widget.cameras[0]);
  }

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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? Scaffold(
                  body: Stack(children: [
                  Column(
                    children: [
                      Expanded(child: _buildCameraPreview()),
                      SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Center(
                            child: takingPicture
                                ? const FloatingActionButton(
                                    onPressed: null,
                                    child: CircularProgressIndicator())
                                : FloatingActionButton(
                                    onPressed: controller.value.isInitialized
                                        ? _takePicture
                                        : null,
                                    child: const Icon(Icons.camera_alt)),
                          ))
                    ],
                  ),
                ]))
              : const SizedBox(),
    );
  }

  Widget _buildCameraPreview() {
    if (controller.value.isInitialized) {
      return CameraPreview(controller);
    } else if (hasError) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          Text('Camera Error', style: TextStyle(color: Colors.red)),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> _takePicture() async {
    setState(() => takingPicture = true);
    final picture = await controller.takePicture();
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    if (mounted) Navigator.pop(context);
    widget.usePicture(picture);
  }

  // For why this is needed, see https://pub.dev/packages/camera#handling-lifecycle-states
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
