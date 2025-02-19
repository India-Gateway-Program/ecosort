import 'package:ecosort/constants/borders.dart';
import 'package:ecosort/constants/colors.dart';
import 'package:ecosort/pages/scan_result.dart';
import 'package:ecosort/widgets/modal_bottom_shett.dart';
import 'package:ecosort/widgets/waste_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';
import '../providers/question_answer_provider.dart';

class AssistScreen extends ConsumerStatefulWidget {
  const AssistScreen({super.key});

  @override
  ConsumerState<AssistScreen> createState() => _AssistScreenState();
}

class _AssistScreenState extends ConsumerState<AssistScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: "Search in database",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      query = '';
                      _controller.clear();
                    });
                  },
                ),
                filled: true,
                border: const OutlineInputBorder(),
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
                    FutureBuilder(
                        future: fetchQuestion(categoryId: category.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data != null) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return QuestionModalBottomSheet(
                                          question: snapshot.data?.text ?? '',
                                          description:
                                              snapshot.data?.description ?? '',
                                        );
                                      },
                                    );
                                  },
                                  child: WasteTypeBadge(
                                    title: category.name,
                                  ),
                                ),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScanResultScreen(
                                          categoryId: category.id,
                                          categoryName: category.name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: WasteTypeBadge(
                                    title: category.name,
                                  ),
                                ),
                              );
                            }
                          }
                          return Container();
                        })
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
