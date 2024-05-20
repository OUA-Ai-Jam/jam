import 'dart:convert';

List<Story> storyFromJson(String str) => List<Story>.from(json.decode(str).map((x) => Story.fromJson(x)));

String storyToJson(List<Story> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Story {
  String title;
  String story;
  String description;
  List<String> keywords;
  String imageUrl;
  bool liked;
  bool saved;


  Story({
    required this.title,
    required this.story,
    required this.description,
    required this.keywords,
    required this.imageUrl,
    required this.liked,
    required this.saved,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    title: json["title"],
    story: json["story"],
    description: json["description"],
    keywords: List<String>.from(json["keywords"].map((x) => x)),
    imageUrl: 'https://via.placeholder.com/150',
    liked: false,
    saved: false,
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "story": story,
    "description": description,
    "keywords": List<dynamic>.from(keywords.map((x) => x)),
    'imageUrl': 'https://via.placeholder.com/150',
    'liked': false,
    'saved': false,
  };
}
