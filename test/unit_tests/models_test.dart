// File: test/unit_tests/models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:adeyinka_recipe_book_app/data/models/recipe.dart';
import 'package:adeyinka_recipe_book_app/data/models/shopping_item.dart';

void main() {
  group('Model Tests', () {
    group('Recipe Model', () {
      test('Recipe initializes with correct properties', () {
        final recipe = Recipe(
          id: '1',
          title: 'Spaghetti Bolognese',
          imageUrl: 'assets/images/spaghetti.jpg',
          cookingTime: 45,
          difficulty: 'Medium',
          category: 'Italian',
          ingredients: ['200g spaghetti', '100g ground beef'],
          instructions: ['Cook spaghetti.', 'Brown beef.'],
          nutrition: {
            'Calories': '500 kcal',
            'Protein': '20g',
            'Fat': '15g',
          },
          dietaryRestrictions: ['Contains Gluten'],
          servings: 4,
        );

        expect(recipe.id, '1');
        expect(recipe.title, 'Spaghetti Bolognese');
        expect(recipe.imageUrl, 'assets/images/spaghetti.jpg');
        expect(recipe.cookingTime, 45);
        expect(recipe.difficulty, 'Medium');
        expect(recipe.category, 'Italian');
        expect(recipe.ingredients, ['200g spaghetti', '100g ground beef']);
        expect(recipe.instructions, ['Cook spaghetti.', 'Brown beef.']);
        expect(recipe.nutrition, {
          'Calories': '500 kcal',
          'Protein': '20g',
          'Fat': '15g',
        });
        expect(recipe.dietaryRestrictions, ['Contains Gluten']);
        expect(recipe.servings, 4);
      });

      test('Recipe handles empty dietaryRestrictions and default servings', () {
        final recipe = Recipe(
          id: '2',
          title: 'Caesar Salad',
          imageUrl: 'assets/images/salad.jpg',
          cookingTime: 20,
          difficulty: 'Easy',
          category: 'Healthy',
          ingredients: ['1 romaine lettuce', '50g croutons'],
          instructions: ['Chop lettuce.', 'Toss salad.'],
          nutrition: {
            'Calories': '300 kcal',
            'Protein': '10g',
          },
        );

        expect(recipe.dietaryRestrictions, isEmpty);
        expect(recipe.servings, 4);
      });
    });

    group('ShoppingItem Model', () {
      test('ShoppingItem initializes with correct properties', () {
        final item = ShoppingItem(
          name: 'Spaghetti',
          quantity: 200.0,
          unit: 'g',
          isChecked: true,
        );

        expect(item.name, 'Spaghetti');
        expect(item.quantity, 200.0);
        expect(item.unit, 'g');
        expect(item.isChecked, true);
      });

      test('ShoppingItem handles default isChecked', () {
        final item = ShoppingItem(
          name: 'Lettuce',
          quantity: 1.0,
          unit: 'head',
        );

        expect(item.isChecked, false);
      });
    });
  });
}