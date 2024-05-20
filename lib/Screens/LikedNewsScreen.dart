import 'package:flutter/material.dart';

class LikedNewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> news;
  final Function(int) onItemTapped;
  final Function(int) toggleLike;

  LikedNewsScreen(
      {required this.news,
        required this.onItemTapped,
        required this.toggleLike});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beğeniler'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            onItemTapped(2); // Ana sayfaya dön
          },
        ),
      ),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(news[index]['title']),
            subtitle: Text(news[index]['description']),
            leading: Image.network(news[index]['imageUrl']),
            trailing: IconButton(
              icon: Icon(
                news[index]['liked'] ? Icons.favorite : Icons.favorite_border,
                color: news[index]['liked'] ? Colors.red : null,
              ),
              onPressed: () => toggleLike(index),
            ),
          );
        },
      ),
    );
  }
}
