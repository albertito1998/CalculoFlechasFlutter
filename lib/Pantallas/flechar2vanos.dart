import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

class Flechar2VanosPage extends StatefulWidget {
  const Flechar2VanosPage({super.key});

  @override
  State<Flechar2VanosPage> createState() => _Flechar2VanosPageState();
}

class _Flechar2VanosPageState extends State<Flechar2VanosPage> {
  final txtAngGrapa1 = TextEditingController();
  final txtAngGrapa2 = TextEditingController();
  final txtLongVano1 = TextEditingController();
  final txtLongVano2 = TextEditingController();
  final txtFlechaTeor2 = TextEditingController();

  final om = OperacionesMatematicas();

  String resultado = "Ángulo para flechar vano 2: --";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FLECHAR 2 VANOS"),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            campo("Ángulo grapa 1 (°)", txtAngGrapa1),
            campo("Ángulo grapa 2 (°)", txtAngGrapa2),
            campo("Longitud vano 1 (m)", txtLongVano1),
            campo("Longitud vano 2 (m)", txtLongVano2),
            campo("Flecha teórica vano 2 (m)", txtFlechaTeor2),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularFlechar2Vanos,
              child: const Text("Comprobar"),
            ),
            const SizedBox(height: 16),
            Text(
              resultado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: limpiar,
              icon: const Icon(Icons.clear),
              label: const Text("Vaciar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void calcularFlechar2Vanos() {
    setState(() {
      error = "";
      resultado = "Ángulo para flechar vano 2: --";
    });

    try {
      final A = double.parse(txtAngGrapa1.text);
      final B = double.parse(txtAngGrapa2.text);
      final C = double.parse(txtLongVano1.text);
      final J = double.parse(txtLongVano2.text);
      final F = double.parse(txtFlechaTeor2.text);

      final D = J + C;

      final E = calcularE(F, D, C, B, A);
      final X = calcularX(F, E, D, C);
      final P = calcularP(A, X, C);

      final double angulo = P > 0.0 ? P : 200.0 + P;

      setState(() {
        resultado =
            "Ángulo para flechar vano 2: ${angulo.toStringAsFixed(3)} º";
      });
    } catch (_) {
      setState(() {
        error = "⚠ Error de cálculo. Verifica los valores introducidos.";
      });
    }
  }

  // Fórmulas adaptadas de Java
  double calcularE(double F, double D, double C, double B, double A) {
    final Benrad = om.aradianes(B);
    final Aenrad = om.aradianes(A);
    final OPTan = (1.0 / tan(Benrad)) - (1.0 / tan(Aenrad));
    final prim = 4.0 * ((D / C) - 1.0);
    final seg = (D * OPTan) - (4.0 * F);
    return sqrt((16.0 * F) - (prim * seg));
  }

  double calcularX(double F, double E, double D, double C) {
    return ((-4.0 * sqrt(F)) + E) / (2.0 * ((D / C) - 1.0));
  }

  double calcularP(double A, double X, double C) {
    final Aenrad = om.aradianes(A);
    final RES1 = pow((1.0 / tan(Aenrad)) - (pow(X, 2.0) / C), -1.0);
    return om.agrados(atan(RES1));
  }

  void limpiar() {
    txtAngGrapa1.clear();
    txtAngGrapa2.clear();
    txtLongVano1.clear();
    txtLongVano2.clear();
    txtFlechaTeor2.clear();
    setState(() {
      resultado = "Ángulo para flechar vano 2: --";
      error = "";
    });
  }

  void mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ayuda - Flechar 2 Vanos"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => mostrarImagenCompleta(context),
              child: Image.asset(
                'Assets/Images/flechar2vanos.jpg',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Introduce los ángulos, longitudes de vano y la flecha teórica para obtener el ángulo correcto.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  void mostrarImagenCompleta(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 5,
            child: Center(
              child: Image.asset(
                'Assets/Images/flechar2vanos.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void mostrarLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Deseas cerrar sesión y volver al inicio?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }
}
