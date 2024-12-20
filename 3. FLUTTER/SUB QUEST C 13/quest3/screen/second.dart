import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    bool is_cat = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        title: Text('SecondPage'),
        leading: Icon(Icons.pets),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("back"),
              onPressed:(){
                Navigator.pop(context,  true );
              } ,
            ),
            IconButton(
              icon: Image.asset('assets/pic/7.png'),
              iconSize: 300,
              onPressed: (){
                print('is_cat: $is_cat');
              },

            )
          ]
            )
        ),
      );
  }
}