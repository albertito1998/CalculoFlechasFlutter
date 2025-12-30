/// Tests unitarios para EmailValidator
///
/// Verifica el correcto funcionamiento de los validadores de email y password.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/utils/validators/email_validator.dart';

void main() {
  group('EmailValidator', () {
    test('valida correctamente email de Elecnor', () {
      expect(
        EmailValidator.validate('usuario@elecnor.com'),
        isNull,
      );
    });
    
    test('rechaza email sin dominio Elecnor', () {
      final result = EmailValidator.validate('usuario@gmail.com');
      expect(result, isNotNull);
      expect(result, contains('elecnor.com'));
    });
    
    test('rechaza email sin @', () {
      final result = EmailValidator.validate('usuario.elecnor.com');
      expect(result, isNotNull);
    });
    
    test('rechaza email vacío', () {
      final result = EmailValidator.validate('');
      expect(result, isNotNull);
    });
    
    test('rechaza email con espacios', () {
      final result = EmailValidator.validate('usuario @elecnor.com');
      expect(result, isNotNull);
    });
    
    test('valida email con subdominios', () {
      expect(
        EmailValidator.validate('usuario@subdomain.elecnor.com'),
        isNull,
      );
    });
    
    test('valida email con números', () {
      expect(
        EmailValidator.validate('usuario123@elecnor.com'),
        isNull,
      );
    });
    
    test('valida email con puntos', () {
      expect(
        EmailValidator.validate('nombre.apellido@elecnor.com'),
        isNull,
      );
    });
    
    test('rechaza email con caracteres especiales inválidos', () {
      final result = EmailValidator.validate('usuario#\$%@elecnor.com');
      expect(result, isNotNull);
    });
  });
  
  group('PasswordValidator', () {
    test('valida contraseña válida', () {
      expect(
        PasswordValidator.validate('Password123!'),
        isNull,
      );
    });
    
    test('rechaza contraseña corta', () {
      final result = PasswordValidator.validate('Pass1!');
      expect(result, isNotNull);
      expect(result, contains('8'));
    });
    
    test('rechaza contraseña sin mayúscula', () {
      final result = PasswordValidator.validate('password123!');
      expect(result, isNotNull);
      expect(result, contains('mayúscula'));
    });
    
    test('rechaza contraseña sin minúscula', () {
      final result = PasswordValidator.validate('PASSWORD123!');
      expect(result, isNotNull);
      expect(result, contains('minúscula'));
    });
    
    test('rechaza contraseña sin número', () {
      final result = PasswordValidator.validate('Password!');
      expect(result, isNotNull);
      expect(result, contains('número'));
    });
    
    test('rechaza contraseña sin carácter especial', () {
      final result = PasswordValidator.validate('Password123');
      expect(result, isNotNull);
      expect(result, contains('especial'));
    });
    
    test('rechaza contraseña vacía', () {
      final result = PasswordValidator.validate('');
      expect(result, isNotNull);
    });
    
    test('valida contraseña con múltiples caracteres especiales', () {
      expect(
        PasswordValidator.validate('Pass123!@#'),
        isNull,
      );
    });
    
    test('valida contraseña larga', () {
      expect(
        PasswordValidator.validate('MyVerySecurePassword123!@#'),
        isNull,
      );
    });
  });
}
