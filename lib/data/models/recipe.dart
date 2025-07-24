class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final Map<String, double> nutrition; // e.g., {"calories": 300, "protein": 20}
  final int servings;
  final String category;
  final int cookingTime; // in minutes
  final String difficulty; // e.g., "Easy", "Medium", "Hard"
  final List<String> dietaryRestrictions; // e.g., ["Gluten-Free", "Vegan"]

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
    required this.servings,
    required this.category,
    required this.cookingTime,
    required this.difficulty,
    required this.dietaryRestrictions,
  });
}