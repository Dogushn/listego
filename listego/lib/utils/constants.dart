// App-wide constants for ListeGo

class AppConstants {
  // Hive Box Names
  static const String shoppingListsBox = 'shopping_lists';
  static const String settingsBox = 'settings';
  
  // Default Values
  static const int defaultQuantity = 1;
  static const int defaultReminderMinutes = 30;
  static const String defaultThemeMode = 'system';
  static const bool defaultShowCompletedItems = true;
  static const String defaultSortOrder = 'created';
  
  // Notification Channels
  static const String reminderChannelId = 'listego_reminders';
  static const String reminderChannelName = 'ListeGo Reminders';
  static const String reminderChannelDescription = 'Reminders for shopping list items';
  
  static const String completionChannelId = 'listego_completion';
  static const String completionChannelName = 'ListeGo Completion';
  static const String completionChannelDescription = 'Notifications for completed shopping lists';
  
  // App Info
  static const String appName = 'ListeGo';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Smart Shopping Lists';
  
  // Theme Colors
  static const int primaryColorValue = 0xFF6750A4; // Purple
  static const int secondaryColorValue = 0xFF625B71; // Dark purple
  static const int tertiaryColorValue = 0xFF7D5260; // Brown
  
  // Animation Durations
  static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  
  // Validation Rules
  static const int minItemNameLength = 2;
  static const int maxItemNameLength = 100;
  static const int maxItemNotesLength = 500;
  static const int maxListNameLength = 50;
  static const int maxListDescriptionLength = 200;
  
  // Quick Items for Add Item Screen
  static const List<String> quickItems = [
    'Milk',
    'Bread',
    'Eggs',
    'Bananas',
    'Chicken',
    'Rice',
    'Tomatoes',
    'Onions',
    'Apples',
    'Cheese',
  ];
  
  // List Templates
  static const Map<String, String> listTemplates = {
    'Grocery Shopping': 'Weekly grocery items',
    'Party Supplies': 'Items for upcoming party',
    'Home Improvement': 'Tools and materials for DIY projects',
    'Gift Shopping': 'Birthday and holiday gifts',
    'Office Supplies': 'Work and office essentials',
  };
} 