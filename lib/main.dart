import 'package:flutter/material.dart';
import 'package:ybooks/pages/home_page.dart'; // Import HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(surface: Colors.white),
      ),
      home: const HomePage(), // Set HomePage as the home
    );
  }
}
