/// Tests unitarios para OperacionesMatematicas
///
/// Verifica el correcto funcionamiento de las operaciones matemáticas
/// y conversiones angulares utilizadas en los cálculos de flechas.
library;

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

void main() {
  const ops = OperacionesMatematicas();

  group('Conversiones Angulares', () {
    test('convierte grados centesimales a radianes', () {
      expect(ops.aradianes(0), equals(0));
      expect(ops.aradianes(100), closeTo(pi / 2, 0.0001));
      expect(ops.aradianes(200), closeTo(pi, 0.0001));
      expect(ops.aradianes(400), closeTo(2 * pi, 0.0001));
    });

    test('convierte radianes a grados centesimales', () {
      expect(ops.agrados(0), equals(0));
      expect(ops.agrados(pi / 2), closeTo(100, 0.0001));
      expect(ops.agrados(pi), closeTo(200, 0.0001));
      expect(ops.agrados(2 * pi), closeTo(400, 0.0001));
    });
  });

  group('Cálculos de Tangentes', () {
    test('calcula tangente caso 1', () {
      final result = ops.calculotang1(50, 100);
      expect(result, isA<double>());
      expect(result.isFinite, isTrue);
    });

    test('calcula tangente caso 2', () {
      final result = ops.calculotang2(150, 100);
      expect(result, isA<double>());
      expect(result.isFinite, isTrue);
    });

    test('calcula tangente caso 3', () {
      final result = ops.calculotang3(250, 100);
      expect(result, isA<double>());
      expect(result.isFinite, isTrue);
    });
  });

  group('Cálculo de Raíz (Flecha)', () {
    test('calcula raíz correctamente', () {
      final result = ops.calculoraiz(0.1, 100, 10);
      expect(result, isA<double>());
      expect(result, greaterThan(0));
    });

    test('calcula raíz con valores pequeños', () {
      final result = ops.calculoraiz(0.01, 50, 5);
      expect(result, isA<double>());
      expect(result, greaterThan(0));
    });
  });

  group('Validaciones', () {
    test('valida valores positivos correctamente', () {
      expect(() => ops.validarPositivo(10.0, 'test'), returnsNormally);
      expect(() => ops.validarPositivo(0.01, 'test'), returnsNormally);
    });

    test('rechaza valores no positivos', () {
      expect(
        () => ops.validarPositivo(0, 'test'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => ops.validarPositivo(-1, 'test'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('valida ángulos centesimales', () {
      expect(() => ops.validarAngulo(0, 'test'), returnsNormally);
      expect(() => ops.validarAngulo(100, 'test'), returnsNormally);
      expect(() => ops.validarAngulo(399, 'test'), returnsNormally);
    });

    test('rechaza ángulos fuera de rango', () {
      expect(
        () => ops.validarAngulo(-1, 'test'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => ops.validarAngulo(401, 'test'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Utilidades', () {
    test('calcula potencia de 10', () {
      expect(ops.pow10(0), equals(1));
      expect(ops.pow10(1), equals(10));
      expect(ops.pow10(2), equals(100));
      expect(ops.pow10(3), equals(1000));
    });

    test('redondea correctamente', () {
      expect(ops.redondear(3.14159, decimals: 2), equals(3.14));
      expect(ops.redondear(3.14159, decimals: 3), equals(3.142));
      expect(ops.redondear(3.14159, decimals: 0), equals(3));
    });
  });

  group('Flujo Completo', () {
    test('conversión y reconversión mantiene precisión', () {
      const anguloGon = 100.0;
      final radianes = ops.aradianes(anguloGon);
      final reconvertido = ops.agrados(radianes);
      expect(reconvertido, closeTo(anguloGon, 0.0001));
    });

    test('cálculo de flecha completo', () {
      // Simula un cálculo completo
      const G = 50.0; // Ángulo en gon
      const C = 100.0; // Constante
      final tg = ops.calculotang1(G, C);
      
      const L = 100.0; // Longitud
      const H = 10.0;  // Altura
      final flecha = ops.calculoraiz(tg, L, H);
      
      expect(flecha, isA<double>());
      expect(flecha.isFinite, isTrue);
      expect(flecha, greaterThan(0));
    });
  });
}
