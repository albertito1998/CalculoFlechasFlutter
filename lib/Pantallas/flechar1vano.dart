import 'dart:math';

import 'package:flutter/material.dart';

import '../Login/provider.dart';

class Sag1Span extends StatefulWidget {
  @override
  _Flechar1VanoState createState() => _Flechar1VanoState();
}

class _Flechar1VanoState extends State<Sag1Span> {
  TextEditingController distController = TextEditingController();
  TextEditingController anggrapaController = TextEditingController();
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
        title: const Text("FLECHAR 1 VANO"),
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
          children: [
            const Text(
              'Flechar 1 Vano',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: distController,
              decoration: const InputDecoration(labelText: 'Distancia'),
            ),
            TextField(
              controller: anggrapaController,
              decoration:
                  const InputDecoration(labelText: 'Ángulo de la grapa'),
            ),
            TextField(
              controller: longvanController,
              decoration: const InputDecoration(labelText: 'Longitud del vano'),
            ),
            TextField(
              controller: flechteorController,
              decoration: const InputDecoration(labelText: 'Flecha teórica'),
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
                calculate1Sag();
              },
              child: const Text('Comprobar'),
            ),
            Text(anguloflechar),
            Text(
              "(*) $msgerror",
              style: const TextStyle(color: Colors.red),
            ),
            ElevatedButton(
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
          ],
        ),
      ),
    );
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
              Image.asset('Assets/Images/flechar1vano.jpg'),
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
  void calculate1Sag() {
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
        double H = double.tryParse(distController.text) ?? 0.0;
        double G = double.tryParse(anggrapaController.text) ?? 0.0;
        double V = double.tryParse(longvanController.text) ?? 0.0;
        double F = double.tryParse(flechteorController.text) ?? 0.0;
        double S = CalculoS(F, H, V);
        double arctan = CalculoArcTan(G, S);
        double resultado = arctan;
        if (arctan < 0.0) {
          resultado = CalculoC(S, G);
        }
        anguloflechar =
            "Ángulo para flechar: ${resultado.toStringAsFixed(3)} º";
      } else {
        anguloflechar = "Ángulo para flechar: --";
      }
    });
  }

  double CalculoS(double F, double H, double V) {
    return pow((sqrt(F) * 2.0) - sqrt(H), 2.0) / V;
  }

  double CalculoArcTan(double G, double S) {
    double Genrad = aradianes(G);
    double op1 = 1.0 / ((1.0 / tan(Genrad)) - S);
    double res1 = atan(op1);
    double res = agrados(res1);
    return res;
  }

  double CalculoC(double S, double G) {
    double Genrad = aradianes(G - 100.0);
    double op1 = S + tan(Genrad);
    double res1 = atan(op1);
    double res = 100.0 + agrados(res1);
    return res;
  }

  double aradianes(double grados) {
    return (grados * pi) / 180.0;
  }

  double agrados(double radianes) {
    return (radianes * 180.0) / pi;
  }
}
