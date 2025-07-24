// File: test/widget_tests/search_bar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/ui/widgets/search_bar.dart' as custom;

void main() {
  group('SearchBar Widget Tests', () {
    testWidgets('SearchBar updates on input', (WidgetTester tester) async {
      // Arrange
      String? searchQuery;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.SearchBar(
              onSearch: (query) {
                searchQuery = query;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'Test Query');
      await tester.pump();

      // Assert
      expect(searchQuery, equals('Test Query'));
      expect(find.text('Test Query'), findsOneWidget);
    });

    testWidgets('SearchBar clears input on clear button', (WidgetTester tester) async {
      // Arrange
      String? searchQuery;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.SearchBar(
              onSearch: (query) {
                searchQuery = query;
              },
              initialQuery: 'Initial Query',
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert
      expect(searchQuery, equals(''));
      expect(find.text('Initial Query'), findsNothing);
    });
  });
}
