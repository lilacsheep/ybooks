import 'package:flutter/material.dart';
import 'package:ybooks/pages/home_page.dart'; // Import HomePage
import 'package:ybooks/pages/user/settings.dart'; // Import SettingsPage
import 'package:ybooks/utils/client/http_core.dart'; // Import HttpCore

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); // Create a GlobalKey

void main() {
  HttpCore.initializeDio(navigatorKey); // Initialize HttpCore with the key
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Assign the navigatorKey to MaterialApp
      title: 'Ybooks',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(surface: Colors.white),
      ),
      home: const HomePage(), // Set HomePage as the home
      routes: {
        '/settings': (context) => const SettingsPage(), // Define the settings route
      },
    );
  }
}
