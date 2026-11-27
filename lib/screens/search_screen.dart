import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_api.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MealApi _api = MealApi();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Meal>>? _resultsFuture;
  String _lastSearch = '';

  void searchMeals(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      return;
    }

    setState(() {
      _lastSearch = query;
      _resultsFuture = _api.searchMeals(query);
    });
  }

  void retry() {
    if (_lastSearch.isNotEmpty) {
      setState(() {
        _resultsFuture = _api.searchMeals(_lastSearch);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Recipes'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: searchMeals,
              decoration: InputDecoration(
                hintText: 'Enter meal name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchMeals(_searchController.text);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _resultsFuture == null
                ? const Center(child: Text('Search for a recipe.'))
                : FutureBuilder<List<Meal>>(
                    future: _resultsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Search failed.'),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: retry,
                                child: const Text('Retry'),
                              ),
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

                          return MealCard(
                            meal: meal,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MealDetailScreen(meal: meal),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
