import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../models/app_settings.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final NotificationService _notificationService = NotificationService.instance;
  
  // Settings state
  AppSettings? _settings;
  bool _isLoading = false;

  // Getters
  AppSettings? get settings => _settings;
  bool get enableNotifications => _settings?.enableNotifications ?? true;
  bool get enableReminders => _settings?.enableReminders ?? true;
  int get reminderTimeInMinutes => _settings?.reminderTimeInMinutes ?? 30;
  String get themeMode => _settings?.themeMode ?? 'system';
  bool get showCompletedItems => _settings?.showCompletedItems ?? true;
  String get sortOrder => _settings?.sortOrder ?? 'created';
  bool get autoArchiveCompletedLists => _settings?.autoArchiveCompletedLists ?? false;
  int get autoArchiveDays => _settings?.autoArchiveDays ?? 7;
  bool get isLoading => _isLoading;

  // Load settings
  Future<void> loadSettings() async {
    _setLoading(true);
    try {
      _settings = await _storageService.getSettings();
      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
      _settings = AppSettings.create();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update notification settings
  Future<void> updateNotificationSettings({
    bool? enableNotifications,
    bool? enableReminders,
    int? reminderTimeInMinutes,
  }) async {
    _setLoading(true);
    try {
      if (_settings == null) {
        _settings = AppSettings.create();
      }
      
      if (enableNotifications != null) {
        _settings!.enableNotifications = enableNotifications;
        
        if (enableNotifications) {
          final granted = await _notificationService.requestPermissions();
          if (!granted) {
            _settings!.enableNotifications = false;
            print('Notification permissions not granted');
          }
        } else {
          await _notificationService.cancelAllNotifications();
        }
      }
      
      if (enableReminders != null) {
        _settings!.enableReminders = enableReminders;
      }
      
      if (reminderTimeInMinutes != null) {
        _settings!.reminderTimeInMinutes = reminderTimeInMinutes;
      }
      
      await _saveSettings();
      notifyListeners();
    } catch (e) {
      print('Error updating notification settings: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update theme settings
  Future<void> updateThemeSettings({
    String? themeMode,
    bool? showCompletedItems,
  }) async {
    _setLoading(true);
    try {
      if (_settings == null) {
        _settings = AppSettings.create();
      }
      
      if (themeMode != null) {
        _settings!.themeMode = themeMode;
      }
      
      if (showCompletedItems != null) {
        _settings!.showCompletedItems = showCompletedItems;
      }
      
      await _saveSettings();
      notifyListeners();
    } catch (e) {
      print('Error updating theme settings: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update list settings
  Future<void> updateListSettings({
    String? sortOrder,
    bool? autoArchiveCompletedLists,
    int? autoArchiveDays,
  }) async {
    _setLoading(true);
    try {
      if (_settings == null) {
        _settings = AppSettings.create();
      }
      
      if (sortOrder != null) {
        _settings!.sortOrder = sortOrder;
      }
      
      if (autoArchiveCompletedLists != null) {
        _settings!.autoArchiveCompletedLists = autoArchiveCompletedLists;
      }
      
      if (autoArchiveDays != null) {
        _settings!.autoArchiveDays = autoArchiveDays;
      }
      
      await _saveSettings();
      notifyListeners();
    } catch (e) {
      print('Error updating list settings: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Reset settings to defaults
  Future<void> resetSettings() async {
    _setLoading(true);
    try {
      _settings = AppSettings.create();
      await _saveSettings();
      notifyListeners();
    } catch (e) {
      print('Error resetting settings: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Save settings
  Future<void> _saveSettings() async {
    try {
      if (_settings != null) {
        await _storageService.saveSettings(_settings!);
      }
    } catch (e) {
      print('Error saving settings: $e');
      rethrow;
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Convenience getters for theme
  bool get isDarkMode => themeMode == 'dark';
  bool get isLightMode => themeMode == 'light';
  bool get isSystemMode => themeMode == 'system';

  // Convenience getters for notifications
  bool get notificationsEnabled => enableNotifications && enableReminders;
} 