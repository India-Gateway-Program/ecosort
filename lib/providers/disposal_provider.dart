import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class DisposalRule {
  final String disposalMethod;
  final String descriptionDE;
  final String descriptionIN;
  final int id;

  DisposalRule(
      {required this.disposalMethod,
      required this.id,
      this.descriptionDE = '',
      this.descriptionIN = ''});

  factory DisposalRule.fromJson(Map<String, dynamic> json) {
    return DisposalRule(
      disposalMethod: json['disposal_method'] as String,
      descriptionDE: json['description_de'] as String,
      descriptionIN: json['description_in'] as String,
      id: json['id'] as int,
    );
  }
}

final disposalProvider =
    FutureProvider.family<List<DisposalRule>, Map<String, int?>>(
        (ref, params) async {
  final categoryId = params['category_id']!;
  final materialConditionId = params['material_condition_id'];

  final queryParameters = {
    'category_id': categoryId.toString(),
    if (materialConditionId != null)
      'material_condition_id': materialConditionId.toString(),
  };

  final uri = Uri.parse('${Config.baseUrl}disposal-rule/')
      .replace(queryParameters: queryParameters);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => DisposalRule.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load disposal rules');
  }
});
