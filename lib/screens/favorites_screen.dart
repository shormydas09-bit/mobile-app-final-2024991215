import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/favorites_storage.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesStorage _storage = FavoritesStorage();

  late Future<List<Meal>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _storage.loadFavorites();
  }

  void loadFavorites() {
    setState(() {
      _favoritesFuture = _storage.loadFavorites();
    });
  }

  Future<void> openMeal(Meal meal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealDetailScreen(meal: meal)),
    );

    if (!mounted) return;

    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites'), centerTitle: true),
      body: FutureBuilder<List<Meal>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not load favorites.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loadFavorites,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final meals = snapshot.data ?? [];

          if (meals.isEmpty) {
            return const Center(child: Text('No favorite recipes yet.'));
          }

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return MealCard(
                meal: meal,
                trailing: const Icon(Icons.favorite, color: Colors.red),
                onTap: () => openMeal(meal),
              );
            },
          );
        },
      ),
    );
  }
}
