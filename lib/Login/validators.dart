import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Tipos de formulario permitidos
enum FormType { login, register, forgot }

/// Verifica si un email termina en "@elecnor.[dominio]"
bool isValidEmail(String email) {
  final emailRegExp = RegExp(
    dotenv.env['REGEX_EMAIL']!, // Regex cargada desde .env
  );
  return emailRegExp.hasMatch(email.trim());
}

/// Validador del campo de correo electrónico
class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      showToastMessage('El campo de correo electrónico no puede estar vacío');
      return 'El campo de correo electrónico no puede estar vacío';
    } else if (!isValidEmail(value)) {
      showToastMessage('Correo invalido');
      return 'El correo es invalido';
    } else {
      return null; // es válido
    }
  }
}

/// Validador de contraseña (no usado en este caso)
class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      showToastMessage('La contraseña no puede estar vacía');
      return "Password can't be empty";
    } else {
      return null;
    }
  }
}

/// Muestra un mensaje tipo "toast" en pantalla
void showToastMessage(String message) {
  Toast.show(
    message,
    duration: Toast.lengthShort,
    gravity: Toast.bottom,
    backgroundRadius: 5.0,
    backgroundColor: Colors.blue,
    webTexColor: Colors.white,
    textStyle: 16.0,
  );
}
