import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<Category> fromJsonList(String str) {
    final jsonData = json.decode(str) as List;
    return jsonData.map((data) => Category.fromJson(data)).toList();
  }
}

Future<List<Category>> fetchCategories() async {
  const String apiUrl = 'http://192.168.178.234:8000/api/categories/';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return Category.fromJsonList(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return await fetchCategories();
});
