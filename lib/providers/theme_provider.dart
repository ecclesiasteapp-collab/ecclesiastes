import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';
import '../services/database_service.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box<AppSettings>(DatabaseService.settingsBoxName);
    final settings = box.get('current');
    if (settings != null) {
      state = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    final box = Hive.box<AppSettings>(DatabaseService.settingsBoxName);
    final settings = box.get('current') ?? AppSettings();
    settings.isDarkMode = isDark;
    box.put('current', settings);
  }
}
