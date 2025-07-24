import 'package:flutter/material.dart';
import 'package:recipe_book_app/ui/screens/favorites_screen.dart';
import 'package:recipe_book_app/ui/screens/home_screen.dart';
import 'package:recipe_book_app/ui/screens/recipe_list_screen.dart';
import 'package:recipe_book_app/ui/screens/shopping_list_screen.dart';
import 'package:recipe_book_app/ui/screens/profile_screen.dart';
import 'package:recipe_book_app/ui/theme/app_theme.dart';
import 'package:recipe_book_app/ui/widgets/responsive_nav.dart';
import 'package:recipe_book_app/utils/constants.dart';
import 'package:recipe_book_app/data/services/storage_service.dart';

void main() {
  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatefulWidget {
  const RecipeBookApp({super.key});

  @override
  State<RecipeBookApp> createState() => _RecipeBookAppState();
}

class _RecipeBookAppState extends State<RecipeBookApp> {
  int _selectedIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDarkMode = await _storageService.getThemePreference();
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    await _storageService.saveThemePreference(_themeMode == ThemeMode.dark);
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: ResponsiveNav(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        onThemeToggle: _toggleTheme,
        child: _buildScreen(),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(onThemeToggle: _toggleTheme);
      case 1:
        return const RecipeListScreen();
      case 2:
        return const FavoritesScreen();
      case 3:
        return const ProfileScreen();
      case 4:
        return const ShoppingListScreen();
      default:
        return HomeScreen(onThemeToggle: _toggleTheme);
    }
  }
}