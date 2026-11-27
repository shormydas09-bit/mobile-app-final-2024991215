import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';

class FavoritesStorage {
  static const String _favoritesKey = 'favorites';

  // Load saved favorite meals
  Future<List<Meal>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final savedMeals = prefs.getStringList(_favoritesKey) ?? [];

    return savedMeals.map((item) {
      final data = jsonDecode(item) as Map<String, dynamic>;
      return Meal.fromStorageJson(data);
    }).toList();
  }

  // Save favorite meals
  Future<void> saveFavorites(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();

    final savedMeals = meals.map((meal) {
      return jsonEncode(meal.toStorageJson());
    }).toList();

    await prefs.setStringList(_favoritesKey, savedMeals);
  }
}
