import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipe_book_app/data/dummy_data/recipes.dart';
import 'package:recipe_book_app/data/models/recipe.dart';
import 'package:recipe_book_app/ui/screens/recipe_detail_screen.dart';
import 'package:recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:recipe_book_app/utils/constants.dart';
import 'package:recipe_book_app/ui/widgets/search_bar.dart' as custom_widgets;

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
  bool _isGridView = true;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedDietaryRestriction;
  String? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialSearchQuery ?? '';
    _selectedCategory = widget.initialCategory;
  }

  List<Recipe> get _filteredRecipes {
    return dummyRecipes.where((recipe) {
      final matchesSearch = recipe.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || recipe.category == _selectedCategory;
      final matchesDietary = _selectedDietaryRestriction == null ||
          recipe.dietaryRestrictions.contains(_selectedDietaryRestriction);
      final matchesDifficulty = _selectedDifficulty == null || recipe.difficulty == _selectedDifficulty;
      return matchesSearch && matchesCategory && matchesDietary && matchesDifficulty;
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _updateCategoryFilter(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _updateDietaryFilter(String? restriction) {
    setState(() {
      _selectedDietaryRestriction = restriction;
    });
  }

  void _updateDifficultyFilter(String? difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
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
            title: const Text('Recipes'),
            actions: [
              IconButton(
                icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              if (isDesktop || isTablet)
                SizedBox(
                  width: isDesktop ? 400 : 300,
                  child: custom_widgets.SearchBar(
                    onSearch: _updateSearchQuery,
                    initialQuery: _searchQuery,
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar (Mobile only)
              if (constraints.maxWidth < AppConstants.tabletBreakpoint)
                custom_widgets.SearchBar(
                  onSearch: _updateSearchQuery,
                  initialQuery: _searchQuery,
                ),
              // Filter Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category Filter
                      DropdownButton<String>(
                        hint: const Text('Category'),
                        value: _selectedCategory,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ...dummyRecipes
                              .map((recipe) => recipe.category)
                              .toSet()
                              .map((category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  )),
                        ],
                        onChanged: _updateCategoryFilter,
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      // Dietary Restriction Filter
                      DropdownButton<String>(
                        hint: const Text('Dietary'),
                        value: _selectedDietaryRestriction,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Diets'),
                          ),
                          ...dummyRecipes
                              .expand((recipe) => recipe.dietaryRestrictions)
                              .toSet()
                              .map((restriction) => DropdownMenuItem<String>(
                                    value: restriction,
                                    child: Text(restriction),
                                  ))
                        ],
                        onChanged: _updateDietaryFilter,
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      // Difficulty Filter
                      DropdownButton<String>(
                        hint: const Text('Difficulty'),
                        value: _selectedDifficulty,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Difficulties'),
                          ),
                          ...['Easy', 'Medium', 'Hard']
                              .map((difficulty) => DropdownMenuItem<String>(
                                    value: difficulty,
                                    child: Text(difficulty),
                                  ))
                        ],
                        onChanged: _updateDifficultyFilter,
                      ),
                    ],
                  ),
                ),
              ),
              // Recipe List
              Expanded(
                child: _isGridView
                    ? MasonryGridView.count(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: AppConstants.defaultPadding,
                        crossAxisSpacing: AppConstants.defaultPadding,
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _filteredRecipes[index];
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
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _filteredRecipes[index];
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
                            isGridView: false,
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