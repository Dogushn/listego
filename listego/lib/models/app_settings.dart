import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 2)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool enableNotifications;

  @HiveField(1)
  bool enableReminders;

  @HiveField(2)
  int reminderTimeInMinutes;

  @HiveField(3)
  String themeMode;

  @HiveField(4)
  bool showCompletedItems;

  @HiveField(5)
  String sortOrder;

  @HiveField(6)
  bool autoArchiveCompletedLists;

  @HiveField(7)
  int autoArchiveDays;

  @HiveField(8)
  DateTime? lastBackupDate;

  @HiveField(9)
  bool enableHapticFeedback;

  @HiveField(10)
  bool enableSoundEffects;

  @HiveField(11)
  String languageCode;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime updatedAt;

  AppSettings({
    required this.enableNotifications,
    required this.enableReminders,
    required this.reminderTimeInMinutes,
    required this.themeMode,
    required this.showCompletedItems,
    required this.sortOrder,
    required this.autoArchiveCompletedLists,
    required this.autoArchiveDays,
    this.lastBackupDate,
    required this.enableHapticFeedback,
    required this.enableSoundEffects,
    required this.languageCode,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating default settings
  factory AppSettings.create() {
    final now = DateTime.now();
    return AppSettings(
      enableNotifications: true,
      enableReminders: true,
      reminderTimeInMinutes: 30,
      themeMode: 'system',
      showCompletedItems: true,
      sortOrder: 'created',
      autoArchiveCompletedLists: false,
      autoArchiveDays: 7,
      enableHapticFeedback: true,
      enableSoundEffects: true,
      languageCode: 'en',
      createdAt: now,
      updatedAt: now,
    );
  }

  // Factory constructor from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      enableNotifications: json['enableNotifications'] ?? true,
      enableReminders: json['enableReminders'] ?? true,
      reminderTimeInMinutes: json['reminderTimeInMinutes'] ?? 30,
      themeMode: json['themeMode'] ?? 'system',
      showCompletedItems: json['showCompletedItems'] ?? true,
      sortOrder: json['sortOrder'] ?? 'created',
      autoArchiveCompletedLists: json['autoArchiveCompletedLists'] ?? false,
      autoArchiveDays: json['autoArchiveDays'] ?? 7,
      lastBackupDate: json['lastBackupDate'] != null 
          ? DateTime.parse(json['lastBackupDate']) 
          : null,
      enableHapticFeedback: json['enableHapticFeedback'] ?? true,
      enableSoundEffects: json['enableSoundEffects'] ?? true,
      languageCode: json['languageCode'] ?? 'en',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'enableNotifications': enableNotifications,
      'enableReminders': enableReminders,
      'reminderTimeInMinutes': reminderTimeInMinutes,
      'themeMode': themeMode,
      'showCompletedItems': showCompletedItems,
      'sortOrder': sortOrder,
      'autoArchiveCompletedLists': autoArchiveCompletedLists,
      'autoArchiveDays': autoArchiveDays,
      'lastBackupDate': lastBackupDate?.toIso8601String(),
      'enableHapticFeedback': enableHapticFeedback,
      'enableSoundEffects': enableSoundEffects,
      'languageCode': languageCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with method for immutable updates
  AppSettings copyWith({
    bool? enableNotifications,
    bool? enableReminders,
    int? reminderTimeInMinutes,
    String? themeMode,
    bool? showCompletedItems,
    String? sortOrder,
    bool? autoArchiveCompletedLists,
    int? autoArchiveDays,
    DateTime? lastBackupDate,
    bool? enableHapticFeedback,
    bool? enableSoundEffects,
    String? languageCode,
  }) {
    return AppSettings(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableReminders: enableReminders ?? this.enableReminders,
      reminderTimeInMinutes: reminderTimeInMinutes ?? this.reminderTimeInMinutes,
      themeMode: themeMode ?? this.themeMode,
      showCompletedItems: showCompletedItems ?? this.showCompletedItems,
      sortOrder: sortOrder ?? this.sortOrder,
      autoArchiveCompletedLists: autoArchiveCompletedLists ?? this.autoArchiveCompletedLists,
      autoArchiveDays: autoArchiveDays ?? this.autoArchiveDays,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      languageCode: languageCode ?? this.languageCode,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Update settings with new values
  void update({
    bool? enableNotifications,
    bool? enableReminders,
    int? reminderTimeInMinutes,
    String? themeMode,
    bool? showCompletedItems,
    String? sortOrder,
    bool? autoArchiveCompletedLists,
    int? autoArchiveDays,
    DateTime? lastBackupDate,
    bool? enableHapticFeedback,
    bool? enableSoundEffects,
    String? languageCode,
  }) {
    if (enableNotifications != null) this.enableNotifications = enableNotifications;
    if (enableReminders != null) this.enableReminders = enableReminders;
    if (reminderTimeInMinutes != null) this.reminderTimeInMinutes = reminderTimeInMinutes;
    if (themeMode != null) this.themeMode = themeMode;
    if (showCompletedItems != null) this.showCompletedItems = showCompletedItems;
    if (sortOrder != null) this.sortOrder = sortOrder;
    if (autoArchiveCompletedLists != null) this.autoArchiveCompletedLists = autoArchiveCompletedLists;
    if (autoArchiveDays != null) this.autoArchiveDays = autoArchiveDays;
    if (lastBackupDate != null) this.lastBackupDate = lastBackupDate;
    if (enableHapticFeedback != null) this.enableHapticFeedback = enableHapticFeedback;
    if (enableSoundEffects != null) this.enableSoundEffects = enableSoundEffects;
    if (languageCode != null) this.languageCode = languageCode;
    
    updatedAt = DateTime.now();
  }

  // Reset to default settings
  void resetToDefaults() {
    enableNotifications = true;
    enableReminders = true;
    reminderTimeInMinutes = 30;
    themeMode = 'system';
    showCompletedItems = true;
    sortOrder = 'created';
    autoArchiveCompletedLists = false;
    autoArchiveDays = 7;
    lastBackupDate = null;
    enableHapticFeedback = true;
    enableSoundEffects = true;
    languageCode = 'en';
    updatedAt = DateTime.now();
  }

  // Convenience getters
  bool get isDarkMode => themeMode == 'dark';
  bool get isLightMode => themeMode == 'light';
  bool get isSystemMode => themeMode == 'system';
  bool get notificationsEnabled => enableNotifications && enableReminders;

  @override
  String toString() {
    return 'AppSettings('
        'enableNotifications: $enableNotifications, '
        'enableReminders: $enableReminders, '
        'reminderTimeInMinutes: $reminderTimeInMinutes, '
        'themeMode: $themeMode, '
        'showCompletedItems: $showCompletedItems, '
        'sortOrder: $sortOrder, '
        'autoArchiveCompletedLists: $autoArchiveCompletedLists, '
        'autoArchiveDays: $autoArchiveDays, '
        'enableHapticFeedback: $enableHapticFeedback, '
        'enableSoundEffects: $enableSoundEffects, '
        'languageCode: $languageCode, '
        'updatedAt: $updatedAt'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.enableNotifications == enableNotifications &&
        other.enableReminders == enableReminders &&
        other.reminderTimeInMinutes == reminderTimeInMinutes &&
        other.themeMode == themeMode &&
        other.showCompletedItems == showCompletedItems &&
        other.sortOrder == sortOrder &&
        other.autoArchiveCompletedLists == autoArchiveCompletedLists &&
        other.autoArchiveDays == autoArchiveDays &&
        other.lastBackupDate == lastBackupDate &&
        other.enableHapticFeedback == enableHapticFeedback &&
        other.enableSoundEffects == enableSoundEffects &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      enableNotifications,
      enableReminders,
      reminderTimeInMinutes,
      themeMode,
      showCompletedItems,
      sortOrder,
      autoArchiveCompletedLists,
      autoArchiveDays,
      lastBackupDate,
      enableHapticFeedback,
      enableSoundEffects,
      languageCode,
    );
  }
} 