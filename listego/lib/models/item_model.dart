import 'package:hive/hive.dart';

part 'item_model.g.dart';

@HiveType(typeId: 0)
class ShoppingItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime? reminderDate;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isCompleted = false,
    this.reminderDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Copy with method for immutable updates
  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    bool? isCompleted,
    DateTime? reminderDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderDate: reminderDate ?? this.reminderDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // JSON serialization for data export/import
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isCompleted': isCompleted,
      'reminderDate': reminderDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      isCompleted: json['isCompleted'],
      reminderDate: json['reminderDate'] != null 
          ? DateTime.parse(json['reminderDate']) 
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Factory method for creating new items
  factory ShoppingItem.create({
    required String name,
    int quantity = 1,
    String? notes,
    DateTime? reminderDate,
  }) {
    final now = DateTime.now();
    return ShoppingItem(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      quantity: quantity,
      notes: notes,
      reminderDate: reminderDate,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, quantity: $quantity, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 