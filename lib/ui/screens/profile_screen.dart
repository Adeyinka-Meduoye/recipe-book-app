// File: lib/ui/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/data/dummy_data/recipes.dart';
import 'package:adeyinka_recipe_book_app/data/services/storage_service.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const ProfileScreen({super.key, required this.onThemeToggle});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  List<String> _selectedDietaryPrefs = [];
  List<String> _favorites = [];

  // Predefined dietary preferences
  static const List<String> _dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Nut-Free',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPrefs();
    _loadFavorites();
  }

  Future<void> _loadUserPrefs() async {
    final userPrefs = await _storageService.getUserPrefs();
    setState(() {
      _nameController.text = userPrefs['name'] ?? '';
      _emailController.text = userPrefs['email'] ?? '';
      _selectedDietaryPrefs = userPrefs['dietaryPreferences']?.split(',').where((s) => s.isNotEmpty).toList() ?? [];
    });
  }

  Future<void> _loadFavorites() async {
    final favorites = await _storageService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  Future<void> _saveUserPrefs() async {
    if (_formKey.currentState!.validate()) {
      final userPrefs = {
        'name': _nameController.text,
        'email': _emailController.text,
        'dietaryPreferences': _selectedDietaryPrefs.join(','),
      };
      await _storageService.saveUserPrefs(userPrefs);
      if (mounted){
              ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      }
    }
  }

  String? _validateDietaryPrefs() {
    if (_selectedDietaryPrefs.isEmpty) {
      return 'Please select at least one dietary preference or "None"';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = dummyRecipes.where((recipe) => _favorites.contains(recipe.id)).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
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
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/favorites');
                        },
                      ),
                      ListTile(
                        title: const Text('Profile'),
                        leading: const Icon(Icons.person),
                        selected: true,
                        onTap: () {
                          Navigator.pop(context);
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
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Dietary Preferences',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _dietaryOptions.map((option) {
                          return ChoiceChip(
                            label: Text(option),
                            selected: _selectedDietaryPrefs.contains(option),
                            onSelected: (selected) {
                              setState(() {
                                if (option == 'None') {
                                  if (selected) {
                                    _selectedDietaryPrefs = ['None'];
                                  }
                                } else {
                                  if (selected) {
                                    _selectedDietaryPrefs
                                      ..remove('None')
                                      ..add(option);
                                  } else {
                                    _selectedDietaryPrefs.remove(option);
                                  }
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      if (_validateDietaryPrefs() != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _validateDietaryPrefs()!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _saveUserPrefs,
                        child: const Text('Save Profile'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Favorite Recipes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                favoriteRecipes.isEmpty
                    ? const Text('No favorite recipes yet!')
                    : Wrap(
                        spacing: AppConstants.defaultPadding,
                        runSpacing: AppConstants.defaultPadding,
                        children: favoriteRecipes.map((recipe) {
                          return SizedBox(
                            width: constraints.maxWidth >= AppConstants.desktopBreakpoint
                                ? constraints.maxWidth / 4 - AppConstants.defaultPadding
                                : constraints.maxWidth >= AppConstants.tabletBreakpoint
                                    ? constraints.maxWidth / 2 - AppConstants.defaultPadding
                                    : constraints.maxWidth - AppConstants.defaultPadding * 2,
                            child: RecipeCard(
                              recipe: recipe,
                              onTap: () {
                                context.go('/recipe/${recipe.id}');
                              },
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}