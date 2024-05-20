import 'package:aijam/Models/Story.dart';
import 'package:aijam/Screens/LoginScreen.dart';
import 'package:aijam/Screens/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> story;
  final Set<String> selectedCategories;
  final Function(String) onCategorySelected;
  final Function(int) toggleLike;
  final Function(int) toggleSave;

  StoryScreen(
      {required this.story,
        required this.selectedCategories,
        required this.onCategorySelected,
        required this.toggleLike,
        required this.toggleSave});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {

  void toggleLike(int index) {
    setState(() {
      widget.story[index].liked = !(widget.story[index].liked ?? false);
    });
  }

  void toggleSave(int index) {
    setState(() {
      widget.story[index].saved = !(widget.story[index].saved ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNews = widget.story
        .where((item) =>
    widget.selectedCategories.isEmpty ||
        widget.selectedCategories.contains(item.liked))
        .toList();

    FirebaseAuth.instance
        .idTokenChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserDetails(),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        // Bildirimler sayfasına yönlendirme
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        // Profil sayfasına yönlendirme
                        if(FirebaseAuth.instance.currentUser != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var category in [
                  'Fantasy',
                  'Mystery',
                  'Tragedy',
                  'Science Fiction',
                  'Thriller'
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      label: Text(category),
                      onPressed: () => widget.onCategorySelected(category),
                      backgroundColor:
                      widget.selectedCategories.contains(category)
                          ? Colors.blue
                          : Colors.grey[200],
                      labelStyle: TextStyle(
                          color: widget.selectedCategories.contains(category)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredNews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredNews[index].title),
                  //subtitle: Text("denemeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"),
                  subtitle: Text(filteredNews[index].description),
                  //leading: Image.network(filteredNews[index].description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          filteredNews[index].liked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                          filteredNews[index].liked ? Colors.red : null,
                        ),
                        onPressed: () => widget.toggleLike(index),
                      ),
                      IconButton(
                        icon: Icon(
                          filteredNews[index].saved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: filteredNews[index].saved
                              ? Colors.black
                              : null,
                        ),
                        onPressed: () => widget.toggleSave(index),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
        ],
      ),
    );
  }

  UserDetails() {
    if(FirebaseAuth.instance.currentUser != null){
      return Row(
        children: [
          CircleAvatar(
            backgroundImage:
            AssetImage('assets/images/profileavatar.png'),
          ),
          SizedBox(width: 8),
          Text(
            FirebaseAuth.instance.currentUser!.displayName ?? '',
            style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }else{
      return Row(
        children: [
          Text(
            'Giriş Yapın',
            style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }
}