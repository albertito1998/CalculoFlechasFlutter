import 'package:flutter/material.dart';
import 'dart:math';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

class ComprobarFlecha1VanoPage extends StatefulWidget {
  const ComprobarFlecha1VanoPage({super.key});

  @override
  State<ComprobarFlecha1VanoPage> createState() =>
      _ComprobarFlecha1VanoPageState();
}

class _ComprobarFlecha1VanoPageState extends State<ComprobarFlecha1VanoPage> {
  // Controladores de entrada
  final TextEditingController txtDistancia = TextEditingController();
  final TextEditingController txtAngGrapa = TextEditingController();
  final TextEditingController txtAngCable = TextEditingController();
  final TextEditingController txtLongVano = TextEditingController();
  final TextEditingController txtFlechaTeorica = TextEditingController();

  // Variables de salida
  String flechaRealTxt = "";
  String cableBajoTxt = "";
  String errorMessage = "";

  final om = OperacionesMatematicas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COMPROBAR FLECHA 1 VANO"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => mostrarAyuda(context)),
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => mostrarLogoutDialog(context)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            campo("- Distancia taquímetro (H)", txtDistancia),
            campo("- Ángulo en grapa (G)", txtAngGrapa),
            campo("- Ángulo en cable (C)", txtAngCable),
            campo("- Longitud del vano (L)", txtLongVano),
            campo("- Flecha teórica (F)", txtFlechaTeorica),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calcular,
                child: const Text("Calcular Flecha Real"),
              ),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text("⚠ $errorMessage",
                  style: const TextStyle(color: Colors.red)),
            if (flechaRealTxt.isNotEmpty)
              Text(flechaRealTxt,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            if (cableBajoTxt.isNotEmpty)
              Text(cableBajoTxt,
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

  // -------------------------------------------------------------
  // WIDGET CAMPO
  // -------------------------------------------------------------
  Widget campo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  // -------------------------------------------------------------
  // CÁLCULO EXACTO PORTADO DEL JAVA
  // -------------------------------------------------------------
  void calcular() {
    setState(() {
      errorMessage = "";
      flechaRealTxt = "";
      cableBajoTxt = "";
    });

    try {
      final double H = double.parse(txtDistancia.text);
      final double G = double.parse(txtAngGrapa.text);
      final double C = double.parse(txtAngCable.text);
      final double L = double.parse(txtLongVano.text);
      final double F = double.parse(txtFlechaTeorica.text);

      double resultado;
      double rescable;

      // ---- MISMA LÓGICA QUE EN JAVA ----
      if (C >= 100 || G >= 100) {
        if (C > 100 && G > 100) {
          resultado = flechareal2(G, C, L, H);
        } else {
          resultado = flechareal3(G, C, L, H);
        }
      } else {
        resultado = flechareal1(G, C, L, H);
      }

      rescable = calculocable(resultado, F);

      setState(() {
        flechaRealTxt = "Flecha Real: ${resultado.toStringAsFixed(3)} m";

        cableBajoTxt = rescable < 0
            ? "Cable ALTO: ${rescable.abs().toStringAsFixed(3)} m"
            : "Cable BAJO: ${rescable.toStringAsFixed(3)} m";
      });
    } catch (e) {
      setState(() => errorMessage = "Datos inválidos. Revise los valores.");
    }
  }

  // -------------------------------------------------------------
  // FUNCIONES PORTADAS 1:1 DEL JAVA
  // -------------------------------------------------------------
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

  double calculocable(double res, double F) {
    return res - F;
  }

  // -------------------------------------------------------------
  // LIMPIAR CAMPOS
  // -------------------------------------------------------------
  void limpiar() {
    txtDistancia.clear();
    txtAngGrapa.clear();
    txtAngCable.clear();
    txtLongVano.clear();
    txtFlechaTeorica.clear();

    setState(() {
      flechaRealTxt = "";
      cableBajoTxt = "";
      errorMessage = "";
    });
  }
}

// ------------------------------------------------------------------
// AYUDA
// ------------------------------------------------------------------
void mostrarAyuda(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Ayuda - Flecha 1 Vano"),
      content: const Text(
          "Introduce distancia H, ángulos G y C, longitud L y flecha teórica F.\n\n"
          "El cálculo es idéntico al de tu app Android."),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"))
      ],
    ),
  );
}

// ------------------------------------------------------------------
// LOGOUT
// ------------------------------------------------------------------
void mostrarLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Cerrar sesión"),
      content: const Text("¿Desea volver a la pantalla de inicio de sesión?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Salir")),
      ],
    ),
  );
}
