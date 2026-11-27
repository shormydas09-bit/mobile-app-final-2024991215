import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const RecipeExplorerApp());
}

class RecipeExplorerApp extends StatelessWidget {
  const RecipeExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
