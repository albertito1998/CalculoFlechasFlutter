/// Tests unitarios para OperacionesMatematicas
///
/// Verifica el correcto funcionamiento de las operaciones matemáticas
/// y conversiones angulares utilizadas en los cálculos de flechas.
library;

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('OperacionesMatematicas - Conversiones Angulares', () {
    const ops = OperacionesMatematicas();
    
    test('convierte grados a radianes correctamente', () {
      expect(ops.gradosARadianes(0), equals(0));
      expect(ops.gradosARadianes(90), closeTo(pi / 2, delta: 0.0001));
      expect(ops.gradosARadianes(180), closeTo(pi, delta: 0.0001));
      expect(ops.gradosARadianes(360), closeTo(2 * pi, delta: 0.0001));
      expect(ops.gradosARadianes(45), closeTo(pi / 4, delta: 0.0001));
    });
    
    test('convierte radianes a grados correctamente', () {
      expect(ops.radianesAGrados(0), equals(0));
      expect(ops.radianesAGrados(pi / 2), closeTo(90, delta: 0.0001));
      expect(ops.radianesAGrados(pi), closeTo(180, delta: 0.0001));
      expect(ops.radianesAGrados(2 * pi), closeTo(360, delta: 0.0001));
      expect(ops.radianesAGrados(pi / 4), closeTo(45, delta: 0.0001));
    });
    
    test('redondea correctamente a decimales', () {
      expect(ops.redondear(3.14159, 2), equals(3.14));
      expect(ops.redondear(3.14159, 3), equals(3.142));
      expect(ops.redondear(3.14159, 0), equals(3));
      expect(ops.redondear(2.5, 0), equals(3)); // Redondeo hacia arriba
      expect(ops.redondear(2.4, 0), equals(2)); // Redondeo hacia abajo
    });
    
    test('convierte ángulos sexagesimales correctamente', () {
      // 45° 30' 15" = 45.5041666...°
      expect(
        ops.sexagesimalADecimal(45, 30, 15),
        closeTo(45.5042, delta: 0.0001),
      );
      
      // 0° 0' 0"
      expect(ops.sexagesimalADecimal(0, 0, 0), equals(0));
      
      // 90° 0' 0"
      expect(ops.sexagesimalADecimal(90, 0, 0), equals(90));
      
      // 1° 1' 1"
      expect(
        ops.sexagesimalADecimal(1, 1, 1),
        closeTo(1.0169, delta: 0.0001),
      );
    });
  });
  
  group('OperacionesMatematicas - Cálculos Trigonométricos', () {
    const ops = OperacionesMatematicas();
    
    test('calcula seno correctamente', () {
      expect(ops.seno(0), equals(0));
      expect(ops.seno(90), closeTo(1, delta: 0.0001));
      expect(ops.seno(30), closeTo(0.5, delta: 0.0001));
      expect(ops.seno(45), closeTo(0.7071, delta: 0.0001));
    });
    
    test('calcula coseno correctamente', () {
      expect(ops.coseno(0), equals(1));
      expect(ops.coseno(90), closeTo(0, delta: 0.0001));
      expect(ops.coseno(60), closeTo(0.5, delta: 0.0001));
      expect(ops.coseno(45), closeTo(0.7071, delta: 0.0001));
    });
    
    test('calcula tangente correctamente', () {
      expect(ops.tangente(0), equals(0));
      expect(ops.tangente(45), closeTo(1, delta: 0.0001));
      expect(ops.tangente(30), closeTo(0.5774, delta: 0.0001));
    });
    
    test('calcula arcoseno correctamente', () {
      expect(ops.arcoseno(0), equals(0));
      expect(ops.arcoseno(1), closeTo(90, delta: 0.0001));
      expect(ops.arcoseno(0.5), closeTo(30, delta: 0.0001));
      expect(ops.arcoseno(0.7071), closeTo(45, delta: 0.01));
    });
    
    test('calcula arcocoseno correctamente', () {
      expect(ops.arcocoseno(1), equals(0));
      expect(ops.arcocoseno(0), closeTo(90, delta: 0.0001));
      expect(ops.arcocoseno(0.5), closeTo(60, delta: 0.0001));
    });
    
    test('calcula arcotangente correctamente', () {
      expect(ops.arcotangente(0), equals(0));
      expect(ops.arcotangente(1), closeTo(45, delta: 0.0001));
      expect(ops.arcotangente(0.5774), closeTo(30, delta: 0.01));
    });
  });
  
  group('OperacionesMatematicas - Cálculos de Distancias', () {
    const ops = OperacionesMatematicas();
    
    test('calcula distancia 2D correctamente (Pitágoras)', () {
      // Triángulo 3-4-5
      expect(ops.calcularDistancia2D(3, 4), equals(5));
      
      // Triángulo 5-12-13
      expect(ops.calcularDistancia2D(5, 12), equals(13));
      
      // Caso trivial
      expect(ops.calcularDistancia2D(0, 0), equals(0));
      
      // Distancia con valores decimales
      expect(
        ops.calcularDistancia2D(1.5, 2.5),
        closeTo(2.9155, delta: 0.0001),
      );
    });
    
    test('calcula hipotenusa correctamente', () {
      expect(ops.calcularHipotenusa(3, 4), equals(5));
      expect(ops.calcularHipotenusa(5, 12), equals(13));
      expect(ops.calcularHipotenusa(8, 15), equals(17));
    });
    
    test('calcula cateto a partir de hipotenusa y otro cateto', () {
      // Si hipotenusa = 5 y cateto = 3, entonces otro cateto = 4
      expect(ops.calcularCateto(5, 3), equals(4));
      
      // Si hipotenusa = 13 y cateto = 5, entonces otro cateto = 12
      expect(ops.calcularCateto(13, 5), equals(12));
    });
  });
  
  group('OperacionesMatematicas - Validaciones', () {
    const ops = OperacionesMatematicas();
    
    test('valida números positivos', () {
      expect(ops.esPositivo(1), isTrue);
      expect(ops.esPositivo(0.1), isTrue);
      expect(ops.esPositivo(0), isFalse);
      expect(ops.esPositivo(-1), isFalse);
    });
    
    test('valida rangos de ángulos', () {
      expect(ops.esAnguloValido(0), isTrue);
      expect(ops.esAnguloValido(45), isTrue);
      expect(ops.esAnguloValido(90), isTrue);
      expect(ops.esAnguloValido(180), isTrue);
      expect(ops.esAnguloValido(-1), isFalse);
      expect(ops.esAnguloValido(361), isFalse);
    });
    
    test('valida división por cero', () {
      expect(() => ops.dividir(10, 0), throwsA(isA<ArgumentError>()));
      expect(ops.dividir(10, 2), equals(5));
      expect(ops.dividir(0, 5), equals(0));
    });
  });
  
  group('OperacionesMatematicas - Casos Extremos', () {
    const ops = OperacionesMatematicas();
    
    test('maneja valores muy pequeños', () {
      expect(ops.redondear(0.00001, 5), equals(0.00001));
      expect(ops.redondear(0.00001, 3), equals(0));
    });
    
    test('maneja valores muy grandes', () {
      expect(
        ops.calcularHipotenusa(1000000, 1000000),
        closeTo(1414213.562, delta: 0.001),
      );
    });
    
    test('maneja conversiones de límites angulares', () {
      expect(ops.gradosARadianes(-90), closeTo(-pi / 2, delta: 0.0001));
      expect(ops.gradosARadianes(720), closeTo(4 * pi, delta: 0.0001));
    });
  });
}
