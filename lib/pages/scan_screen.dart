import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CameraAwesomeBuilder.custom(
      sensorConfig: SensorConfig.single(SensorPosition.back), // Added this
      enablePhysicalButton: true,
      builder: (CameraState state, Preview preview) {
        return Stack(
          children: [
            Positioned.fill(child: preview), // Ensure camera preview is visible
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: ElevatedButton(
                onPressed: () async {
                  if (state is PhotoCameraState) {
                    try {
                      final file = await (state as PhotoCameraState).takePhoto();
                      print("Photo saved: ${file.path}");
                    } catch (e) {
                      showError(context, e.toString());
                    }
                  } else {
                    showError(context, "Camera is not in photo mode!");
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

void showError(BuildContext context, String message) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  });
}