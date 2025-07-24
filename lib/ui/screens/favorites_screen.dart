import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipe_book_app/data/dummy_data/recipes.dart';
import 'package:recipe_book_app/data/models/recipe.dart';
import 'package:recipe_book_app/data/services/storage_service.dart';
import 'package:recipe_book_app/ui/screens/recipe_detail_screen.dart';
import 'package:recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:recipe_book_app/utils/constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storageService = StorageService();
  List<String> _favoriteIds = [];
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _storageService.getFavorites();
    setState(() {
      _favoriteIds = favorites;
    });
  }

  Future<void> _removeFavorite(String recipeId) async {
    setState(() {
      _favoriteIds.remove(recipeId);
    });
    await _storageService.saveFavorites(_favoriteIds);
  }

  List<Recipe> get _favoriteRecipes {
    return dummyRecipes.where((recipe) => _favoriteIds.contains(recipe.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final isTablet = constraints.maxWidth >= AppConstants.tabletBreakpoint &&
            constraints.maxWidth < AppConstants.desktopBreakpoint;
        final crossAxisCount = isDesktop ? 4 : isTablet ? 2 : 1;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorites'),
            actions: [
              IconButton(
                icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
            ],
          ),
          body: _favoriteRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'No favorite recipes yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : _isGridView
                  ? StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: AppConstants.defaultPadding,
                      crossAxisSpacing: AppConstants.defaultPadding,
                      children: List.generate(
                        _favoriteRecipes.length,
                        (index) {
                          final recipe = _favoriteRecipes[index];
                          return RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                            isGridView: true,
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      itemCount: _favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _favoriteRecipes[index];
                        return Dismissible(
                          key: Key(recipe.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _removeFavorite(recipe.id);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                            isGridView: false,
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
