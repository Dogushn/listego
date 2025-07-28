// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 2;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      enableNotifications: fields[0] as bool,
      enableReminders: fields[1] as bool,
      reminderTimeInMinutes: fields[2] as int,
      themeMode: fields[3] as String,
      showCompletedItems: fields[4] as bool,
      sortOrder: fields[5] as String,
      autoArchiveCompletedLists: fields[6] as bool,
      autoArchiveDays: fields[7] as int,
      lastBackupDate: fields[8] as DateTime?,
      enableHapticFeedback: fields[9] as bool,
      enableSoundEffects: fields[10] as bool,
      languageCode: fields[11] as String,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.enableNotifications)
      ..writeByte(1)
      ..write(obj.enableReminders)
      ..writeByte(2)
      ..write(obj.reminderTimeInMinutes)
      ..writeByte(3)
      ..write(obj.themeMode)
      ..writeByte(4)
      ..write(obj.showCompletedItems)
      ..writeByte(5)
      ..write(obj.sortOrder)
      ..writeByte(6)
      ..write(obj.autoArchiveCompletedLists)
      ..writeByte(7)
      ..write(obj.autoArchiveDays)
      ..writeByte(8)
      ..write(obj.lastBackupDate)
      ..writeByte(9)
      ..write(obj.enableHapticFeedback)
      ..writeByte(10)
      ..write(obj.enableSoundEffects)
      ..writeByte(11)
      ..write(obj.languageCode)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
