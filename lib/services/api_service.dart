import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tometo_hub/models/remaining_date.dart';
import '../models/category.dart';
import '../models/video.dart';
import '../utils/api_controller.dart';

class ApiService {
  final String apiUrl = "https://tometohub.com/api/video/link";

  Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(Uri.parse(apiUrl),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
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

  Future<GetDate?> fetchDate() async {
    try {
      final data = await fetchData();
      return GetDate.fromJson(data);
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
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
