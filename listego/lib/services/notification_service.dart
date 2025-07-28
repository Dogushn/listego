import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/item_model.dart';
import '../models/shopping_list_model.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  NotificationService._internal();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }

  // Schedule reminder for a specific item
  Future<void> scheduleItemReminder(ShoppingItem item, ShoppingList list) async {
    if (item.reminderDate == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'listego_reminders',
      'ListeGo Reminders',
      channelDescription: 'Reminders for shopping list items',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      item.id.hashCode,
      'Shopping Reminder',
      'Don\'t forget to buy: ${item.name}',
      tz.TZDateTime.from(item.reminderDate!, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '${list.id}|${item.id}',
    );
  }

  // Cancel reminder for a specific item
  Future<void> cancelItemReminder(String itemId) async {
    await _notifications.cancel(itemId.hashCode);
  }

  // Schedule reminder for an entire list
  Future<void> scheduleListReminder(ShoppingList list, DateTime reminderDate) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'listego_list_reminders',
      'ListeGo List Reminders',
      channelDescription: 'Reminders for shopping lists',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      list.id.hashCode,
      'Shopping List Reminder',
      'Time to shop: ${list.name}',
      tz.TZDateTime.from(reminderDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: list.id,
    );
  }

  // Cancel reminder for a list
  Future<void> cancelListReminder(String listId) async {
    await _notifications.cancel(listId.hashCode);
  }

  // Show completion notification when a list is completed
  Future<void> showCompletionNotification(ShoppingList list) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'listego_completion',
      'ListeGo Completion',
      channelDescription: 'Notifications for completed shopping lists',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      list.id.hashCode + 1000, // Different ID to avoid conflicts
      'Shopping Complete!',
      'Congratulations! You\'ve completed your shopping list: ${list.name}',
      details,
      payload: list.id,
    );
  }

  // Show a simple notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'listego_general',
      'ListeGo General',
      channelDescription: 'General notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Check if notifications are supported
  Future<bool> areNotificationsSupported() async {
    final isSupported = await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();
    return isSupported ?? false;
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    final granted = await androidImplementation?.requestNotificationsPermission();
    return granted ?? false;
  }
} 