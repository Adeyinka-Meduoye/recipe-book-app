import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:recipe_book_app/data/models/recipe.dart';
import 'package:recipe_book_app/data/models/shopping_item.dart';
import 'package:recipe_book_app/data/services/storage_service.dart';
import 'package:recipe_book_app/utils/constants.dart';
import 'package:recipe_book_app/utils/helpers.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _servings = 0;
  bool _isFavorite = false;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings;
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorites = await _storageService.getFavorites();
    setState(() {
      _isFavorite = favorites.contains(widget.recipe.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final favorites = await _storageService.getFavorites();
    setState(() {
      if (_isFavorite) {
        favorites.remove(widget.recipe.id);
      } else {
        favorites.add(widget.recipe.id);
      }
      _isFavorite = !_isFavorite;
    });
    await _storageService.saveFavorites(favorites);
  }

  Future<void> _addToShoppingList() async {
    final items = await _storageService.getShoppingList();
    final newItems = widget.recipe.ingredients.map((ingredient) {
      final adjustedIngredient = _adjustIngredient(
        ingredient,
        widget.recipe.servings,
      );
      final regex = RegExp(r'^(\d*\.?\d+)([a-zA-Z]+)?\s(.+)$');
      final match = regex.firstMatch(adjustedIngredient);
      if (match != null) {
        final quantity = double.parse(match.group(1)!);
        final unit = match.group(2) ?? 'unit';
        final name = match.group(3)!;
        return ShoppingItem(name: name, quantity: quantity, unit: unit);
      }
      return ShoppingItem(name: ingredient, quantity: 1.0, unit: 'unit');
    }).toList();

    // Aggregate quantities for duplicate items
    final aggregatedItems = <ShoppingItem>[];
    for (var newItem in newItems) {
      final existingItemIndex = aggregatedItems.indexWhere(
        (item) => item.name == newItem.name && item.unit == newItem.unit,
      );
      if (existingItemIndex != -1) {
        aggregatedItems[existingItemIndex] = ShoppingItem(
          name: newItem.name,
          quantity:
              aggregatedItems[existingItemIndex].quantity + newItem.quantity,
          unit: newItem.unit,
          isChecked: aggregatedItems[existingItemIndex].isChecked,
        );
      } else {
        aggregatedItems.add(newItem);
      }
    }

    // Merge with existing shopping list
    for (var newItem in aggregatedItems) {
      final existingItemIndex = items.indexWhere(
        (item) => item.name == newItem.name && item.unit == newItem.unit,
      );
      if (existingItemIndex != -1) {
        items[existingItemIndex] = ShoppingItem(
          name: newItem.name,
          quantity: items[existingItemIndex].quantity + newItem.quantity,
          unit: newItem.unit,
          isChecked: items[existingItemIndex].isChecked,
        );
      } else {
        items.add(newItem);
      }
    }

    await _storageService.saveShoppingList(items);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingredients added to shopping list')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final isTablet =
            constraints.maxWidth >= AppConstants.tabletBreakpoint &&
            constraints.maxWidth < AppConstants.desktopBreakpoint;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.recipe.title),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: _addToShoppingList,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery (using a single image for now, extendable to multiple)
                CarouselSlider(
                  options: CarouselOptions(
                    height: isDesktop
                        ? 400
                        : isTablet
                        ? 300
                        : 200,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                  ),
                  items: [
                    Image.asset(
                      widget.recipe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                // Recipe Details
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Metadata
                      Text(
                        widget.recipe.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      // In RecipeDetailScreen build method
                      Text(
                        '${Helpers.formatDuration(widget.recipe.cookingTime)} | ${widget.recipe.difficulty} | ${Helpers.capitalize(widget.recipe.category)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (widget.recipe.dietaryRestrictions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            children: widget.recipe.dietaryRestrictions
                                .map(
                                  (restriction) => Chip(
                                    label: Text(restriction),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Servings Adjuster
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Servings: $_servings',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: _servings > 1
                                    ? () {
                                        setState(() {
                                          _servings--;
                                        });
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _servings++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Ingredients
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ...widget.recipe.ingredients.map((ingredient) {
                        final adjustedIngredient = _adjustIngredient(
                          ingredient,
                          widget.recipe.servings,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            adjustedIngredient,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      // Instructions
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ...widget.recipe.instructions.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key + 1;
                        final instruction = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '$index. $instruction',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      // Nutrition Facts
                      Text(
                        'Nutrition Facts (per serving)',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ...widget.recipe.nutrition.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${entry.key}: ${entry.value}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _adjustIngredient(String ingredient, int originalServings) {
    final regex = RegExp(r'^(\d*\.?\d+)([a-zA-Z]+)?\s(.+)$');
    final match = regex.firstMatch(ingredient);
    if (match != null) {
      final quantity = double.tryParse(match.group(1)!) ?? 1.0;
      final unit = match.group(2) ?? '';
      final item = match.group(3)!;
      final adjustedQuantity = (quantity * _servings) / originalServings;
      return '${adjustedQuantity.toStringAsFixed(1)}$unit $item';
    }
    return ingredient;
  }
}
