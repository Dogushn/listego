import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listego/models/shopping_list_model.dart';
import 'package:listego/models/item_model.dart';
import 'package:listego/screens/add_item_screen.dart';

void main() {
  group('AddItemScreen Edit Functionality', () {
    late ShoppingList testList;
    late ShoppingItem testItem;

    setUp(() {
      testList = ShoppingList.create(name: 'Test List');
      
      // Create item with explicit ID
      final now = DateTime.now();
      testItem = ShoppingItem(
        id: '${now.millisecondsSinceEpoch}',
        name: 'Test Item',
        quantity: 2,
        notes: 'Test notes',
        reminderDate: DateTime.now().add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
    });

    testWidgets('should populate form when editing existing item', (WidgetTester tester) async {
      // Build the widget with an item to edit
      await tester.pumpWidget(
        MaterialApp(
          home: AddItemScreen(
            list: testList,
            itemToEdit: testItem,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the form is populated with the item's data
      expect(find.text('Test Item'), findsOneWidget);
      expect(find.text('Test notes'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should show correct title when editing', (WidgetTester tester) async {
      // Build the widget with an item to edit
      await tester.pumpWidget(
        MaterialApp(
          home: AddItemScreen(
            list: testList,
            itemToEdit: testItem,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the app bar shows "Edit Item"
      expect(find.text('Edit Item'), findsOneWidget);
    });

    testWidgets('should show correct title when adding new item', (WidgetTester tester) async {
      // Build the widget without an item to edit
      await tester.pumpWidget(
        MaterialApp(
          home: AddItemScreen(
            list: testList,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the app bar shows "Add Item"
      expect(find.text('Add Item'), findsOneWidget);
    });

    testWidgets('should show correct button text when editing', (WidgetTester tester) async {
      // Build the widget with an item to edit
      await tester.pumpWidget(
        MaterialApp(
          home: AddItemScreen(
            list: testList,
            itemToEdit: testItem,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the floating action button shows "Update Item"
      expect(find.text('Update Item'), findsOneWidget);
    });

    testWidgets('should show correct button text when adding new item', (WidgetTester tester) async {
      // Build the widget without an item to edit
      await tester.pumpWidget(
        MaterialApp(
          home: AddItemScreen(
            list: testList,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the floating action button shows "Save Item"
      expect(find.text('Save Item'), findsOneWidget);
    });
  });
} 