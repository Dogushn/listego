import 'package:flutter/foundation.dart';
import '../models/item_model.dart';
import '../models/shopping_list_model.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class ShoppingListProvider with ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final NotificationService _notificationService = NotificationService.instance;
  
  List<ShoppingList> _shoppingLists = [];
  ShoppingList? _currentList;
  bool _isLoading = false;

  // Getters
  List<ShoppingList> get shoppingLists => _shoppingLists;
  List<ShoppingList> get activeLists => _shoppingLists.where((list) => !list.isArchived).toList();
  List<ShoppingList> get archivedLists => _shoppingLists.where((list) => list.isArchived).toList();
  ShoppingList? get currentList => _currentList;
  bool get isLoading => _isLoading;

  // Load all shopping lists
  Future<void> loadShoppingLists() async {
    _setLoading(true);
    try {
      _shoppingLists = await _storageService.getAllShoppingLists();
      notifyListeners();
    } catch (e) {
      print('Error loading shopping lists: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create new shopping list
  Future<void> createShoppingList(String name, {String? description}) async {
    _setLoading(true);
    try {
      final newList = ShoppingList.create(name: name, description: description);
      await _storageService.saveShoppingList(newList);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error creating shopping list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update shopping list
  Future<void> updateShoppingList(ShoppingList list) async {
    _setLoading(true);
    try {
      await _storageService.updateShoppingList(list);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error updating shopping list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Delete shopping list
  Future<void> deleteShoppingList(String id) async {
    _setLoading(true);
    try {
      await _storageService.deleteShoppingList(id);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error deleting shopping list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Archive shopping list
  Future<void> archiveShoppingList(String id) async {
    _setLoading(true);
    try {
      await _storageService.archiveShoppingList(id);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error archiving shopping list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Unarchive shopping list
  Future<void> unarchiveShoppingList(String id) async {
    _setLoading(true);
    try {
      await _storageService.unarchiveShoppingList(id);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error unarchiving shopping list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Set current list
  void setCurrentList(ShoppingList? list) {
    _currentList = list;
    notifyListeners();
  }

  // Add item to current list
  Future<void> addItemToCurrentList(ShoppingItem item) async {
    if (_currentList == null) return;
    
    _setLoading(true);
    try {
      await _storageService.addItemToList(_currentList!.id, item);
      
      // Schedule notification if reminder is set
      if (item.reminderDate != null) {
        try {
          await _notificationService.scheduleItemReminder(item, _currentList!);
        } catch (e) {
          print('Failed to schedule notification: $e');
        }
      }
      
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error adding item to list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update item in current list
  Future<void> updateItemInCurrentList(ShoppingItem item) async {
    if (_currentList == null) return;
    
    _setLoading(true);
    try {
      await _storageService.updateItemInList(_currentList!.id, item);
      
      // Update notification if reminder changed
      if (item.reminderDate != null) {
        try {
          await _notificationService.scheduleItemReminder(item, _currentList!);
        } catch (e) {
          print('Failed to update notification: $e');
        }
      } else {
        try {
          await _notificationService.cancelItemReminder(item.id);
        } catch (e) {
          print('Failed to cancel notification: $e');
        }
      }
      
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error updating item in list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Remove item from current list
  Future<void> removeItemFromCurrentList(String itemId) async {
    if (_currentList == null) return;
    
    _setLoading(true);
    try {
      await _storageService.removeItemFromList(_currentList!.id, itemId);
      
      // Cancel notification for this item
      try {
        await _notificationService.cancelItemReminder(itemId);
      } catch (e) {
        print('Failed to cancel notification: $e');
      }
      
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error removing item from list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle item completion
  Future<void> toggleItemCompletion(String itemId) async {
    if (_currentList == null) return;
    
    _setLoading(true);
    try {
      await _storageService.toggleItemCompletion(_currentList!.id, itemId);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error toggling item completion: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Clear completed items
  Future<void> clearCompletedItems() async {
    if (_currentList == null) return;
    
    _setLoading(true);
    try {
      await _storageService.clearCompletedItems(_currentList!.id);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error clearing completed items: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Duplicate shopping list
  Future<void> duplicateShoppingList(String id) async {
    _setLoading(true);
    try {
      await _storageService.duplicateShoppingList(id);
      await loadShoppingLists(); // Refresh the list
    } catch (e) {
      print('Error duplicating shopping list: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 