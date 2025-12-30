/// Validador de correos electrónicos
///
/// Valida que los correos electrónicos cumplan con el formato corporativo
/// de Elecnor utilizando expresiones regulares desde variables de entorno.
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toast/toast.dart';

import '../../core/constants/app_constants.dart';

/// Clase con métodos estáticos para validar correos electrónicos
class EmailValidator {
  // Constructor privado para evitar instanciación
  EmailValidator._();

  /// Valida un correo electrónico corporativo de Elecnor
  ///
  /// Verifica que:
  /// - El campo no esté vacío
  /// - El correo cumpla con el formato requerido (según regex en .env)
  ///
  /// Retorna null si es válido, o un mensaje de error si no lo es.
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      _showToastMessage(AppMessages.emailEmptyError);
      return AppMessages.emailEmptyError;
    }

    if (!_isValidEmailFormat(value)) {
      _showToastMessage(AppMessages.emailInvalidError);
      return AppMessages.emailInvalidError;
    }

    return null; // Email válido
  }

  /// Verifica si el email tiene el formato correcto según la regex configurada
  ///
  /// [email] El correo electrónico a validar
  ///
  /// Retorna true si cumple con el formato, false en caso contrario.
  static bool _isValidEmailFormat(String email) {
    try {
      // Intenta obtener la regex desde .env
      final regexPattern = dotenv.env['REGEX_EMAIL'];

      if (regexPattern != null && regexPattern.isNotEmpty) {
        final emailRegExp = RegExp(regexPattern);
        return emailRegExp.hasMatch(email.trim());
      }

      // Si no hay regex en .env, usa una validación básica
      return _isValidBasicEmail(email);
    } catch (e) {
      // Si falla la carga de .env, usa validación básica
      return _isValidBasicEmail(email);
    }
  }

  /// Validación básica de email como respaldo
  ///
  /// Verifica el formato general de un email y que termine en @elecnor.
  static bool _isValidBasicEmail(String email) {
    // Expresión regular básica para emails
    final basicEmailRegex = RegExp(
      r'^[\w\.-]+@elecnor\.(com|es|[a-z]{2,})$',
      caseSensitive: false,
    );

    return basicEmailRegex.hasMatch(email.trim());
  }

  /// Muestra un mensaje toast al usuario
  static void _showToastMessage(String message) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Toast.show(
      message,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
      backgroundRadius: 5.0,
      backgroundColor: Colors.red.shade700,
      textStyle: textStyle,
    );
  }
}

/// Validador de contraseñas
///
/// Valida que las contraseñas cumplan con los requisitos de seguridad.
class PasswordValidator {
  // Constructor privado
  PasswordValidator._();

  /// Valida una contraseña
  ///
  /// Verifica que:
  /// - El campo no esté vacío
  /// - La contraseña tenga al menos 6 caracteres (configurable)
  ///
  /// Retorna null si es válida, o un mensaje de error si no lo es.
  static String? validate(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      _showToastMessage(AppMessages.passwordEmptyError);
      return AppMessages.passwordEmptyError;
    }

    if (value.length < minLength) {
      final message = 'La contraseña debe tener al menos $minLength caracteres';
      _showToastMessage(message);
      return message;
    }

    return null; // Contraseña válida
  }

  /// Valida una contraseña fuerte
  ///
  /// Verifica que:
  /// - Tenga al menos 8 caracteres
  /// - Contenga al menos una letra mayúscula
  /// - Contenga al menos una letra minúscula
  /// - Contenga al menos un número
  /// - Contenga al menos un carácter especial
  static String? validateStrong(String? value) {
    if (value == null || value.isEmpty) {
      _showToastMessage(AppMessages.passwordEmptyError);
      return AppMessages.passwordEmptyError;
    }

    if (value.length < 8) {
      final message = 'La contraseña debe tener al menos 8 caracteres';
      _showToastMessage(message);
      return message;
    }

    // Verifica mayúsculas
    if (!value.contains(RegExp(r'[A-Z]'))) {
      final message = 'La contraseña debe contener al menos una mayúscula';
      _showToastMessage(message);
      return message;
    }

    // Verifica minúsculas
    if (!value.contains(RegExp(r'[a-z]'))) {
      final message = 'La contraseña debe contener al menos una minúscula';
      _showToastMessage(message);
      return message;
    }

    // Verifica números
    if (!value.contains(RegExp(r'[0-9]'))) {
      final message = 'La contraseña debe contener al menos un número';
      _showToastMessage(message);
      return message;
    }

    // Verifica caracteres especiales
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      final message =
          'La contraseña debe contener al menos un carácter especial';
      _showToastMessage(message);
      return message;
    }

    return null; // Contraseña válida
  }

  /// Muestra un mensaje toast al usuario
  static void _showToastMessage(String message) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Toast.show(
      message,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
      backgroundRadius: 5.0,
      backgroundColor: Colors.red.shade700,
      textStyle: textStyle,
    );
  }
}

/// Utilidad para mostrar mensajes toast
///
/// Proporciona un método centralizado para mostrar mensajes
/// temporales al usuario.
class ToastHelper {
  // Constructor privado
  ToastHelper._();

  /// Muestra un mensaje de éxito
  static void showSuccess(String message) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Toast.show(
      message,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
      backgroundRadius: 5.0,
      backgroundColor: Colors.green.shade700,
      textStyle: textStyle,
    );
  }

  /// Muestra un mensaje de error
  static void showError(String message) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Toast.show(
      message,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
      backgroundRadius: 5.0,
      backgroundColor: Colors.red.shade700,
      textStyle: textStyle,
    );
  }

  /// Muestra un mensaje de información
  static void showInfo(String message) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Toast.show(
      message,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
      backgroundRadius: 5.0,
      backgroundColor: Colors.blue.shade700,
      textStyle: textStyle,
    );
  }

  /// Muestra un mensaje de advertencia
  static void showWarning(String message) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Toast.show(
      message,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
      backgroundRadius: 5.0,
      backgroundColor: Colors.orange.shade700,
      textStyle: textStyle,
    );
  }
}
