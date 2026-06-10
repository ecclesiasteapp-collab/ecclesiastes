import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 60)
class AppSettings extends HiveObject {
  @HiveField(0) bool isDiscreteMode = false;
  @HiveField(1) bool isDarkMode = false;
  @HiveField(2) String language = 'fr';
  @HiveField(3) bool biometricsEnabled = false;
  @HiveField(4) DateTime? lastSync;

  AppSettings({
    this.isDiscreteMode = false,
    this.isDarkMode = false,
    this.language = 'fr',
    this.biometricsEnabled = false,
    this.lastSync,
  });
}
