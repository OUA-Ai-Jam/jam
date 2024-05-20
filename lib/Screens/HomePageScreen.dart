import 'package:aijam/Screens/CategoriesScreen.dart';
import 'package:aijam/Screens/LikedNewsScreen.dart';
import 'package:aijam/Screens/SavedNewsScreen.dart';
import 'package:aijam/Screens/StoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  Future<void> aiText() async {
    try{
      final model = GenerativeModel(model: 'gemini-pro', apiKey: "AIzaSyA1GDMT85HNnsaCO6avc0zTGE-skFwowSU");

      final prompt = "Sihirli bir sırt çantasıyla ilgili bir hikaye yazın. Başlık ve hikayenin kendisi ve anahtar kelimeler ve ilgi çekici 100 harfi geçmeyen bir açıklama olarak ayırmanı ve bunları json formatında istiyorum. Jsonda title,story ,description ve keywords olacak.";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      print(response.text);
    }catch(e){
      print(e);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aiText();
  }

  int _selectedIndex = 2;
  Set<String> _selectedCategories = {};
  List<Map<String, dynamic>> news = List.generate(
    20,
        (index) => {
      'title': 'Haber Başlığı $index',
      'description': 'Haber açıklaması',
      'category': [
        'Fantasy',
        'Mystery',
        'Tragedy',
        'Science Fiction',
        'Thriller'
      ][index % 5],
      'imageUrl': 'https://via.placeholder.com/150',
      'liked': false,
      'saved': false,
    },
  );

  List<Map<String, dynamic>> get likedNews =>
      news.where((item) => item['liked']).toList();
  List<Map<String, dynamic>> get savedNews =>
      news.where((item) => item['saved']).toList();

  List<Map<String, dynamic>> get filteredNews {
    if (_selectedCategories.isEmpty) {
      return news;
    } else {
      return news
          .where((item) => _selectedCategories.contains(item['category']))
          .toList();
    }
  }

  static List<Widget> _pages(
      BuildContext context,
      List<Map<String, dynamic>> news,
      List<Map<String, dynamic>> likedNews,
      List<Map<String, dynamic>> savedNews,
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
          news: news,
          selectedCategories: selectedCategories,
          onCategorySelected: onCategorySelected,
          toggleLike: toggleLike,
          toggleSave: toggleSave),
      SavedNewsScreen(
          news: savedNews, onItemTapped: onItemTapped, toggleSave: toggleSave),
      LikedNewsScreen(
          news: likedNews, onItemTapped: onItemTapped, toggleLike: toggleLike),
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
      news[index]['liked'] = !news[index]['liked'];
    });
  }

  void _toggleSave(int index) {
    setState(() {
      news[index]['saved'] = !news[index]['saved'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages(
          context,
          filteredNews,
          likedNews,
          savedNews,
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
  }
}
