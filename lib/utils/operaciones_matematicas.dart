import 'dart:math';

class OperacionesMatematicas {
  /// Cálculo de tangentes para el caso normal
  double calculotang1(double G, double C) {
    final double genrad = aradianes(G);
    final double cenrad = aradianes(C);
    final double tg1 = tan(genrad);
    final double tg2 = tan(cenrad);
    return (1 / tg1) - (1 / tg2);
  }

  /// Cálculo de tangentes para el caso en el que uno de los ángulos supera 100 gon
  double calculotang2(double G, double C) {
    final double genrad = aradianes(G);
    final double cenrad = aradianes(C);
    return tan(cenrad - aradianes(100)) - tan(genrad - aradianes(100));
  }

  /// Cálculo de tangentes para el caso de ángulo mayor en el segundo tramo
  double calculotang3(double G, double C) {
    final double genrad = aradianes(G);
    final double cenrad = aradianes(C);
    return (1 / tan(genrad)) + tan(cenrad - aradianes(100));
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
