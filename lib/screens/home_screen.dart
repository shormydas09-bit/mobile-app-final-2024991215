import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../services/meal_api.dart';
import 'meal_list_screen.dart';
import 'meal_detail_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealApi _api = MealApi();

  late Future<List<Category>> _categoriesFuture;

  bool _loadingRandom = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _api.fetchCategories();
  }

  void retry() {
    setState(() {
      _categoriesFuture = _api.fetchCategories();
    });
  }

  Future<void> openRandomMeal() async {
    setState(() {
      _loadingRandom = true;
    });

    Meal meal;

    try {
      meal = await _api.fetchRandomMeal();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingRandom = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load a random meal. Please try again.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      _loadingRandom = false;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealDetailScreen(meal: meal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Explorer'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Random Meal',
            onPressed: _loadingRandom ? null : openRandomMeal,
            icon: _loadingRandom
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.shuffle),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not load categories.'),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: retry, child: const Text('Retry')),
                ],
              ),
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MealListScreen(category: category),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          category.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.restaurant, size: 50);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
