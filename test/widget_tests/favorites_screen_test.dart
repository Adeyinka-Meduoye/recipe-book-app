import 'package:adeyinka_recipe_book_app/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/favorites_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/theme/app_theme.dart';


void main() {
  group('FavoritesScreen Widget Tests', () {
    testWidgets('FavoritesScreen displays empty state when no favorites', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: FavoritesScreen(onThemeToggle: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No favorite recipes yet!'), findsOneWidget);
    });

    testWidgets('FavoritesScreen toggles theme via drawer', (WidgetTester tester) async {
      bool themeToggled = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: FavoritesScreen(
            onThemeToggle: () {
              themeToggled = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Toggle Theme'));
      await tester.pumpAndSettle();

      expect(themeToggled, isTrue);
    });

    testWidgets('FavoritesScreen navigates to other screens via drawer', (WidgetTester tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => HomeScreen(onThemeToggle: () {}),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => FavoritesScreen(onThemeToggle: () {}),
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

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}