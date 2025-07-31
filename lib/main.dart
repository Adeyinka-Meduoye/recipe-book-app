import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/favorites_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/home_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/recipe_detail_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/recipe_list_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/shopping_list_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/profile_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/theme/app_theme.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/responsive_nav.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';
import 'package:adeyinka_recipe_book_app/data/services/storage_service.dart';

void main() {
  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatefulWidget {
  const RecipeBookApp({super.key});

  @override
  State<RecipeBookApp> createState() => _RecipeBookAppState();
}

class _RecipeBookAppState extends State<RecipeBookApp> {
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
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    await _storageService.saveThemePreference(_themeMode == ThemeMode.dark);
  }

  // Define routes with GoRouter
  GoRouter get _router => GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          // Determine selected index based on current path
          final path = state.uri.path;
          int selectedIndex = 0;

          if (path == '/' || path.isEmpty) {
            selectedIndex = 0;
          } else if (path.startsWith('/recipes')) {
            selectedIndex = 1;
          } else if (path.startsWith('/favorites')) {
            selectedIndex = 2;
          } else if (path.startsWith('/profile')) {
            selectedIndex = 3;
          } else if (path.startsWith('/shopping')) {
            selectedIndex = 4;
          } else {
            selectedIndex = 0; // Default to Home if no route matches
          }

          return ResponsiveNav(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              // Navigate to the corresponding route
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/recipes');
                  break;
                case 2:
                  context.go('/favorites');
                  break;
                case 3:
                  context.go('/profile');
                  break;
                case 4:
                  context.go('/shopping');
                  break;
              }
            },
            onThemeToggle: _toggleTheme,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                HomeScreen(onThemeToggle: _toggleTheme),
          ),
          GoRoute(
            path: '/recipes',
            builder: (context, state) => RecipeListScreen(
              initialSearchQuery: state.uri.queryParameters['query'],
              initialCategory: state.uri.queryParameters['category'],
            ),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) =>
                FavoritesScreen(onThemeToggle: _toggleTheme),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) =>
                ProfileScreen(onThemeToggle: _toggleTheme),
          ),
          GoRoute(
            path: '/shopping',
            builder: (context, state) =>
                ShoppingListScreen(onThemeToggle: _toggleTheme),
          ),
          GoRoute(
            path: '/recipe/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return RecipeDetailScreen(recipeId: id);
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
