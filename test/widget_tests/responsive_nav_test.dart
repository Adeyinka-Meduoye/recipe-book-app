// File: test/widget_tests/responsive_nav_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/home_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/recipe_list_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/responsive_nav.dart';
import 'package:adeyinka_recipe_book_app/ui/theme/app_theme.dart';

void main() {
  group('ResponsiveNav Widget Tests', () {
    testWidgets('BottomNavigationBar navigates to correct screen on mobile', (WidgetTester tester) async {
      int selectedIndex = 0;
      final router = GoRouter(
        routes: [
          ShellRoute(
            builder: (context, state, child) => ResponsiveNav(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                selectedIndex = index;
              },
              onThemeToggle: () {},
              child: child,
            ),
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => HomeScreen(onThemeToggle: () {}),
              ),
              GoRoute(
                path: '/recipes',
                builder: (context, state) => const RecipeListScreen(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      await tester.tap(find.text('Recipes'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
      expect(find.byType(RecipeListScreen), findsOneWidget);
    });
  });
}