import 'package:flutter/material.dart';
import 'package:untitled/quest3/screen/first.dart';
import 'package:untitled/quest3/screen/second.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/two':(context) =>SecondPage()
      },
    );
  }
}