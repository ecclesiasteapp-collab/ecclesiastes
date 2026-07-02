import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1B6B9E), // Bleu ENA
    hintColor: const Color(0xFF003366),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B6B9E),
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1B6B9E),
      textTheme: ButtonTextTheme.primary,
    ),
    // Ajoutez d'autres propriétés de thème si nécessaire
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF003366), // Bleu ENA plus foncé pour le mode sombre
    hintColor: const Color(0xFF1B6B9E),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1B6B9E),
      textTheme: ButtonTextTheme.primary,
    ),
    // Ajoutez d'autres propriétés de thème si nécessaire
  );

  // Pour la compatibilité avec l'ancien code qui utilisait AppTheme.light
  static ThemeData get light => lightTheme;
}
