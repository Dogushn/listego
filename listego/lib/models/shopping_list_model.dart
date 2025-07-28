import 'package:hive/hive.dart';
import 'item_model.dart';

part 'shopping_list_model.g.dart';

@HiveType(typeId: 1)
class ShoppingList extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  List<ShoppingItem> items;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isArchived;

  ShoppingList({
    required this.id,
    required this.name,
    this.description,
    List<ShoppingItem>? items,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  }) : items = items ?? [];

  // Computed properties
  int get totalItems => items.length;
  
  int get completedItems => items.where((item) => item.isCompleted).length;
  
  int get pendingItems => totalItems - completedItems;
  
  double get completionPercentage => 
      totalItems > 0 ? (completedItems / totalItems) * 100 : 0;

  bool get isCompleted => totalItems > 0 && completedItems == totalItems;

  // Copy with method for immutable updates
  ShoppingList copyWith({
    String? id,
    String? name,
    String? description,
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  // Item management methods
  void addItem(ShoppingItem item) {
    items.add(item);
    updatedAt = DateTime.now();
  }

  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    updatedAt = DateTime.now();
  }

  void updateItem(ShoppingItem updatedItem) {
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      updatedAt = DateTime.now();
    }
  }

  void toggleItemCompletion(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = items[index];
      items[index] = item.copyWith(
        isCompleted: !item.isCompleted,
        updatedAt: DateTime.now(),
      );
      updatedAt = DateTime.now();
    }
  }

  void clearCompletedItems() {
    items.removeWhere((item) => item.isCompleted);
    updatedAt = DateTime.now();
  }

  // JSON serialization for data export/import
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isArchived': isArchived,
    };
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      items: (json['items'] as List)
          .map((itemJson) => ShoppingItem.fromJson(itemJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isArchived: json['isArchived'] ?? false,
    );
  }

  // Factory method for creating new lists
  factory ShoppingList.create({
    required String name,
    String? description,
  }) {
    final now = DateTime.now();
    return ShoppingList(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Duplicate list with new items (reset completion status)
  ShoppingList duplicate() {
    final now = DateTime.now();
    return ShoppingList(
      id: now.millisecondsSinceEpoch.toString(),
      name: '$name (Copy)',
      description: description,
      items: items.map((item) => ShoppingItem.create(
        name: item.name,
        quantity: item.quantity,
        notes: item.notes,
        reminderDate: item.reminderDate,
      )).toList(),
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  String toString() {
    return 'ShoppingList(id: $id, name: $name, items: ${items.length}, completed: $completedItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingList && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 