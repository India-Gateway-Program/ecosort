import 'package:ecosort/constants/borders.dart';
import 'package:ecosort/constants/colors.dart';
import 'package:ecosort/widgets/waste_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_proivder.dart';

class AssistScreen extends ConsumerStatefulWidget {
  const AssistScreen({super.key});

  @override
  ConsumerState<AssistScreen> createState() => _AssistScreenState();
}

class _AssistScreenState extends ConsumerState<AssistScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    final filteredCategories = categoriesAsyncValue.when(
      data: (categories) {
        if (query.isEmpty) {
          return categories;
        } else {
          return categories
              .where((category) =>
                  category.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      },
      error: (error, stack) => [],
      loading: () => [],
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, left: 25, right: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppBorders.small,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textColor,
                  blurRadius: 5.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: "Search in database",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (categoriesAsyncValue.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (categoriesAsyncValue.hasError)
                  const Center(
                    child: Text("Error loading categories"),
                  )
                else ...[
                  for (final category in filteredCategories)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: WasteTypeBadge(
                        title: category.name,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
