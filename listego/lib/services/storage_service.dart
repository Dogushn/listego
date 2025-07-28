import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';
import '../models/shopping_list_model.dart';
import '../models/app_settings.dart';
import '../utils/constants.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._internal();
  
  StorageService._internal();

  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ShoppingItemAdapter());
    Hive.registerAdapter(ShoppingListAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    
    // Open boxes
    await Hive.openBox<ShoppingList>(AppConstants.shoppingListsBox);
    print('Opened shoppingListsBox');
    await Hive.openBox<AppSettings>(AppConstants.settingsBox);
    print('Opened settingsBox');
    print('StorageService.initialize() complete');
  }

  // Shopping Lists Operations
  Future<List<ShoppingList>> getAllShoppingLists() async {
    final box = Hive.box<ShoppingList>(AppConstants.shoppingListsBox);
    return box.values.toList();
  }

  Future<ShoppingList?> getShoppingList(String id) async {
    final box = Hive.box<ShoppingList>(AppConstants.shoppingListsBox);
    return box.get(id);
  }

  Future<void> saveShoppingList(ShoppingList list) async {
    final box = Hive.box<ShoppingList>(AppConstants.shoppingListsBox);
    await box.put(list.id, list);
  }

  Future<void> updateShoppingList(ShoppingList list) async {
    final box = Hive.box<ShoppingList>(AppConstants.shoppingListsBox);
    await box.put(list.id, list);
  }

  Future<void> deleteShoppingList(String id) async {
    final box = Hive.box<ShoppingList>(AppConstants.shoppingListsBox);
    await box.delete(id);
  }

  Future<void> archiveShoppingList(String id) async {
    final list = await getShoppingList(id);
    if (list != null) {
      final archivedList = list.copyWith(
        isArchived: true,
        updatedAt: DateTime.now(),
      );
      await updateShoppingList(archivedList);
    }
  }

  Future<void> unarchiveShoppingList(String id) async {
    final list = await getShoppingList(id);
    if (list != null) {
      final unarchivedList = list.copyWith(
        isArchived: false,
        updatedAt: DateTime.now(),
      );
      await updateShoppingList(unarchivedList);
    }
  }

  // Item Operations within Lists
  Future<void> addItemToList(String listId, ShoppingItem item) async {
    final list = await getShoppingList(listId);
    if (list != null) {
      list.addItem(item);
      await updateShoppingList(list);
    }
  }

  Future<void> updateItemInList(String listId, ShoppingItem item) async {
    final list = await getShoppingList(listId);
    if (list != null) {
      list.updateItem(item);
      await updateShoppingList(list);
    }
  }

  Future<void> removeItemFromList(String listId, String itemId) async {
    final list = await getShoppingList(listId);
    if (list != null) {
      list.removeItem(itemId);
      await updateShoppingList(list);
    }
  }

  Future<void> toggleItemCompletion(String listId, String itemId) async {
    final list = await getShoppingList(listId);
    if (list != null) {
      list.toggleItemCompletion(itemId);
      await updateShoppingList(list);
    }
  }

  Future<void> clearCompletedItems(String listId) async {
    final list = await getShoppingList(listId);
    if (list != null) {
      list.clearCompletedItems();
      await updateShoppingList(list);
    }
  }

  // Utility Methods
  Future<List<ShoppingList>> getActiveLists() async {
    final allLists = await getAllShoppingLists();
    return allLists.where((list) => !list.isArchived).toList();
  }

  Future<List<ShoppingList>> getArchivedLists() async {
    final allLists = await getAllShoppingLists();
    return allLists.where((list) => list.isArchived).toList();
  }

  Future<void> duplicateShoppingList(String id) async {
    final originalList = await getShoppingList(id);
    if (originalList != null) {
      final duplicatedList = originalList.duplicate();
      await saveShoppingList(duplicatedList);
    }
  }

  Future<void> clearAllData() async {
    final box = Hive.box<ShoppingList>(AppConstants.shoppingListsBox);
    await box.clear();
  }

  Future<void> close() async {
    await Hive.close();
  }

  // Settings Operations
  Future<AppSettings> getSettings() async {
    final box = Hive.box<AppSettings>(AppConstants.settingsBox);
    final settings = box.get('app_settings');
    return settings ?? AppSettings.create();
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box<AppSettings>(AppConstants.settingsBox);
    await box.put('app_settings', settings);
  }

  Future<void> updateSettings(AppSettings settings) async {
    await saveSettings(settings);
  }

  Future<void> resetSettings() async {
    final defaultSettings = AppSettings.create();
    await saveSettings(defaultSettings);
  }

  // Data Export/Import (for future implementation)
  Future<String> exportData() async {
    final lists = await getAllShoppingLists();
    final settings = await getSettings();
    final data = {
      'lists': lists.map((list) => list.toJson()).toList(),
      'settings': settings.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
    return data.toString(); // In a real app, you'd use proper JSON serialization
  }

  Future<void> importData(String data) async {
    // Implementation for importing data
    // This would parse the data and restore lists and settings
    print('Import functionality to be implemented');
  }
} 