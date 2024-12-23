import 'package:flutter/cupertino.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.custom(
      builder: (CameraState state, Preview preview) {
        return Row(
          children: [],
        );
      },
      saveConfig: SaveConfig.photo(),
    );
  }
}
