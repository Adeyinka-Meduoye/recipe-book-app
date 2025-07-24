// File: test/widget_tests/recipe_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/data/models/recipe.dart';
import 'package:recipe_book_app/ui/widgets/recipe_card.dart';

void main() {
  group('RecipeCard Widget Tests', () {
    final testRecipe = Recipe(
      id: '1',
      title: 'Test Recipe',
      imageUrl: 'assets/images/test.jpg',
      ingredients: ['Ingredient 1'],
      instructions: ['Step 1'],
      nutrition: {'calories': 100},
      servings: 2,
      category: 'Test Category',
      cookingTime: 30,
      difficulty: 'Easy',
      dietaryRestrictions: [],
    );

    testWidgets('RecipeCard displays title and metadata in grid view', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(
              recipe: testRecipe,
              onTap: () {},
              isGridView: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Recipe'), findsOneWidget);
      expect(find.text('30 min | Easy'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('RecipeCard displays title and metadata in list view', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(
              recipe: testRecipe,
              onTap: () {},
              isGridView: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Recipe'), findsOneWidget);
      expect(find.text('30 min | Easy'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}