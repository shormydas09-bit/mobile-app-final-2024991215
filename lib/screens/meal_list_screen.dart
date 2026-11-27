import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../services/meal_api.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatefulWidget {
  final Category category;

  const MealListScreen({super.key, required this.category});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final MealApi _api = MealApi();

  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = _api.fetchMealsByCategory(widget.category.name);
  }

  void retry() {
    setState(() {
      _mealsFuture = _api.fetchMealsByCategory(widget.category.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: FutureBuilder<List<Meal>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not load meals.'),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: retry, child: const Text('Retry')),
                ],
              ),
            );
          }

          final meals = snapshot.data ?? [];

          if (meals.isEmpty) {
            return const Center(child: Text('No meals found.'));
          }

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(
                    meal.imageUrl,
                    width: 80,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 80,
                        child: Icon(Icons.restaurant),
                      );
                    },
                  ),
                  title: Text(meal.name),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(meal: meal),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
