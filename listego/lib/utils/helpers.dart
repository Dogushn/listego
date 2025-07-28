import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class Helpers {
  // Date and Time Formatting
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y h:mm a').format(dateTime);
  }
  
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);
    
    if (itemDate == today) {
      return 'Today at ${formatTime(TimeOfDay.fromDateTime(date))}';
    } else if (itemDate == tomorrow) {
      return 'Tomorrow at ${formatTime(TimeOfDay.fromDateTime(date))}';
    } else {
      return formatDateTime(date);
    }
  }
  
  // Input Validation
  static String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an item name';
    }
    if (value.trim().length < AppConstants.minItemNameLength) {
      return 'Item name must be at least ${AppConstants.minItemNameLength} characters';
    }
    if (value.trim().length > AppConstants.maxItemNameLength) {
      return 'Item name must be less than ${AppConstants.maxItemNameLength} characters';
    }
    return null;
  }
  
  static String? validateListName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a list name';
    }
    if (value.trim().length < AppConstants.minItemNameLength) {
      return 'List name must be at least ${AppConstants.minItemNameLength} characters';
    }
    if (value.trim().length > AppConstants.maxListNameLength) {
      return 'List name must be less than ${AppConstants.maxListNameLength} characters';
    }
    return null;
  }
  
  static String? validateNotes(String? value) {
    if (value != null && value.trim().length > AppConstants.maxItemNotesLength) {
      return 'Notes must be less than ${AppConstants.maxItemNotesLength} characters';
    }
    return null;
  }
  
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a quantity';
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity < 1) {
      return 'Quantity must be a positive number';
    }
    if (quantity > 999) {
      return 'Quantity must be less than 1000';
    }
    return null;
  }
  
  // String Utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  // Color Utilities
  static Color getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
  
  // Progress Calculation
  static double calculateProgress(int completed, int total) {
    if (total == 0) return 0.0;
    return completed / total;
  }
  
  static String getProgressText(int completed, int total) {
    return '$completed/$total';
  }
  
  // List Sorting
  static List<T> sortByDate<T>(List<T> items, DateTime Function(T) getDate, {bool ascending = false}) {
    items.sort((a, b) {
      final dateA = getDate(a);
      final dateB = getDate(b);
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    return items;
  }
  
  static List<T> sortByName<T>(List<T> items, String Function(T) getName) {
    items.sort((a, b) => getName(a).toLowerCase().compareTo(getName(b).toLowerCase()));
    return items;
  }
  
  // Notification Utilities
  static String generateNotificationId(String prefix, String id) {
    return '${prefix}_${id.hashCode}';
  }
  
  // Error Handling
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error.toString().contains('permission')) {
      return 'Permission denied. Please check app permissions.';
    }
    if (error.toString().contains('network')) {
      return 'Network error. Please check your connection.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
  
  // UI Utilities
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
} 