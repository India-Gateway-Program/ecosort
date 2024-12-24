import 'package:ecosort/enums/recyclability.dart';
import 'package:ecosort/widgets/history_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        HistoryTile(
            recyclability: Recyclability.recyclable,
            materialDescription: "Aluminium"),
      ],
    );
  }
}
