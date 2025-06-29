import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

enum FormType { login, register, forgot }

bool isValidEmail(String email) {
  final emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@elecnor\.[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(email);
}

class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      // Muestra un "toast" con un mensaje

      showToastMessage('El campo de correo electrónico no puede estar vacío');
      return 'El campo de correo electrónico no puede estar vacío';
    } else if (isValidEmail(value)) {
      showToastMessage('Correo electrónico no válido');
      return 'Correo electrónico no válido';
    } else {
      return null;
    }
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      showToastMessage('Password can,t be empty');
      return "Password can't be empty";
    } else {
      return null;
    }
  }
}

void showToastMessage(String message) {
  Toast.show(
    message,
    duration: Toast.lengthShort,
    // Duración: Toast.LENGTHSHORT o Toast.LENGTHLONG
    gravity: Toast.bottom,
    // Posición: Toast.TOP, Toast.CENTER, Toast.BOTTOM
    backgroundRadius: 5.0,
    // Radio del fondo
    backgroundColor: Colors.blue,
    // Color de fondo del toast
    webTexColor: Colors.white,
    // Color del texto
    textStyle: 16.0, // Tamaño del texto
  );
}
