import 'package:flutter_test/flutter_test.dart';
import 'package:listego/models/shopping_list_model.dart';
import 'package:listego/models/item_model.dart';

void main() {
  group('ShoppingList Duplicate Checking', () {
    late ShoppingList shoppingList;
    late ShoppingItem item1;
    late ShoppingItem item2;

    setUp(() {
      shoppingList = ShoppingList.create(name: 'Test List');
      
      // Create items with explicit IDs to avoid timing issues
      final now = DateTime.now();
      item1 = ShoppingItem(
        id: '${now.millisecondsSinceEpoch}',
        name: 'Milk',
        quantity: 1,
        createdAt: now,
        updatedAt: now,
      );
      item2 = ShoppingItem(
        id: '${now.millisecondsSinceEpoch + 1}',
        name: 'Bread',
        quantity: 2,
        createdAt: now,
        updatedAt: now,
      );
    });

    test('should detect duplicate items by name (case insensitive)', () {
      // Add first item
      shoppingList.addItem(item1);
      
      // Check if item with same name exists
      expect(shoppingList.hasItemWithName('Milk'), isTrue);
      expect(shoppingList.hasItemWithName('milk'), isTrue);
      expect(shoppingList.hasItemWithName(' MILK '), isTrue);
      
      // Check if item with different name exists
      expect(shoppingList.hasItemWithName('Bread'), isFalse);
      expect(shoppingList.hasItemWithName('Cheese'), isFalse);
    });

    test('should get existing item with same name', () {
      // Add first item
      shoppingList.addItem(item1);
      
      // Get existing item
      final existingItem = shoppingList.getItemWithName('Milk');
      expect(existingItem, isNotNull);
      expect(existingItem!.name, equals('Milk'));
      expect(existingItem.quantity, equals(1));
      
      // Get non-existing item
      final nonExistingItem = shoppingList.getItemWithName('Bread');
      expect(nonExistingItem, isNull);
    });

    test('should handle multiple items with different names', () {
      // Add multiple items
      shoppingList.addItem(item1);
      shoppingList.addItem(item2);
      
      // Check each item
      expect(shoppingList.hasItemWithName('Milk'), isTrue);
      expect(shoppingList.hasItemWithName('Bread'), isTrue);
      expect(shoppingList.hasItemWithName('Cheese'), isFalse);
      
      // Get each item
      final milkItem = shoppingList.getItemWithName('Milk');
      final breadItem = shoppingList.getItemWithName('Bread');
      
      expect(milkItem, isNotNull);
      expect(breadItem, isNotNull);
      expect(milkItem!.name, equals('Milk'));
      expect(breadItem!.name, equals('Bread'));
    });

    test('should handle empty list', () {
      // Check empty list
      expect(shoppingList.hasItemWithName('Milk'), isFalse);
      expect(shoppingList.getItemWithName('Milk'), isNull);
    });

    test('should handle whitespace in item names', () {
      // Add item with whitespace
      final itemWithWhitespace = ShoppingItem(
        id: 'test_id',
        name: '  Milk  ',
        quantity: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      shoppingList.addItem(itemWithWhitespace);
      
      // Check with different whitespace variations
      expect(shoppingList.hasItemWithName('Milk'), isTrue);
      expect(shoppingList.hasItemWithName('  Milk  '), isTrue);
      expect(shoppingList.hasItemWithName('milk'), isTrue);
      expect(shoppingList.hasItemWithName(' MILK '), isTrue);
    });
  });
} 