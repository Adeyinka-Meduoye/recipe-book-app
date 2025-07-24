// File: test/unit_tests/storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/data/models/shopping_item.dart';
import 'package:recipe_book_app/data/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('StorageService Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = StorageService();
    });

    test('save and retrieve favorites', () async {
      // Arrange
      final favorites = ['1', '2'];

      // Act
      await storageService.saveFavorites(favorites);
      final result = await storageService.getFavorites();

      // Assert
      expect(result, equals(favorites));
    });

    test('save and retrieve user preferences', () async {
      // Arrange
      final prefs = {
        'name': 'Test User',
        'dietaryPreferences': ['Gluten-Free'],
      };

      // Act
      await storageService.saveUserPrefs(prefs);
      final result = await storageService.getUserPrefs();

      // Assert
      expect(result, equals(prefs));
    });

    test('save and retrieve shopping list', () async {
      // Arrange
      final items = [
        ShoppingItem(name: 'Spaghetti', quantity: 200, unit: 'g'),
        ShoppingItem(name: 'Tomato', quantity: 2, unit: 'unit', isChecked: true),
      ];

      // Act
      await storageService.saveShoppingList(items);
      final result = await storageService.getShoppingList();

      // Assert
      expect(result.length, equals(items.length));
      expect(result[0].name, equals(items[0].name));
      expect(result[0].quantity, equals(items[0].quantity));
      expect(result[0].unit, equals(items[0].unit));
      expect(result[0].isChecked, equals(items[0].isChecked));
      expect(result[1].name, equals(items[1].name));
      expect(result[1].quantity, equals(items[1].quantity));
      expect(result[1].unit, equals(items[1].unit));
      expect(result[1].isChecked, equals(items[1].isChecked));
    });
  });
}