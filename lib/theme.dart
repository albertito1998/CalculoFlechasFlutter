/// Tema de la aplicación Elecnor Flechas
/// 
/// Define los colores, estilos y componentes visuales de la aplicación
/// siguiendo la identidad corporativa de Elecnor.
library;

import 'package:flutter/material.dart';

/// Clase que contiene el tema de la aplicación
/// 
/// Utiliza Material 3 con los colores corporativos de Elecnor:
/// - Azul principal: #005BAC
/// - Naranja secundario: #EC6608
class AppTheme {
  // Constructor privado para evitar instanciación
  AppTheme._();

  /// Color azul corporativo de Elecnor
  static const Color primaryBlue = Color(0xFF005BAC);

  /// Color azul oscuro para AppBar
  static const Color darkBlue = Color(0xFF003057);

  /// Color naranja corporativo de Elecnor
  static const Color secondaryOrange = Color(0xFFEC6608);

  /// Tema claro de la aplicación
  static final ThemeData lightTheme = ThemeData(
    // Habilita Material Design 3
    useMaterial3: true,

    // Color principal
    primaryColor: primaryBlue,

    // Esquema de colores
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: secondaryOrange,
      surface: Colors.white,
      error: Colors.red,
    ),

    // Color de fondo del scaffold
    scaffoldBackgroundColor: Colors.white,

    // Tema del AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    // Tema de texto
    textTheme: const TextTheme(
      // Títulos grandes
      titleLarge: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      // Títulos medianos
      titleMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      // Texto del cuerpo
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      // Texto pequeño
      bodySmall: TextStyle(
        color: Colors.black54,
        fontSize: 14,
      ),
    ),

    // Tema de botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        elevation: 2,
      ),
    ),

    // Tema de botones de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    ),

    // Tema de campos de texto
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),

    // Tema de tarjetas
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ),

    // Tema de diálogos
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
    ),

    // Tema de SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryBlue,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// Mantiene compatibilidad con código existente
final ThemeData elecnorTheme = AppTheme.lightTheme;
