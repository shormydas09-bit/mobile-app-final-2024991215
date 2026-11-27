import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class MealApi {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Get all meal categories
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final data = jsonDecode(response.body);
    final List meals = data['categories'] ?? [];

    return meals.map((json) => Category.fromJson(json)).toList();
  }

  // Get meals from a selected category
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=${Uri.encodeComponent(category)}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final data = jsonDecode(response.body);
    final List meals = data['meals'] ?? [];

    return meals.map((json) => Meal.fromJson(json)).toList();
  }

  // Get full details of a meal
  Future<Meal> fetchMealDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal details');
    }

    final data = jsonDecode(response.body);
    final List meals = data['meals'] ?? [];

    if (meals.isEmpty) {
      throw Exception('Meal details not found');
    }

    return Meal.fromJson(meals[0]);
  }

  // Search meals by name
  Future<List<Meal>> searchMeals(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(name)}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Search failed');
    }

    final data = jsonDecode(response.body);
    final List meals = data['meals'] ?? [];

    return meals.map((json) => Meal.fromJson(json)).toList();
  }

  // Get one random meal (bonus feature)
  Future<Meal> fetchRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load random meal');
    }

    final data = jsonDecode(response.body);
    final List meals = data['meals'] ?? [];

    if (meals.isEmpty) {
      throw Exception('Random meal not found');
    }

    return Meal.fromJson(meals[0]);
  }
}
