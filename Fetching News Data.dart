import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Article>> fetchNews() async {
  final response = await http.get(Uri.parse('YOUR_NEWS_API_ENDPOINT'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['articles'];
    return data.map((json) => Article.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

class Article {
  final String title;
  final String description;
  final String imageUrl;

  Article({required this.title, required this.description, required this.imageUrl});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      imageUrl: json['urlToImage'],
    );
  }
}
