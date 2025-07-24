import 'package:flutter/material.dart';
import 'package:recipe_book_app/data/dummy_data/recipes.dart';
import 'package:recipe_book_app/data/services/storage_service.dart';
import 'package:recipe_book_app/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  List<String> _dietaryPreferences = [];
  List<String> _favoriteIds = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _storageService.getUserPrefs();
    final favorites = await _storageService.getFavorites();
    setState(() {
      _dietaryPreferences = List<String>.from(prefs['dietaryPreferences'] ?? []);
      _nameController.text = prefs['name'] ?? '';
      _favoriteIds = favorites;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = {
      'name': _nameController.text,
      'dietaryPreferences': _dietaryPreferences,
    };
    await _storageService.saveUserPrefs(prefs);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved')),
      );
    }
  }

  void _toggleDietaryPreference(String preference) {
    setState(() {
      if (_dietaryPreferences.contains(preference)) {
        _dietaryPreferences.remove(preference);
      } else {
        _dietaryPreferences.add(preference);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableDietaryOptions = dummyRecipes
        .expand((recipe) => recipe.dietaryRestrictions)
        .toSet()
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _savePreferences,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? AppConstants.defaultPadding * 2 : AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Dietary Preferences
                Text(
                  'Dietary Preferences',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableDietaryOptions.map((preference) {
                    final isSelected = _dietaryPreferences.contains(preference);
                    return FilterChip(
                      label: Text(preference),
                      selected: isSelected,
                      onSelected: (selected) {
                        _toggleDietaryPreference(preference);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Stats
                Text(
                  'Your Stats',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorite Recipes: ${_favoriteIds.length}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dietary Preferences Set: ${_dietaryPreferences.length}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
