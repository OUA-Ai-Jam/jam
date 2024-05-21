import 'package:flutter/material.dart';
import 'package:aijam/Models/Story.dart';
import 'package:aijam/Screens/CategoriesScreen.dart';
import 'package:aijam/Screens/LikedNewsScreen.dart';
import 'package:aijam/Screens/SavedNewsScreen.dart';
import 'package:aijam/Screens/StoryScreen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Story> story = [];

  Future<String?> aiText() async {
    String duzenlenmis = "";
    final model = GenerativeModel(
        model: 'gemini-pro', apiKey: "AIzaSyA1GDMT85HNnsaCO6avc0zTGE-skFwowSU");

    final prompt =
        "Sıradışı 2 tane hikaye yazın. Başlık ve hikayenin kendisi (yaklaşık 300 kelime olmalı) ve anahtar kelimeler (json formatında olmalı) ve ilgi çekici 100 harfi geçmeyen bir açıklama cümlesi olarak ayırmanı ve bunları json formatında dizi olarak istiyorum. Jsonda title,story ,description ve keywords olacak.";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    duzenlenmis = response.text!.replaceAll('```', '');
    duzenlenmis = duzenlenmis.replaceAll('json', '');

    print(duzenlenmis);
    return duzenlenmis;
  }

  void _fetchAndParseStories() async {
    try {
      final responseText = await aiText();

      if (responseText != null) {
        setState(() {
          story = storyFromJson(responseText);
        });
      } else {
        print('Error: No data received from the AI model.');
      }
    } catch (error) {
      print('Error fetching stories: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAndParseStories();
  }

  int _selectedIndex = 2;
  Set<String> _selectedCategories = {};

  List<Story> get likedStories => story.where((item) => item.liked).toList();
  List<Story> get savedStories => story.where((item) => item.saved).toList();

  List<Story> get filteredStories {
    if (_selectedCategories.isEmpty) {
      return story;
    } else {
      return story
          .where((item) => _selectedCategories
              .any((category) => item.keywords.contains(category)))
          .toList();
    }
  }

  static List<Widget> _pages(
      BuildContext context,
      List<Story> story,
      List<Story> likedStories,
      List<Story> savedStories,
      Set<String> selectedCategories,
      Function(String) onCategorySelected,
      Function(int) onItemTapped,
      Function(int) toggleLike,
      Function(int) toggleSave) {
    return [
      Center(child: Text('Arama Sayfası')),
      CategoriesScreen(
          onCategorySelected: onCategorySelected,
          selectedCategories: selectedCategories),
      StoryScreen(
          story: story,
          selectedCategories: selectedCategories,
          onCategorySelected: onCategorySelected,
          toggleLike: toggleLike,
          toggleSave: toggleSave),
      SavedNewsScreen(
          stories: savedStories,
          onItemTapped: onItemTapped,
          toggleSave: (int index) {
            final storyIndex = story.indexOf(savedStories[index]);
            toggleSave(storyIndex);
          }),
      LikedNewsScreen(
          stories: likedStories,
          onItemTapped: onItemTapped,
          toggleLike: (int index) {
            final storyIndex = story.indexOf(likedStories[index]);
            toggleLike(storyIndex);
          }),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _selectedIndex = 2; // Ana sayfaya dön
    });
  }

  void _toggleLike(int index) {
    setState(() {
      story[index].liked = !story[index].liked;
    });
  }

  void _toggleSave(int index) {
    setState(() {
      story[index].saved = !story[index].saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (story.isNotEmpty) {
      return Scaffold(
        body: _pages(
            context,
            filteredStories,
            likedStories,
            savedStories,
            _selectedCategories,
            _onCategorySelected,
            _onItemTapped,
            _toggleLike,
            _toggleSave)[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Arama',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Kategoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Kaydedilenler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Beğenilenler',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      );
    } else {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }
}
