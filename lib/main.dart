///
/// main.dart
/// main just call the main page. It dont have any function in it.
///

import 'package:flutter/material.dart';
import './ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
      },
    );
  }
}
