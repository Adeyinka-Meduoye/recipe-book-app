import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/data/dummy_data/recipes.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class RecipeListScreen extends StatefulWidget {
  final String? initialSearchQuery;
  final String? initialCategory;

  const RecipeListScreen({
    super.key,
    this.initialSearchQuery,
    this.initialCategory,
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _searchQuery = '';
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialSearchQuery ?? '';
    _selectedCategory = widget.initialCategory ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = dummyRecipes.where((recipe) {
      final matchesSearch = _searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory.isEmpty || recipe.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final isTablet = constraints.maxWidth >= AppConstants.tabletBreakpoint &&
            constraints.maxWidth < AppConstants.desktopBreakpoint;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Recipes'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Recipes',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    context.go('/recipes?query=$value');
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : isTablet ? 2 : 1,
                    crossAxisSpacing: AppConstants.defaultPadding,
                    mainAxisSpacing: AppConstants.defaultPadding,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        context.go('/recipe/${recipe.id}');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}