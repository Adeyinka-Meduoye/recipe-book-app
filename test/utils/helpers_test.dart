// File: test/utils/helpers_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/utils/helpers.dart';

void main() {
  group('Helpers Tests', () {
    test('formatDuration formats minutes correctly', () {
      expect(Helpers.formatDuration(30), equals('30 min'));
      expect(Helpers.formatDuration(60), equals('1 hr'));
      expect(Helpers.formatDuration(90), equals('1 hr 30 min'));
    });

    test('capitalize formats string correctly', () {
      expect(Helpers.capitalize('spaghetti'), equals('Spaghetti'));
      expect(Helpers.capitalize('ITALIAN'), equals('Italian'));
      expect(Helpers.capitalize(''), equals(''));
    });

    test('isValidSearchQuery validates queries correctly', () {
      expect(Helpers.isValidSearchQuery('spaghetti'), isTrue);
      expect(Helpers.isValidSearchQuery('s'), isFalse);
      expect(Helpers.isValidSearchQuery('  '), isFalse);
    });

    test('formatDate formats date correctly', () {
      final date = DateTime(2025, 1, 24);
      expect(Helpers.formatDate(date), equals('Jan 24, 2025'));
    });

    test('formatQuantity formats quantity correctly', () {
      expect(Helpers.formatQuantity(1.50), equals('1.5'));
      expect(Helpers.formatQuantity(2.0), equals('2.0'));
      expect(Helpers.formatQuantity(3.333, decimalPlaces: 2), equals('3.33'));
    });
  });
}