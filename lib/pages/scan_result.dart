import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/disposal_provider.dart';

class ScanResultScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final int categoryId;
  final int? materialConditionId;

  const ScanResultScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    this.materialConditionId,
  });

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultState();
}

class _ScanResultState extends ConsumerState<ScanResultScreen> {
  final Map<int, String> categoryImages = {
    2: 'assets/images/recovered_paper.jpg',
    5: 'assets/images/old_glass.jpg',
    1: 'assets/images/residential_waste.jpg',
    6: 'assets/images/plastic-waste-recycling.jpg'
  };

  @override
  Widget build(BuildContext context) {
    Future<DisposalRule?> fetchDisposalRule(WidgetRef ref,
        {required int categoryId, int? materialConditionID}) async {
      final params = {
        'category_id': categoryId,
        'material_condition_id': materialConditionID
      };
      final rules = await ref.read(disposalProvider(params).future);
      return rules.isNotEmpty ? rules.first : null;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchDisposalRule(ref, categoryId: widget.categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          var data = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.categoryName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'How to dispose of properly',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      categoryImages[data?.id]!,
                      height: 200,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data!.disposalMethod,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data.description,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
