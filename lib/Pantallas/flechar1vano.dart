import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

/// Página para calcular el ángulo necesario para flechar un vano (versión 100% Android).
class Flechar1VanoPage extends StatefulWidget {
  const Flechar1VanoPage({super.key});

  @override
  State<Flechar1VanoPage> createState() => _Flechar1VanoPageState();
}

class _Flechar1VanoPageState extends State<Flechar1VanoPage> {
  final TextEditingController distController = TextEditingController();
  final TextEditingController angGrapaController = TextEditingController();
  final TextEditingController longVanoController = TextEditingController();
  final TextEditingController flechaTeorController = TextEditingController();

  final om = OperacionesMatematicas();

  String resultado = "Ángulo para flechar: --";
  String msgError = "";
  String error1 = "", error2 = "", error3 = "", error4 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FLECHAR 1 VANO"),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Introduce los siguientes datos:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            campo("Distancia taquímetro (m)", distController),
            campo("Ángulo en grapa (centesimal)", angGrapaController),
            campo("Longitud del vano (m)", longVanoController),
            campo("Flecha teórica (m)", flechaTeorController),
            const SizedBox(height: 10),
            if (error1.isNotEmpty) errorText(error1),
            if (error2.isNotEmpty) errorText(error2),
            if (error3.isNotEmpty) errorText(error3),
            if (error4.isNotEmpty) errorText(error4),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calcularFlecha1Vano,
                child: const Text("Calcular"),
              ),
            ),
            const SizedBox(height: 20),
            Text(resultado,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (msgError.isNotEmpty)
              Text("⚠ $msgError", style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: limpiarCampos,
              icon: const Icon(Icons.clear),
              label: const Text("Vaciar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(String label, TextEditingController control) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: control,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget errorText(String text) =>
      Text(text, style: const TextStyle(color: Colors.red));

  // ============================================================
  //      LÓGICA EXACTA DEL ANDROID → PORTADA SIN CAMBIOS
  // ============================================================

  void calcularFlecha1Vano() {
    setState(() {
      resultado = "Ángulo para flechar: --";
      msgError = "";
      error1 = distController.text.isEmpty ? "Falta la distancia" : "";
      error2 =
          angGrapaController.text.isEmpty ? "Falta el ángulo de grapa" : "";
      error3 =
          longVanoController.text.isEmpty ? "Falta la longitud del vano" : "";
      error4 =
          flechaTeorController.text.isEmpty ? "Falta la flecha teórica" : "";
    });

    if (error1.isNotEmpty ||
        error2.isNotEmpty ||
        error3.isNotEmpty ||
        error4.isNotEmpty) {
      return;
    }

    try {
      final double H = double.parse(distController.text);
      final double G = double.parse(angGrapaController.text);
      final double V = double.parse(longVanoController.text);
      final double F = double.parse(flechaTeorController.text);

      final double S = CalculoS(F, H, V);
      double ang = CalculoArcTan(G, S);

      // Igual que Android: si el ángulo sale negativo → usar CalculoC
      if (ang < 0.0) {
        ang = CalculoC(S, G);
      }

      setState(() {
        resultado = "Ángulo para flechar: ${ang.toStringAsFixed(3)} º";
      });
    } catch (e) {
      setState(() => msgError = "Error en el cálculo. Revisa los datos.");
    }
  }

  // ------------------------------------------------------------
  //    FUNCIONES PORTADAS 1:1 DEL ANDROID (JAVA → DART)
  // ------------------------------------------------------------

  double CalculoS(double F, double H, double V) {
    return pow((sqrt(F) * 2.0) - sqrt(H), 2.0) / V;
  }

  double CalculoArcTan(double G, double S) {
    final Genrad = om.aradianes(G); // ✔ centesimales → radianes
    final op1 = 1.0 / ((1.0 / tan(Genrad)) - S);
    final res = atan(op1);
    return om.agrados(res); // ✔ radianes → centesimales
  }

  double CalculoC(double S, double G) {
    final Genrad = om.aradianes(G - 100.0);
    final op1 = S + tan(Genrad);
    final res = atan(op1);
    return 100.0 + om.agrados(res);
  }

  // ------------------------------------------------------------
  // LIMPIAR
  // ------------------------------------------------------------
  void limpiarCampos() {
    distController.clear();
    angGrapaController.clear();
    longVanoController.clear();
    flechaTeorController.clear();

    setState(() {
      resultado = "Ángulo para flechar: --";
      msgError = "";
      error1 = error2 = error3 = error4 = "";
    });
  }

  // ------------------------------------------------------------
  // AYUDA
  // ------------------------------------------------------------
  void mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ayuda - Flechar 1 Vano"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.black,
                    insetPadding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 5,
                        child: Center(
                          child: Image.asset('Assets/Images/flechar1vano.jpg'),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Image.asset('Assets/Images/flechar1vano.jpg', height: 130),
            ),
            const SizedBox(height: 12),
            const Text(
              "Introduce distancia, ángulo en grapa, longitud del vano y flecha teórica.\n"
              "El cálculo reproduce exactamente la lógica Android.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar")),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------
  void mostrarLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Deseas volver a la pantalla de inicio?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
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
}
