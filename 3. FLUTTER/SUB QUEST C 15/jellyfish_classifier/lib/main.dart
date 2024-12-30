import 'package:flutter/material.dart';
import 'package:jellyfish_classifier/common/app_bar.dart';
import 'package:jellyfish_classifier/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JellyFish Classifier',
      home: Scaffold(appBar: MyAppBar(), body: HomeScreen()),
    );
  }
}
