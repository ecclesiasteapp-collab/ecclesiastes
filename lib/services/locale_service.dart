import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  LocaleService() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    notifyListeners();
  }

  static const List<Map<String, String>> supportedLanguages = [
    {'name': 'Français', 'code': 'fr'},
    {'name': 'English', 'code': 'en'},
    {'name': 'Lingala', 'code': 'ln'},
    {'name': 'Kikongo', 'code': 'ko'},
    {'name': 'Swahili', 'code': 'sw'},
    {'name': 'Tshiluba', 'code': 'tl'},
  ];
}

