import 'dart:convert';
import 'package:ecosort/providers/question_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class Answer {
  final int id;
  final int materialConditionId;
  final String type;
  final String text;
  final int questionId;

  Answer({
    required this.id,
    required this.materialConditionId,
    required this.type,
    required this.text,
    required this.questionId,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      materialConditionId: json['material_condition_id'],
      type: json['type'],
      text: json['text'],
      questionId: json['question_id'],
    );
  }
}

final questionAnswerProvider =
    FutureProvider.family<List<Answer>?, int>((ref, int questionId) async {
  final response = await http.get(
    Uri.parse('${Config.baseUrl}questions-answers?question_id=$questionId'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final answers = data['answers'] as List<dynamic>;

    if (answers.isNotEmpty) {
      return answers.map((e) => Answer.fromJson(e)).toList();
    }

    return null;
  }
  throw Exception('Failed to load question answers.');
});

Future<Question?> fetchQuestion({required int categoryId}) async {
  final container = ProviderContainer();
  return await container.read(questionProvider(categoryId).future);
}