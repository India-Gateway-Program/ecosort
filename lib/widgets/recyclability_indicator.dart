import 'package:ecosort/enums/recyclability.dart';
import 'package:flutter/material.dart';

class RecyclabilityIndicator extends StatelessWidget {
  final Recyclability recyclability;

  const RecyclabilityIndicator({super.key, required this.recyclability});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: recyclability.color,
          size: 15,
        ),
        SizedBox(width: 8),
        Text(
          recyclability.title,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
