import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_book_app/data/models/shopping_item.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _userPrefsKey = 'userPrefs';
  static const String _shoppingListKey = 'shoppingList';
  static const String _themeKey = 'theme';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<Map<String, dynamic>> getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefsString = prefs.getString(_userPrefsKey);
    if (userPrefsString != null) {
      return jsonDecode(userPrefsString) as Map<String, dynamic>;
    }
    return {};
  }

  Future<void> saveUserPrefs(Map<String, dynamic> userPrefs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPrefsKey, jsonEncode(userPrefs));
  }

  Future<List<ShoppingItem>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingListString = prefs.getString(_shoppingListKey);
    if (shoppingListString != null) {
      final List<dynamic> jsonList = jsonDecode(shoppingListString);
      return jsonList.map((json) => ShoppingItem.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_shoppingListKey, jsonEncode(jsonList));
  }

  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default to light theme
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }
}