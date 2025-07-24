import 'package:flutter/material.dart';
import 'package:recipe_book_app/data/models/shopping_item.dart';
import 'package:recipe_book_app/data/services/storage_service.dart';
import 'package:recipe_book_app/utils/constants.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final StorageService _storageService = StorageService();
  List<ShoppingItem> _shoppingItems = [];

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    final items = await _storageService.getShoppingList();
    setState(() {
      _shoppingItems = items;
    });
  }

  Future<void> _toggleItemChecked(int index) async {
    setState(() {
      _shoppingItems[index] = ShoppingItem(
        name: _shoppingItems[index].name,
        quantity: _shoppingItems[index].quantity,
        unit: _shoppingItems[index].unit,
        isChecked: !_shoppingItems[index].isChecked,
      );
    });
    await _storageService.saveShoppingList(_shoppingItems);
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _shoppingItems.removeAt(index);
    });
    await _storageService.saveShoppingList(_shoppingItems);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping List'),
            actions: [
              if (_shoppingItems.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () async {
                    setState(() {
                      _shoppingItems.clear();
                    });
                    await _storageService.saveShoppingList(_shoppingItems);
                  },
                ),
            ],
          ),
          body: _shoppingItems.isEmpty
              ? const Center(
                  child: Text(
                    'Your shopping list is empty!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: _shoppingItems.length,
                  itemBuilder: (context, index) {
                    final item = _shoppingItems[index];
                    return Dismissible(
                      key: Key(item.name + index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _removeItem(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: CheckboxListTile(
                        value: item.isChecked,
                        onChanged: (value) {
                          _toggleItemChecked(index);
                        },
                        title: Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        subtitle: Text(
                          '${item.quantity.toStringAsFixed(1)} ${item.unit}',
                          style: Theme.of(context).textTheme.bodyMedium,
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
