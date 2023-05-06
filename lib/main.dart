import 'package:flutter/material.dart';
import 'screen_shot_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Take a screen shot and share demo app",
      color: Colors.blue.shade900,
      debugShowCheckedModeBanner: false,
      home: const ScreenShotScreen(),
    );
  }
}
