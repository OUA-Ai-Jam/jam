import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const _apiKey = 'YOUR_NEWSAPI_KEY';
  static const _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Map<String, dynamic>>> fetchNews() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?country=us&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List)
          .map((article) => {
                'title': article['title'],
                'description': article['description'],
                'imageUrl':
                    article['urlToImage'] ?? 'https://via.placeholder.com/150',
              })
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
