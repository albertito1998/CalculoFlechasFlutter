import 'package:flutter/material.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import 'dart:math';

class ComprobarFlecha2VanosPage extends StatefulWidget {
  const ComprobarFlecha2VanosPage({super.key});

  @override
  State<ComprobarFlecha2VanosPage> createState() =>
      _ComprobarFlecha2VanosPageState();
}

class _ComprobarFlecha2VanosPageState extends State<ComprobarFlecha2VanosPage> {
  final txtAngGrapa1 = TextEditingController();
  final txtAngGrapa2 = TextEditingController();
  final txtAngCableVano2 = TextEditingController();
  final txtLongVano1 = TextEditingController();
  final txtLongVano2 = TextEditingController();
  final txtFlechaVano2 = TextEditingController();

  String result = "";
  String cableBajo = "";
  String error = "";

  final om = OperacionesMatematicas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COMPROBAR FLECHA EN 2 VANOS"),
        backgroundColor: const Color(0xFF003057),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => mostrarAyuda(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => mostrarLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            campo("- Ángulo en grapa 1", txtAngGrapa1),
            campo("- Ángulo en grapa 2", txtAngGrapa2),
            campo("- Ángulo en cable del vano 2", txtAngCableVano2),
            campo("- Longitud del vano 1 (m)", txtLongVano1),
            campo("- Longitud del vano 2 (m)", txtLongVano2),
            campo("- Flecha teórica del vano 2 (m)", txtFlechaVano2),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calcular,
                child: const Text("Calcular"),
              ),
            ),
            const SizedBox(height: 16),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            if (result.isNotEmpty)
              Text("Flecha Real: $result m",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            if (cableBajo.isNotEmpty)
              Text(cableBajo,
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: limpiar,
        child: const Icon(Icons.clear),
      ),
    );
  }

  Widget campo(String label, TextEditingController control) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: control,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  void calcular() {
    setState(() {
      result = "";
      cableBajo = "";
      error = "";
    });

    try {
      final E = double.parse(txtAngGrapa1.text);
      final G = double.parse(txtAngGrapa2.text);
      final C = double.parse(txtAngCableVano2.text);
      final J = double.parse(txtLongVano1.text);
      final K = double.parse(txtLongVano2.text);
      final F = double.parse(txtFlechaVano2.text);

      double H;
      if (E >= 100 || C >= 100) {
        if (E < 100 && C > 100) {
          H = calculoH2(J, E, C);
        } else {
          H = calculoH3(J, E, C);
        }
      } else {
        H = calculoH1(J, E, C);
      }

      double L = J + K;

      double resultado;
      double rescable;

      if (C >= 100 || E >= 100) {
        if (C > 100 && G < 100) {
          resultado = flechareal2(G, C, L, H);
          rescable = calculocable(resultado, F);
        } else {
          resultado = flechareal3(G, C, L, H);
          rescable = calculocable(resultado, F);
        }
      } else {
        resultado = flechareal1(G, C, L, H);
        rescable = calculocable(resultado, F);
      }

      setState(() {
        result = resultado.toStringAsFixed(3);
        cableBajo = rescable < 0
            ? "Cable ALTO: ${rescable.abs().toStringAsFixed(3)} m"
            : "Cable BAJO: ${rescable.toStringAsFixed(3)} m";
      });
    } catch (e) {
      setState(() => error = "Datos inválidos. Verifique los valores.");
    }
  }

  double calculoH1(double J, double E, double C) => J * om.calculotang1(E, C);

  double calculoH2(double J, double E, double C) => J * om.calculotang2(E, C);

  double calculoH3(double J, double E, double C) => J * om.calculotang3(E, C);

  double flechareal1(double G, double C, double L, double H) {
    final tg = om.calculotang1(G, C);
    final raiz = om.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  double flechareal2(double G, double C, double L, double H) {
    final tg = om.calculotang2(G, C);
    final raiz = om.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  double flechareal3(double G, double C, double L, double H) {
    final tg = om.calculotang3(G, C);
    final raiz = om.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  double calculocable(double res, double F) => res - F;

  void limpiar() {
    txtAngGrapa1.clear();
    txtAngGrapa2.clear();
    txtAngCableVano2.clear();
    txtLongVano1.clear();
    txtLongVano2.clear();
    txtFlechaVano2.clear();
    setState(() {
      result = "";
      cableBajo = "";
      error = "";
    });
  }
}

void mostrarAyuda(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Ayuda - Flecha en 2 Vanos"),
      content: const Text(
          "Introduce los ángulos en grados centesimales (gon), las longitudes de vano 1 y vano 2, "
          "y la flecha teórica del vano 2.\n\n"
          "La fórmula calcula el parámetro H y luego la flecha real, para comprobar si el cable está "
          "por encima o por debajo de lo esperado."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    ),
  );
}

void mostrarLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Cerrar sesión"),
      content: const Text("¿Desea volver a la pantalla de login?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text("Salir"),
        ),
      ],
    ),
  );
}
