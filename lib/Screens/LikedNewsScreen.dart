import 'package:flutter/material.dart';
import 'package:aijam/Models/Story.dart';

class LikedNewsScreen extends StatelessWidget {
  final List<Story> stories;
  final Function(int) onItemTapped;
  final Function(int) toggleLike;

  LikedNewsScreen(
      {required this.stories,
      required this.onItemTapped,
      required this.toggleLike});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beğenilen Hikayeler'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            onItemTapped(2); // Ana sayfaya dön
          },
        ),
      ),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(stories[index].title),
            subtitle: Text(stories[index].description),
            trailing: IconButton(
              icon: Icon(
                stories[index].liked ? Icons.favorite : Icons.favorite_border,
                color: stories[index].liked ? Colors.red : null,
              ),
              onPressed: () => toggleLike(index),
            ),
          );
        },
      ),
    );
  }
}
