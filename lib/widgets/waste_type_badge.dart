import 'package:ecosort/constants/borders.dart';
import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';

class WasteTypeBadge extends StatelessWidget {
  final String title;
  final double topPadding;

  const WasteTypeBadge({super.key, required this.title, this.topPadding = 10});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: AppBorders.small,
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
