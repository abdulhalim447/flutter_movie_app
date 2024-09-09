import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/video.dart';

class ApiService {
  final String apiUrl = "https://tometohub.com/api/video/link";

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final data = await fetchData();
    List<dynamic> categoriesJson = data['categorys'];
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Video>> fetchVideosByCategory(String categoryId) async {
    final data = await fetchData();
    List<dynamic> videosJson = data['video'];
    return videosJson
        .where((video) => video['category_id'] == categoryId)
        .map((json) => Video.fromJson(json))
        .toList();
  }
}
