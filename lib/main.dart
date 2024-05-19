import 'package:flutter/material.dart';

import 'linked_news.dart';
import 'saved_news.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haberler Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> news = List.generate(
    20,
    (index) => {
      'title': 'Haber Başlığı $index',
      'description': 'Haber açıklaması',
      'imageUrl': 'https://via.placeholder.com/150',
      'liked': false,
      'saved': false,
    },
  );

  List<Map<String, dynamic>> get likedNews =>
      news.where((item) => item['liked']).toList();
  List<Map<String, dynamic>> get savedNews =>
      news.where((item) => item['saved']).toList();

  static List<Widget> _pages(
      BuildContext context,
      List<Map<String, dynamic>> news,
      List<Map<String, dynamic>> likedNews,
      List<Map<String, dynamic>> savedNews) {
    return [
      Center(child: Text('Arama Sayfası')),
      Center(child: Text('Kategoriler Sayfası')),
      HomeScreen(news: news),
      SavedNewsScreen(news: savedNews),
      LikedNewsScreen(news: likedNews),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages(context, news, likedNews, savedNews)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // Bu satırı ekleyerek ikonları her zaman görünür yapıyoruz
        showSelectedLabels: false, // Seçili olan etiketleri gösterme
        showUnselectedLabels: false, // Seçili olmayan etiketleri gösterme
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
            icon: Icon(Icons.thumb_up),
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

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> news;

  HomeScreen({required this.news});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void toggleLike(int index) {
    setState(() {
      widget.news[index]['liked'] = !widget.news[index]['liked'];
    });
  }

  void toggleSave(int index) {
    setState(() {
      widget.news[index]['saved'] = !widget.news[index]['saved'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profileavatar.png'),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Olivia Wilson',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                ActionChip(label: Text('Trending'), onPressed: () {}),
                ActionChip(label: Text('For You'), onPressed: () {}),
                ActionChip(label: Text('Economics'), onPressed: () {}),
                ActionChip(label: Text('Politics'), onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.news.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.news[index]['title']),
                  subtitle: Text(widget.news[index]['description']),
                  leading: Image.network(widget.news[index]['imageUrl']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.news[index]['liked']
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          color:
                              widget.news[index]['liked'] ? Colors.black : null,
                        ),
                        onPressed: () => toggleLike(index),
                      ),
                      IconButton(
                        icon: Icon(
                          widget.news[index]['saved']
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color:
                              widget.news[index]['saved'] ? Colors.black : null,
                        ),
                        onPressed: () => toggleSave(index),
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
}
