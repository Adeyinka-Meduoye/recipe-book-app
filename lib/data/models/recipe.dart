// File: lib/data/models/recipe.dart
class Recipe {
  final String id; // Add id field
  final String title;
  final String imageUrl;
  final int cookingTime;
  final String difficulty;
  final String category;
  final List<String> ingredients;
  final List<String> instructions;
  final Map<String, String> nutrition;
  final List<String> dietaryRestrictions;
  final int servings;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.cookingTime,
    required this.difficulty,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
    this.dietaryRestrictions = const [],
    this.servings = 4,
  });
}