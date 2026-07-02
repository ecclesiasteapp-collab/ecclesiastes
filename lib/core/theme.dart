import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF003366);
  static const Color primaryDark = Color(0xFF0d1b3e);
  static const Color secondary = Color(0xFF1a2a4a);
  static const Color accent = Color(0xFFD4AF37);
  static const Color background = Color(0xFFF5F7FA);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,

      // Barre d'application moderne
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5
        ),
        iconTheme: IconThemeData(size: 24),
      ),

      // Cartes élégantes
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      // Boutons souples
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8
          ),
        ),
      ),

      // Icônes consistantes
      iconTheme: const IconThemeData(
        color: primary,
        size: 24,
      ),

      // Typographie consistante
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 13, color: Colors.black54),
        labelSmall: TextStyle(fontSize: 11, color: Colors.grey),
      ),
    );
  }
}

