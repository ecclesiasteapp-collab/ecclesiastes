// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 60;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      isDiscreteMode: fields[0] as bool,
      isDarkMode: fields[1] as bool,
      language: fields[2] as String,
      biometricsEnabled: fields[3] as bool,
      lastSync: fields[4] as DateTime?,
      notificationsEnabled: fields[5] as bool,
      emailNotifications: fields[6] as bool,
      pushNotifications: fields[7] as bool,
      smsNotifications: fields[8] as bool,
      fontSizeLevel: fields[9] as String,
      highContrast: fields[10] as bool,
      compactMode: fields[11] as bool,
      themeColor: fields[12] as String,
      shareAnalytics: fields[13] as bool,
      autoBackup: fields[14] as bool,
      lastBackup: fields[15] as DateTime?,
      lastPasswordChange: fields[16] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.isDiscreteMode)
      ..writeByte(1)
      ..write(obj.isDarkMode)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.biometricsEnabled)
      ..writeByte(4)
      ..write(obj.lastSync)
      ..writeByte(5)
      ..write(obj.notificationsEnabled)
      ..writeByte(6)
      ..write(obj.emailNotifications)
      ..writeByte(7)
      ..write(obj.pushNotifications)
      ..writeByte(8)
      ..write(obj.smsNotifications)
      ..writeByte(9)
      ..write(obj.fontSizeLevel)
      ..writeByte(10)
      ..write(obj.highContrast)
      ..writeByte(11)
      ..write(obj.compactMode)
      ..writeByte(12)
      ..write(obj.themeColor)
      ..writeByte(13)
      ..write(obj.shareAnalytics)
      ..writeByte(14)
      ..write(obj.autoBackup)
      ..writeByte(15)
      ..write(obj.lastBackup)
      ..writeByte(16)
      ..write(obj.lastPasswordChange);
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
