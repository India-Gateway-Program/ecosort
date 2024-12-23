import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/scheduler.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.custom(
      enablePhysicalButton: true,
      builder: (CameraState state, Preview preview) {
        return Stack(
          children: [
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    state.when(
                      onPhotoMode: (photoCameraState) async {
                        final file = await photoCameraState.takePhoto();
                      },
                    );
                  } catch (e) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white.withOpacity(0.7),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
      saveConfig: SaveConfig.photo(),
    );
  }
}
