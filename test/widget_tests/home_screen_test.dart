import 'package:adeyinka_recipe_book_app/ui/widgets/category_tile.dart';
import 'package:adeyinka_recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/home_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/recipe_list_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/theme/app_theme.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen displays carousel, categories, and featured recipes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: HomeScreen(onThemeToggle: () {}),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Featured Recipes'), findsOneWidget);
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.byType(CategoryTile), findsWidgets);
      expect(find.byType(RecipeCard), findsWidgets);
      expect(find.byType(SearchBar), findsOneWidget);
    });

    testWidgets('HomeScreen navigates to RecipeListScreen on search', (WidgetTester tester) async {
      final router = GoRouter(
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
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(SearchBar), 'Spaghetti');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.byType(RecipeListScreen), findsOneWidget);
    });

    testWidgets('HomeScreen toggles theme via drawer', (WidgetTester tester) async {
      bool themeToggled = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: HomeScreen(
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
  });
}