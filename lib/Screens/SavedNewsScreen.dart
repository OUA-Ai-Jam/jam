import 'package:flutter/material.dart';
import 'package:aijam/Models/Story.dart';

class SavedNewsScreen extends StatelessWidget {
  final List<Story> stories;
  final Function(int) onItemTapped;
  final Function(int) toggleSave;

  SavedNewsScreen({
    required this.stories,
    required this.onItemTapped,
    required this.toggleSave,
  });

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
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(stories[index].title),
            subtitle: Text(stories[index].description),
            leading: Image.network(stories[index].imageUrl),
            trailing: IconButton(
              icon: Icon(
                stories[index].saved ? Icons.bookmark : Icons.bookmark_border,
                color: stories[index].saved ? Colors.black : null,
              ),
              onPressed: () => toggleSave(
                  index), // Ana hikaye listesindeki doğru indeksi kullan
            ),
          );
        },
      ),
    );
  }
}
