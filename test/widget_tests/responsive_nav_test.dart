// File: test/widget_tests/responsive_nav_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/ui/screens/home_screen.dart';
import 'package:recipe_book_app/ui/screens/recipe_list_screen.dart';
import 'package:recipe_book_app/ui/widgets/responsive_nav.dart';
import 'package:recipe_book_app/ui/theme/app_theme.dart';

void main() {
  group('ResponsiveNav Widget Tests', () {
    testWidgets('BottomNavigationBar navigates to correct screen on mobile', (WidgetTester tester) async {
      int selectedIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ResponsiveNav(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              selectedIndex = index;
            },
            onThemeToggle: () {},
            child: selectedIndex == 0
                ? HomeScreen(onThemeToggle: () {})
                : const RecipeListScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      await tester.tap(find.text('Recipes')); // Tap "Recipes" item
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });
  });
}