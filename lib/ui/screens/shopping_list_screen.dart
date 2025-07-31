import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/data/models/shopping_item.dart';
import 'package:adeyinka_recipe_book_app/data/services/storage_service.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class ShoppingListScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const ShoppingListScreen({super.key, required this.onThemeToggle});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final StorageService _storageService = StorageService();
  List<ShoppingItem> _shoppingList = [];

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    final items = await _storageService.getShoppingList();
    setState(() {
      _shoppingList = items;
    });
  }

  Future<void> _toggleItemChecked(int index) async {
    setState(() {
      _shoppingList[index] = ShoppingItem(
        name: _shoppingList[index].name,
        quantity: _shoppingList[index].quantity,
        unit: _shoppingList[index].unit,
        isChecked: !_shoppingList[index].isChecked,
      );
    });
    await _storageService.saveShoppingList(_shoppingList);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping List'),
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
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/profile');
                        },
                      ),
                      ListTile(
                        title: const Text('Shopping List'),
                        leading: const Icon(Icons.list),
                        selected: true,
                        onTap: () {
                          Navigator.pop(context);
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
          body: _shoppingList.isEmpty
              ? const Center(child: Text('Your shopping list is empty!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: _shoppingList.length,
                  itemBuilder: (context, index) {
                    final item = _shoppingList[index];
                    return ListTile(
                      leading: Checkbox(
                        value: item.isChecked,
                        onChanged: (value) => _toggleItemChecked(index),
                      ),
                      title: Text(
                        '${item.quantity} ${item.unit} ${item.name}',
                        style: TextStyle(
                          decoration: item.isChecked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}