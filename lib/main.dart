import 'package:flutter/material.dart';
import 'package:wallpaper_app/src/home.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      title: 'WallpaperHub',
      home: Home()
    );
  }
}