class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add('${measure ?? ''} ${ingredient.toString()}'.trim());
      }
    }

    return Meal(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      imageUrl: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      area: json['strArea']?.toString() ?? '',
      instructions: json['strInstructions']?.toString() ?? '',
      ingredients: ingredients,
    );
  }
  factory Meal.fromStorageJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'area': area,
      'instructions': instructions,
      'ingredients': ingredients,
    };
  }
}
