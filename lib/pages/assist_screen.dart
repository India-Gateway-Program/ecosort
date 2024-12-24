import 'package:ecosort/constants/borders.dart';
import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssistScreen extends ConsumerWidget {
  const AssistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: EdgeInsets.only(top: 100, left: 25, right: 25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorders.small,
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor,
                blurRadius: 5.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: "search",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: AppBorders.small,
              ),
            ),
          ),
        ));
  }
}
