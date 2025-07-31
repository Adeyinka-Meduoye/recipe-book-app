// File: lib/ui/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/data/dummy_data/recipes.dart';
import 'package:adeyinka_recipe_book_app/data/services/storage_service.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const FavoritesScreen({super.key, required this.onThemeToggle});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storageService = StorageService();
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _storageService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = dummyRecipes.where((recipe) => _favorites.contains(recipe.id)).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final isTablet = constraints.maxWidth >= AppConstants.tabletBreakpoint &&
            constraints.maxWidth < AppConstants.desktopBreakpoint;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorites'),
          ),
          drawer: constraints.maxWidth < AppConstants.tabletBreakpoint
              ? Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        child: Text(
                          AppConstants.appName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      ListTile(
                        title: const Text('Home'),
                        leading: const Icon(Icons.home),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/home');
                        },
                      ),
                      ListTile(
                        title: const Text('Favorites'),
                        leading: const Icon(Icons.favorite),
                        selected: true,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Profile'),
                        leading: const Icon(Icons.person),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/profile');
                        },
                      ),
                      ListTile(
                        title: const Text('Shopping List'),
                        leading: const Icon(Icons.list),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/shopping');
                        },
                      ),
                      ListTile(
                        title: const Text('Change Theme'),
                        leading: Icon(
                          Theme.of(context).brightness == Brightness.light
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          widget.onThemeToggle();
                        },
                      ),
                    ],
                  ),
                )
              : null,
          body: favoriteRecipes.isEmpty
              ? const Center(child: Text('No favorite recipes yet!'))
              : GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : isTablet ? 2 : 1,
                    crossAxisSpacing: AppConstants.defaultPadding,
                    mainAxisSpacing: AppConstants.defaultPadding,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: favoriteRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = favoriteRecipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        context.go('/recipe/${recipe.id}');
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}