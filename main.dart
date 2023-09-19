import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  Future<List<Article>> fetchNews() async {
    final apiUrl = Uri.parse('YOUR_NEWS_API_ENDPOINT');

    final response = await http.get(apiUrl); // Make the HTTP request

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articles'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(articles[index].title),
                  subtitle: Text(articles[index].description),
                  leading: Image.network(articles[index].imageUrl),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String imageUrl;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      imageUrl: json['urlToImage'],
    );
  }
}
