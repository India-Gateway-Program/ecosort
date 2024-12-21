import 'package:ecosort/enums/recyclability.dart';
import 'package:ecosort/widgets/history_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HistoryTile(recyclability: Recyclability.recyclable, materialDescription: "Aluminium"),
      ],
    );
  }
}