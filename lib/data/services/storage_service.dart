import 'package:shared_preferences/shared_preferences.dart';
import 'package:adeyinka_recipe_book_app/data/models/shopping_item.dart';
import 'dart:convert';

class StorageService {
  static const String _themeKey = 'isDarkMode';
  static const String _favoritesKey = 'favorites';
  static const String _shoppingListKey = 'shoppingList';
  static const String _userPrefsKey = 'userPrefs';

  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<ShoppingItem>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingList = prefs.getStringList(_shoppingListKey) ?? [];
    return shoppingList.map((item) {
      final parts = item.split('|');
      return ShoppingItem(
        name: parts[0],
        quantity: double.parse(parts[1]),
        unit: parts[2],
        isChecked: parts[3] == 'true',
      );
    }).toList();
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingList = items.map((item) {
      return '${item.name}|${item.quantity}|${item.unit}|${item.isChecked}';
    }).toList();
    await prefs.setStringList(_shoppingListKey, shoppingList);
  }

  Future<Map<String, String>> getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefsJson = prefs.getString(_userPrefsKey) ?? '{}';
    final Map<String, dynamic> userPrefs = jsonDecode(userPrefsJson);
    return userPrefs.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> saveUserPrefs(Map<String, String> userPrefs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPrefsKey, jsonEncode(userPrefs));
  }
}