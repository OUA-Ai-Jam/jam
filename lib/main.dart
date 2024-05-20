import 'package:aijam/Screens/HomePageScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paralel Evren Hikaye Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePageScreen(),
    );
  }
}