import 'package:ecosort/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Question {
  final int id;
  final String text;
  final String description;

  Question({
    required this.id,
    required this.text,
    required this.description,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['question_text'] as String,
      description: json['question_description'] as String,
    );
  }
}

final questionProvider =
    FutureProvider.family<Question?, int>((ref, int categoryId) async {
  final response = await http.get(
    Uri.parse(
        '${Config.baseUrl}questions-by-category/?category_id=$categoryId'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final questions = data['questions'] as List<dynamic>;

    if (questions.isNotEmpty) {
      return Question.fromJson(questions[0]);
    }

    return null;
  }
  throw Exception('Failed to load question description.');
});
