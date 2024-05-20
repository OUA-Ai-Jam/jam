import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<Map<String, dynamic>> news = [];

  final NewsService _newsService = NewsService();
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final fetchedNews = await _newsService.fetchNews();
      print('Fetched news: $fetchedNews'); // Debug için ekleyelim

      final updatedNews = await Future.wait(fetchedNews.map((newsItem) async {
        try {
          final updatedTitle = await _geminiService
              .getUpdatedText('Rewrite the news title: ${newsItem['title']}');
          final updatedDescription = await _geminiService.getUpdatedText(
              'Rewrite the news description: ${newsItem['description']}');
          return {
            'title': updatedTitle,
            'description': updatedDescription,
            'imageUrl': newsItem['imageUrl'],
          };
        } catch (e) {
          print('Failed to update news item: $e');
          return newsItem; // Orijinal haber verisini döndür
        }
      }));

      setState(() {
        news = updatedNews;
      });
      print('Updated news: $updatedNews'); // Debug için ekleyelim
    } catch (error) {
      print('Failed to load news: $error');
    }
  }

  List<Map<String, dynamic>> get likedNews =>
      news.where((item) => item['liked'] ?? false).toList();
  List<Map<String, dynamic>> get savedNews =>
      news.where((item) => item['saved'] ?? false).toList();

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

class NewsService {
  static const _apiKey = '152d578cbeef4478b83e38c92f1699f2';
  static const _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Map<String, dynamic>>> fetchNews() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?country=us&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Fetched news: ${data['articles']}'); // Debug için ekleyelim
      final articles = (data['articles'] as List)
          .map((article) => {
                'title': article['title'],
                'description': article['description'],
                'imageUrl':
                    article['urlToImage'] ?? 'https://via.placeholder.com/150',
              })
          .toList();

      // İlk 10 haberi al
      return articles.take(5).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class GeminiService {
  final String _apiUrl =
      'https://api.your-gemini-service.com/v1/modify'; // Doğru URL'yi buraya yerleştirin
  final String _apiKey =
      'AIzaSyCk9iMFBbpTFXIpw3-gK6By9gnzZr1b_Ak'; // Geçerli API anahtarını buraya yerleştirin

  Future<String> getUpdatedText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({'prompt': prompt}),
      );

      print('Gemini API Response status: ${response.statusCode}');
      print('Gemini API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['text'];
      } else {
        throw Exception('Failed to get updated text');
      }
    } catch (e) {
      print('Error in GeminiService: $e');
      rethrow;
    }
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
      widget.news[index]['liked'] = !(widget.news[index]['liked'] ?? false);
    });
  }

  void toggleSave(int index) {
    setState(() {
      widget.news[index]['saved'] = !(widget.news[index]['saved'] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Rendering news: ${widget.news}'); // Debug için ekleyelim
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
                  subtitle: Text(widget.news[index]['description'] ??
                      'No description available'), // Null kontrolü ekledik
                  leading: Image.network(widget.news[index]['imageUrl']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          (widget.news[index]['liked'] ?? false)
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          color: (widget.news[index]['liked'] ?? false)
                              ? Colors.black
                              : null,
                        ),
                        onPressed: () => toggleLike(index),
                      ),
                      IconButton(
                        icon: Icon(
                          (widget.news[index]['saved'] ?? false)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: (widget.news[index]['saved'] ?? false)
                              ? Colors.black
                              : null,
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

class SavedNewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> news;

  SavedNewsScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(news[index]['title']),
          subtitle: Text(news[index]['description']),
          leading: Image.network(news[index]['imageUrl']),
        );
      },
    );
  }
}

class LikedNewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> news;

  LikedNewsScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(news[index]['title']),
          subtitle: Text(news[index]['description']),
          leading: Image.network(news[index]['imageUrl']),
        );
      },
    );
  }
}
