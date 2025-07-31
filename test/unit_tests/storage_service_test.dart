// File: test/unit_tests/storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adeyinka_recipe_book_app/data/services/storage_service.dart';
import 'package:adeyinka_recipe_book_app/data/models/shopping_item.dart';

void main() {
  group('StorageService Tests', () {
    late StorageService storageService;

    setUp(() async {
      // Initialize StorageService
      storageService = StorageService();

      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    test('saveThemePreference and getThemePreference work correctly', () async {
      // Save theme preference
      await storageService.saveThemePreference(true);
      expect(await storageService.getThemePreference(), true);

      // Save another preference
      await storageService.saveThemePreference(false);
      expect(await storageService.getThemePreference(), false);
    });

    test('getThemePreference returns false when no preference is set', () async {
      expect(await storageService.getThemePreference(), false);
    });

    test('saveFavorites and getFavorites work correctly', () async {
      // Save favorites with explicit List<String> type
      List<String> favorites = ['1', '2', '3'];
      await storageService.saveFavorites(favorites);
      expect(await storageService.getFavorites(), favorites);

      // Save empty favorites
      List<String> emptyFavorites = [];
      await storageService.saveFavorites(emptyFavorites);
      expect(await storageService.getFavorites(), emptyFavorites);
    });

    test('getFavorites returns empty list when no favorites are set', () async {
      expect(await storageService.getFavorites(), <String>[]);
    });

    test('saveShoppingList and getShoppingList work correctly', () async {
      // Save shopping list with explicit List<ShoppingItem> type
      List<ShoppingItem> shoppingList = [
        ShoppingItem(name: 'Spaghetti', quantity: 200.0, unit: 'g', isChecked: true),
        ShoppingItem(name: 'Lettuce', quantity: 1.0, unit: 'head', isChecked: false),
      ];
      await storageService.saveShoppingList(shoppingList);
      final retrievedList = await storageService.getShoppingList();

      expect(retrievedList.length, shoppingList.length);
      expect(retrievedList[0].name, 'Spaghetti');
      expect(retrievedList[0].quantity, 200.0);
      expect(retrievedList[0].unit, 'g');
      expect(retrievedList[0].isChecked, true);
      expect(retrievedList[1].name, 'Lettuce');
      expect(retrievedList[1].quantity, 1.0);
      expect(retrievedList[1].unit, 'head');
      expect(retrievedList[1].isChecked, false);
    });

    test('getShoppingList returns empty list when no items are set', () async {
      expect(await storageService.getShoppingList(), <ShoppingItem>[]);
    });

    test('saveUserPrefs and getUserPrefs work correctly', () async {
      // Save user preferences with string values
      Map<String, String> userPrefs = {
        'name': 'John Doe',
        'email': 'john@example.com',
        'dietaryPreferences': 'Vegetarian',
      };
      await storageService.saveUserPrefs(userPrefs);
      final retrievedPrefs = await storageService.getUserPrefs();

      expect(retrievedPrefs, userPrefs);
      expect(retrievedPrefs['name'], 'John Doe');
      expect(retrievedPrefs['email'], 'john@example.com');
      expect(retrievedPrefs['dietaryPreferences'], 'Vegetarian');
    });

    test('getUserPrefs returns empty map when no preferences are set', () async {
      expect(await storageService.getUserPrefs(), <String, String>{});
    });
  });
}