import 'package:flutter/material.dart';

// Definimos un ThemeData personalizado llamado elecnorTheme
final ThemeData elecnorTheme = ThemeData(
  useMaterial3: true,
  primaryColor: const Color(0xFF005BAC),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF005BAC),
    secondary: Color(0xFFEC6608),
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF005BAC),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    bodyMedium: TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF005BAC),
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
);
