import 'package:flutter/material.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

class CalcularLongitudPage extends StatefulWidget {
  const CalcularLongitudPage({super.key});

  @override
  State<CalcularLongitudPage> createState() => _CalcularLongitudPageState();
}

class _CalcularLongitudPageState extends State<CalcularLongitudPage> {
  final txtAlturaController = TextEditingController();
  final txtAnguloSupController = TextEditingController();
  final txtAnguloInfController = TextEditingController();

  String result = "Longitud Medida: --";
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CALCULAR LONGITUD"),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Introduzca los siguientes datos:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            campoNumerico("Altura (m)", txtAlturaController),
            campoNumerico("Ángulo parte superior (°)", txtAnguloSupController),
            campoNumerico("Ángulo parte inferior (°)", txtAnguloInfController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularLongitud,
              child: const Text("Calcular"),
            ),
            const SizedBox(height: 16),
            Text(result,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (errorMessage.isNotEmpty)
              Text("⚠ $errorMessage",
                  style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
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

  Widget campoNumerico(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void limpiarCampos() {
    txtAlturaController.clear();
    txtAnguloSupController.clear();
    txtAnguloInfController.clear();
    setState(() {
      result = "Longitud Medida: --";
      errorMessage = "";
    });
  }

  void calcularLongitud() {
    setState(() {
      result = "Longitud Medida: --";
      errorMessage = "";
    });

    try {
      final double M = double.parse(txtAlturaController.text);
      final double G = double.parse(txtAnguloSupController.text);
      final double C = double.parse(txtAnguloInfController.text);

      final om = OperacionesMatematicas();
      double tang;

      if (C < 100.0 && G < 100.0) {
        tang = om.calculotang1(G, C);
      } else if (C > 100.0 && G > 100.0) {
        tang = om.calculotang2(G, C);
      } else {
        tang = om.calculotang3(G, C);
      }

      double L = M / tang;
      setState(() {
        result = "Longitud Medida: ${L.toStringAsFixed(3)} m";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Valores inválidos. Introduzca números correctos.";
      });
    }
  }

  void mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ayuda - Calcular Longitud"),
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
              "Introduzca la altura y los ángulos superior e inferior del conductor.\nLa fórmula utilizada depende de los valores angulares.",
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
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4.0,
            child: Image.asset('Assets/Images/flechar1vano.jpg'),
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
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }
}
