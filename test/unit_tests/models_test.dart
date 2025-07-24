// File: test/unit_tests/models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/data/models/recipe.dart';
import 'package:recipe_book_app/data/models/category.dart';
import 'package:recipe_book_app/data/models/shopping_item.dart';

void main() {
  group('Model Tests', () {
    test('Recipe model initialization', () {
      // Arrange
      final recipe = Recipe(
        id: '1',
        title: 'Test Recipe',
        imageUrl: 'test.jpg',
        ingredients: ['Ingredient 1'],
        instructions: ['Step 1'],
        nutrition: {'calories': 100},
        servings: 2,
        category: 'Test Category',
        cookingTime: 30,
        difficulty: 'Easy',
        dietaryRestrictions: ['Vegan'],
      );

      // Assert
      expect(recipe.id, equals('1'));
      expect(recipe.title, equals('Test Recipe'));
      expect(recipe.imageUrl, equals('test.jpg'));
      expect(recipe.ingredients, equals(['Ingredient 1']));
      expect(recipe.instructions, equals(['Step 1']));
      expect(recipe.nutrition, equals({'calories': 100}));
      expect(recipe.servings, equals(2));
      expect(recipe.category, equals('Test Category'));
      expect(recipe.cookingTime, equals(30));
      expect(recipe.difficulty, equals('Easy'));
      expect(recipe.dietaryRestrictions, equals(['Vegan']));
    });

    test('Category model initialization', () {
      // Arrange
      final category = Category(id: '1', name: 'Italian', imageUrl: 'italian.jpg');

      // Assert
      expect(category.id, equals('1'));
      expect(category.name, equals('Italian'));
      expect(category.imageUrl, equals('italian.jpg'));
    });

    test('ShoppingItem model initialization and JSON serialization', () {
      // Arrange
      final item = ShoppingItem(name: 'Tomato', quantity: 2, unit: 'unit', isChecked: true);

      // Act
      final json = item.toJson();
      final fromJson = ShoppingItem.fromJson(json);

      // Assert
      expect(json, equals({'name': 'Tomato', 'quantity': 2, 'unit': 'unit', 'isChecked': true}));
      expect(fromJson.name, equals(item.name));
      expect(fromJson.quantity, equals(item.quantity));
      expect(fromJson.unit, equals(item.unit));
      expect(fromJson.isChecked, equals(item.isChecked));
    });
  });
}