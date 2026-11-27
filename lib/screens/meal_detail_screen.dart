import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_api.dart';
import '../services/favorites_storage.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApi _api = MealApi();
  final FavoritesStorage _storage = FavoritesStorage();

  late Future<Meal> _mealFuture;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _mealFuture = _api.fetchMealDetails(widget.meal.id);
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    try {
      final favorites = await _storage.loadFavorites();

      if (!mounted) return;

      setState(() {
        _isFavorite = favorites.any((meal) => meal.id == widget.meal.id);
      });
    } catch (_) {
      // Keep the default favorite status if loading fails.
    }
  }

  Future<void> toggleFavorite(Meal meal) async {
    final favorites = await _storage.loadFavorites();

    final alreadySaved = favorites.any((item) => item.id == meal.id);

    if (alreadySaved) {
      favorites.removeWhere((item) => item.id == meal.id);
    } else {
      favorites.add(meal);
    }

    await _storage.saveFavorites(favorites);

    if (!mounted) return;

    setState(() {
      _isFavorite = !alreadySaved;
    });
  }

  void retry() {
    setState(() {
      _mealFuture = _api.fetchMealDetails(widget.meal.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Details')),
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not load meal details.'),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: retry, child: const Text('Retry')),
                ],
              ),
            );
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  meal.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: Icon(Icons.restaurant, size: 60)),
                    );
                  },
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        meal.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => toggleFavorite(meal),
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                Text('Category: ${meal.category}'),
                Text('Area: ${meal.area}'),

                const SizedBox(height: 20),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                ...meal.ingredients.map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• $ingredient'),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(meal.instructions),
              ],
            ),
          );
        },
      ),
    );
  }
}
