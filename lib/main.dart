import 'package:aijam/Screens/HomePageScreen.dart';
import 'package:aijam/Screens/ProfileEditScreen.dart';
import 'package:aijam/Screens/ProfileScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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