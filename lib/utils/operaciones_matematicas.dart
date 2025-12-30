/// Operaciones matemáticas para cálculos de flechas
///
/// Proporciona métodos especializados para realizar cálculos trigonométricos
/// relacionados con el flechado de líneas eléctricas aéreas.
///
/// Todos los ángulos se manejan en grados centesimales (gon).
library;

import 'dart:math' show tan, sqrt;

import '../core/constants/app_constants.dart';

/// Clase con operaciones matemáticas para cálculo de flechas
///
/// Esta clase contiene métodos para:
/// - Conversiones entre radianes y grados centesimales
/// - Cálculos de tangentes para diferentes casos de flechado
/// - Cálculos de raíces cuadradas para obtener flechas reales
class OperacionesMatematicas {
  /// Constructor constante
  const OperacionesMatematicas();

  // ==================== Cálculos de tangentes ====================

  /// Calcula tangentes para el caso normal de flechado
  ///
  /// Se utiliza cuando ambos ángulos están en el rango normal (0-100 gon).
  ///
  /// Fórmula: (1 / tan(G)) - (1 / tan(C))
  ///
  /// [G] Ángulo en grapa en grados centesimales
  /// [C] Ángulo del conductor en grados centesimales
  ///
  /// Retorna el resultado del cálculo de tangentes.
  double calculotang1(double G, double C) {
    final double genrad = aradianes(G);
    final double cenrad = aradianes(C);

    final double tg1 = tan(genrad);
    final double tg2 = tan(cenrad);

    return (1 / tg1) - (1 / tg2);
  }

  /// Calcula tangentes cuando uno de los ángulos supera 100 gon
  ///
  /// Se utiliza cuando el ángulo del conductor supera los 100 gon.
  ///
  /// Fórmula: tan(C - 100) - tan(G - 100)
  ///
  /// [G] Ángulo en grapa en grados centesimales
  /// [C] Ángulo del conductor en grados centesimales
  ///
  /// Retorna el resultado del cálculo de tangentes.
  double calculotang2(double G, double C) {
    final double genrad = aradianes(G);
    final double cenrad = aradianes(C);

    final double angulo100 = aradianes(CalculationConstants.hundredGon);

    return tan(cenrad - angulo100) - tan(genrad - angulo100);
  }

  /// Calcula tangentes cuando el ángulo del segundo tramo es mayor
  ///
  /// Se utiliza en casos especiales de flechado con ángulos mayores.
  ///
  /// Fórmula: (1 / tan(G)) + tan(C - 100)
  ///
  /// [G] Ángulo en grapa en grados centesimales
  /// [C] Ángulo del conductor en grados centesimales
  ///
  /// Retorna el resultado del cálculo de tangentes.
  double calculotang3(double G, double C) {
    final double genrad = aradianes(G);
    final double cenrad = aradianes(C);

    final double angulo100 = aradianes(CalculationConstants.hundredGon);

    return (1 / tan(genrad)) + tan(cenrad - angulo100);
  }

  // ==================== Cálculos de raíz ====================

  /// Calcula la raíz cuadrada para obtener la flecha real
  ///
  /// Se utiliza en el proceso de obtención de la flecha real
  /// a partir de los valores calculados.
  ///
  /// Fórmula: √(L * tg) + √H
  ///
  /// [tg] Valor de tangente calculado
  /// [L] Longitud del vano en metros
  /// [H] Altura o distancia en metros
  ///
  /// Retorna el valor de la flecha real.
  double calculoraiz(double tg, double L, double H) {
    return sqrt(L * tg) + sqrt(H);
  }

  // ==================== Conversiones angulares ====================

  /// Convierte grados centesimales (gon) a radianes
  ///
  /// Un círculo completo = 400 gon = 2π radianes
  /// Por tanto: radianes = (π * gon) / 200
  ///
  /// [val] Valor en grados centesimales
  ///
  /// Retorna el valor en radianes.
  double aradianes(double val) {
    return val * CalculationConstants.gonToRadiansFactor;
  }

  /// Convierte radianes a grados centesimales (gon)
  ///
  /// Un círculo completo = 2π radianes = 400 gon
  /// Por tanto: gon = (200 * radianes) / π
  ///
  /// [val] Valor en radianes
  ///
  /// Retorna el valor en grados centesimales.
  double agrados(double val) {
    return val * CalculationConstants.radiansToGonFactor;
  }

  // ==================== Utilidades ====================

  /// Redondea un número a una cantidad específica de decimales
  ///
  /// [value] El valor a redondear
  /// [decimals] Número de decimales (por defecto 4)
  ///
  /// Retorna el valor redondeado.
  double redondear(
    double value, {
    int decimals = CalculationConstants.decimalPrecision,
  }) {
    final factor = pow10(decimals);
    return (value * factor).round() / factor;
  }

  /// Calcula la potencia de 10
  ///
  /// [n] El exponente
  ///
  /// Retorna 10 elevado a n.
  double pow10(int n) {
    double result = 1;
    for (int i = 0; i < n; i++) {
      result *= 10;
    }
    return result;
  }

  /// Valida que un valor sea positivo
  ///
  /// [value] El valor a validar
  /// [fieldName] Nombre del campo para el mensaje de error
  ///
  /// Lanza una excepción si el valor no es positivo.
  void validarPositivo(double value, String fieldName) {
    if (value <= 0) {
      throw ArgumentError('$fieldName debe ser un valor positivo');
    }
  }

  /// Valida que un ángulo esté en el rango válido (0-400 gon)
  ///
  /// [angulo] El ángulo a validar en grados centesimales
  /// [fieldName] Nombre del campo para el mensaje de error
  ///
  /// Lanza una excepción si el ángulo está fuera del rango.
  void validarAngulo(double angulo, String fieldName) {
    if (angulo < 0 || angulo >= 400) {
      throw ArgumentError(
        '$fieldName debe estar entre 0 y 400 gon (recibido: $angulo)',
      );
    }
  }
}
