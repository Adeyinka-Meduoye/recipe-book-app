import 'package:flutter/material.dart';
import 'package:recipe_book_app/utils/constants.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String initialQuery;

  const SearchBar({
    super.key,
    required this.onSearch,
    this.initialQuery = '',
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _controller.clear();
                widget.onSearch('');
              });
            },
          ),
        ),
        onChanged: widget.onSearch,
        onSubmitted: widget.onSearch,
      ),
    );
  }
}
