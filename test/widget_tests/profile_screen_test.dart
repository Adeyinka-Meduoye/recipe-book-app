import 'package:adeyinka_recipe_book_app/ui/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:adeyinka_recipe_book_app/data/services/storage_service.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/profile_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/home_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/screens/recipe_detail_screen.dart';
import 'package:adeyinka_recipe_book_app/ui/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());
    });

    testWidgets('ProfileScreen displays form and empty favorites', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProfileScreen(onThemeToggle: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('User Profile'), findsOneWidget);
      expect(find.text('Favorite Recipes'), findsOneWidget);
      expect(find.text('No favorite recipes yet!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Dietary Preferences'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsWidgets);
      expect(find.text('Save Profile'), findsOneWidget);
    });

    testWidgets('ProfileScreen saves user preferences with chip input', (WidgetTester tester) async {
      final storageService = StorageService();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProfileScreen(onThemeToggle: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // Enter name and email
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');

      // Select dietary preferences
      await tester.tap(find.text('Vegetarian'));
      await tester.tap(find.text('Gluten-Free'));
      await tester.pumpAndSettle();

      // Save profile
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile updated'), findsOneWidget);
      final userPrefs = await storageService.getUserPrefs();
      expect(userPrefs['name'], 'John Doe');
      expect(userPrefs['email'], 'john@example.com');
      expect(userPrefs['dietaryPreferences'], 'Vegetarian,Gluten-Free');
    });

    testWidgets('ProfileScreen validates dietary preferences', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProfileScreen(onThemeToggle: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // Enter name and email but no dietary preferences
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Please select at least one dietary preference or "None"'), findsOneWidget);
    });

    testWidgets('ProfileScreen loads saved dietary preferences', (WidgetTester tester) async {
      final storageService = StorageService();
      await storageService.saveUserPrefs({
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'dietaryPreferences': 'Vegan,Dairy-Free',
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProfileScreen(onThemeToggle: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is ChoiceChip && widget.label is Text && (widget.label as Text).data == 'Vegan' && widget.selected), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is ChoiceChip && widget.label is Text && (widget.label as Text).data == 'Dairy-Free' && widget.selected), findsOneWidget);
    });

    testWidgets('ProfileScreen displays favorite recipes', (WidgetTester tester) async {
      final storageService = StorageService();
      await storageService.saveFavorites(['1']);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProfileScreen(onThemeToggle: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RecipeCard), findsOneWidget);
      expect(find.text('Spaghetti Bolognese'), findsOneWidget);
    });

    testWidgets('ProfileScreen navigates to RecipeDetailScreen on recipe tap', (WidgetTester tester) async {
      final storageService = StorageService();
      await storageService.saveFavorites(['1']);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(onThemeToggle: () {}),
          ),
          GoRoute(
            path: '/recipe/:id',
            builder: (context, state) => RecipeDetailScreen(
              recipeId: state.pathParameters['id']!,
            ),
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

      await tester.tap(find.byType(RecipeCard));
      await tester.pumpAndSettle();

      expect(find.byType(RecipeDetailScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen toggles theme via drawer', (WidgetTester tester) async {
      bool themeToggled = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProfileScreen(
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

    testWidgets('ProfileScreen navigates to other screens via drawer', (WidgetTester tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => HomeScreen(onThemeToggle: () {}),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(onThemeToggle: () {}),
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