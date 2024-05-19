import 'package:flutter/material.dart';


class SavedNewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> news;

  SavedNewsScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaydedilen Haberler'),
      ),
      body: ListView.separated(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(news[index]['title']),
            subtitle: Text(news[index]['description']),
            leading: Image.network(news[index]['imageUrl']),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
