import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 60)
class AppSettings extends HiveObject {
  @HiveField(0) bool isDiscreteMode = false;
  @HiveField(1) bool isDarkMode = false;
  @HiveField(2) String language = 'fr';
  @HiveField(3) bool biometricsEnabled = false;
  @HiveField(4) DateTime? lastSync;
  
  // Nouveaux champs pour SettingsPageEnhanced
  @HiveField(5) bool notificationsEnabled = true;
  @HiveField(6) bool emailNotifications = true;
  @HiveField(7) bool pushNotifications = true;
  @HiveField(8) bool smsNotifications = false;
  @HiveField(9) String fontSizeLevel = 'normal'; // small, normal, large, xlarge
  @HiveField(10) bool highContrast = false;
  @HiveField(11) bool compactMode = false;
  @HiveField(12) String themeColor = 'blue'; // blue, green, purple, orange
  @HiveField(13) bool shareAnalytics = true;
  @HiveField(14) bool autoBackup = true;
  @HiveField(15) DateTime? lastBackup;
  @HiveField(16) DateTime? lastPasswordChange;

  AppSettings({
    this.isDiscreteMode = false,
    this.isDarkMode = false,
    this.language = 'fr',
    this.biometricsEnabled = false,
    this.lastSync,
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.fontSizeLevel = 'normal',
    this.highContrast = false,
    this.compactMode = false,
    this.themeColor = 'blue',
    this.shareAnalytics = true,
    this.autoBackup = true,
    this.lastBackup,
    this.lastPasswordChange,
  });
}

