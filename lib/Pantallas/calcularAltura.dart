import 'package:flutter/material.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

class CalcularAlturaPage extends StatefulWidget {
  const CalcularAlturaPage({super.key});

  @override
  State<CalcularAlturaPage> createState() => _CalcularAlturaPageState();
}

class _CalcularAlturaPageState extends State<CalcularAlturaPage> {
  final TextEditingController txtAngSupController = TextEditingController();
  final TextEditingController txtLongVanoController = TextEditingController();
  final TextEditingController txtAngInfController = TextEditingController();

  String errorMessage = "";
  String result = "";
  final om = OperacionesMatematicas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CALCULAR ALTURA"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
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
          children: <Widget>[
            const Text(
              "Introduzca los siguientes datos:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            campo("- Ángulo parte superior", txtAngSupController),
            campo("- Longitud del vano (m)", txtLongVanoController),
            campo("- Ángulo parte inferior", txtAngInfController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calcularAltura,
                child: const Text("Calcular"),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Altura Calculada: $result",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              errorMessage.isEmpty ? "" : "⚠ $errorMessage",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  void calcularAltura() {
    setState(() {
      errorMessage = "";
      result = "";
    });

    try {
      final double G = double.parse(txtAngSupController.text);
      final double L = double.parse(txtLongVanoController.text);
      final double C = double.parse(txtAngInfController.text);

      // Lógica original del Java (sin conversión imperial)
      double tang;
      if (C < 100.0 && G < 100.0) {
        tang = om.calculotang1(G, C);
      } else if (C > 100.0 && G > 100.0) {
        tang = om.calculotang2(G, C);
      } else {
        tang = om.calculotang3(G, C);
      }

      final altura = L * tang;

      setState(() {
        result = "${altura.toStringAsFixed(3)} m";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Valores no válidos. Introduzca números válidos.";
      });
    }
  }
}

// ------------------------------------------------------------------
// DIÁLOGO DE AYUDA
// ------------------------------------------------------------------
void mostrarAyuda(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Ayuda - Calcular Altura'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => mostrarImagenAmpliada(context),
            child: Image.asset(
              'Assets/Images/flechar1vano.jpg',
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Introduzca los ángulos superior e inferior del cable y la longitud del vano. '
            'La fórmula seleccionará automáticamente la tangente correcta y calculará la altura proyectada.',
            textAlign: TextAlign.justify,
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

void mostrarImagenAmpliada(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.black,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.8,
          maxScale: 4.0,
          child: Image.asset(
            'Assets/Images/flechar1vano.jpg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}

// ------------------------------------------------------------------
// DIÁLOGO CERRAR SESIÓN
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
