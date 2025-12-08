import 'dart:math';

class OperacionesMatematicas {
  /// Cálculo de tangentes para el caso normal
  double calculotang1(double G, double C) {
    final double Genrad = aradianes(G);
    final double Cenrad = aradianes(C);
    final double tg1 = tan(Genrad);
    final double tg2 = tan(Cenrad);
    return (1 / tg1) - (1 / tg2);
  }

  /// Cálculo de tangentes para el caso en el que uno de los ángulos supera 100 gon
  double calculotang2(double G, double C) {
    final double Genrad = aradianes(G);
    final double Cenrad = aradianes(C);
    return tan(Cenrad - aradianes(100)) - tan(Genrad - aradianes(100));
  }

  /// Cálculo de tangentes para el caso de ángulo mayor en el segundo tramo
  double calculotang3(double G, double C) {
    final double Genrad = aradianes(G);
    final double Cenrad = aradianes(C);
    return (1 / tan(Genrad)) + tan(Cenrad - aradianes(100));
  }

  /// Cálculo de la raíz en el proceso de obtención de la flecha real
  double calculoraiz(double tg, double L, double H) {
    return sqrt(L * tg) + sqrt(H);
  }

  /// Conversión de grados centesimales (gon) a radianes
  double aradianes(double val) => (pi * val) / 200.0;

  /// Conversión de radianes a grados centesimales (gon)
  double agrados(double val) => (200.0 * val) / pi;
}
