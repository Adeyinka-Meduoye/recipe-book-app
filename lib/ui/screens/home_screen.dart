import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:adeyinka_recipe_book_app/data/dummy_data/categories.dart';
import 'package:adeyinka_recipe_book_app/data/dummy_data/recipes.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/category_tile.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/search_bar.dart'as custom_widgets;
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (query.isNotEmpty) {
      context.go('/recipes?query=$query');
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
            title: const Text(AppConstants.appName),
            actions: [
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
                        selected: true,
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/home');
                        },
                      ),
                      ListTile(
                        title: const Text('Favorites'),
                        leading: const Icon(Icons.favorite),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/favorites');
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: isDesktop
                        ? 400
                        : isTablet
                        ? 300
                        : 200,
                    autoPlay: true,
                    autoPlayInterval: Duration(
                      milliseconds: AppConstants.carouselAutoPlayInterval,
                    ),
                    enlargeCenterPage: true,
                    viewportFraction: isDesktop
                        ? 0.6
                        : isTablet
                        ? 0.7
                        : 0.8,
                  ),
                  items: dummyRecipes.map((recipe) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            context.go('/recipe/${recipe.id}');
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppConstants.cardBorderRadius,
                              ),
                              image: DecorationImage(
                                image: AssetImage(recipe.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  AppConstants.defaultPadding,
                                ),
                                child: Text(
                                  recipe.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                if (constraints.maxWidth < AppConstants.tabletBreakpoint)
                  custom_widgets.SearchBar(
                    onSearch: _updateSearchQuery,
                    initialQuery: _searchQuery,
                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 400,
                    height: isDesktop
                        ? 170
                        : isTablet
                        ? 170
                        : 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dummyCategories.length,
                      itemBuilder: (context, index) {
                        final category = dummyCategories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CategoryTile(
                            category: category,
                            onTap: () {
                              context.go('/recipes?category=${category.name}');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Text(
                      'Featured Recipes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    child: Wrap(
                      spacing: AppConstants.defaultPadding,
                      runSpacing: AppConstants.defaultPadding,
                      children: dummyRecipes.map((recipe) {
                        return SizedBox(
                          width: isDesktop
                              ? constraints.maxWidth / 4 -
                                    AppConstants.defaultPadding
                              : isTablet
                              ? constraints.maxWidth / 2 -
                                    AppConstants.defaultPadding
                              : constraints.maxWidth,
                          child: RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              context.go('/recipe/${recipe.id}');
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppConstants.defaultPadding,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Text(
                      'Developed by ${AppConstants.developerName}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
