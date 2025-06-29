import 'dart:math';

import 'package:flutter/material.dart';

import '../Login/provider.dart';

class CheckSag1SpanPage extends StatefulWidget {
  @override
  _CalculateSagPageState createState() => _CalculateSagPageState();
}

class _CalculateSagPageState extends State<CheckSag1SpanPage> {
  TextEditingController distController = TextEditingController();
  TextEditingController anggrapaController = TextEditingController();
  TextEditingController txtAnguloCableController = TextEditingController();
  TextEditingController longvanController = TextEditingController();
  TextEditingController flechteorController = TextEditingController();

  String anguloflechar = "Ángulo para flechar: --";
  String msgerror = "";
  String error1 = "";
  String error2 = "";
  String error3 = "";
  String error4 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COMPROBAR FLECHA 1 VANO"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              MostrarAyuda(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Introduzca los siguientes datos:"),
            TextField(
              controller: distController,
              decoration: const InputDecoration(
                  labelText: "- Distancia taquímetro a fase"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: anggrapaController,
              decoration: const InputDecoration(labelText: "- Ángulo en grapa"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtAnguloCableController,
              decoration: const InputDecoration(labelText: "- Ángulo en cable"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: longvanController,
              decoration:
                  const InputDecoration(labelText: "- Longitud del vano"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: flechteorController,
              decoration: const InputDecoration(labelText: "- Flecha teórica"),
              keyboardType: TextInputType.number,
            ),
            Text(
              msgerror,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            Text(error1, style: const TextStyle(color: Colors.red)),
            Text(error2, style: const TextStyle(color: Colors.red)),
            Text(error3, style: const TextStyle(color: Colors.red)),
            Text(error4, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () {
                calculateSag();
              },
              child: const Text("Comprobar"),
            ),
            const Text(
              "Flecha Real:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "(*) $msgerror",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            distController.text = '';
            anggrapaController.text = '';
            longvanController.text = '';
            flechteorController.text = '';
            anguloflechar = "Ángulo para flechar: --";
          });
        },
        child: const Text('Vaciar'),
      ),
    );
  }

  void calculateSag() {
    // Implementa la lógica de cálculo aquí.
    // Utiliza los valores ingresados en los controladores de texto.
    // Actualiza el estado y muestra el resultado o mensajes de error.
    setState(() {
      msgerror = "";
      error1 = distController.text.isEmpty ? "Campo requerido" : "";
      error2 = anggrapaController.text.isEmpty ? "Campo requerido" : "";
      error3 = longvanController.text.isEmpty ? "Campo requerido" : "";
      error4 = flechteorController.text.isEmpty ? "Campo requerido" : "";

      if (error1.isEmpty &&
          error2.isEmpty &&
          error3.isEmpty &&
          error4.isEmpty) {
        final H = double.parse(distController.text);
        final G = double.parse(anggrapaController.text);
        final V = double.parse(longvanController.text);
        final F = double.parse(flechteorController.text);
        final S = CalculoS(F, H, V);
        final arctan = CalculoArcTan(G, S);
        double resultado = arctan;
        if (arctan < 0) {
          resultado = CalculoC(S, G);
        }
        anguloflechar =
            "Ángulo para flechar: ${resultado.toStringAsFixed(3)} º";
      } else {
        anguloflechar = "Ángulo para flechar: --";
      }
    });
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final auth = Provider.of(context).auth;
              auth.signOut();
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

void MostrarAyuda(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Explicación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('Assets/Images/comprobarflecha1vano.jpg'),
            // Ruta de la imagen
            const Text('Aquí puedes agregar tu explicación adicional.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

// --------------------------------------------------------------

double CalculoS(double F, double H, double V) {
  final res = pow((sqrt(F) * 2.0) - sqrt(H), 2.0) / V;
  return res;
}

double CalculoArcTan(double G, double S) {
  final Genrad = aradianes(G);
  final op1 = 1.0 / ((1.0 / tan(Genrad)) - S);
  final res1 = atan(op1);
  final res = agrados(res1);
  return res;
}

double CalculoC(double S, double G) {
  final Genrad = aradianes(G - 100.0);
  final op1 = S + tan(Genrad);
  final res1 = atan(op1);
  final res = 100.0 + agrados(res1);
  return res;
}

double aradianes(double grados) {
  return (grados * pi) / 180.0;
}

double agrados(double radianes) {
  return (radianes * 180.0) / pi;
}
