import 'package:flutter/material.dart';

class SavedNewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> news;
  final Function(int) onItemTapped;
  final Function(int) toggleSave;

  SavedNewsScreen(
      {required this.news,
        required this.onItemTapped,
        required this.toggleSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaydedilen Hikayeler'),
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
                news[index]['saved'] ? Icons.bookmark : Icons.bookmark_border,
                color: news[index]['saved'] ? Colors.black : null,
              ),
              onPressed: () => toggleSave(index),
            ),
          );
        },
      ),
    );
  }
}