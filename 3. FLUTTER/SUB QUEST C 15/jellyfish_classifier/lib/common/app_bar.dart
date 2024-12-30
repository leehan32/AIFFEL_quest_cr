import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.amber[50],
      leading: Icon(Icons.home),
      title: Center(child: Text('JellyFish Classifier')),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
