import 'package:flutter/material.dart';

import '../Login/provider.dart';

class CalculateHeightPage extends StatefulWidget {
  @override
  _CalculateHeightPageState createState() => _CalculateHeightPageState();
}

class _CalculateHeightPageState extends State<CalculateHeightPage> {
  TextEditingController txtAngSupController = TextEditingController();
  TextEditingController txtLongVanoController = TextEditingController();
  TextEditingController txtAngInfController = TextEditingController();

  String errorMessage = "";
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CALCULAR ALTURA"),
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
              controller: txtAngSupController,
              decoration:
                  const InputDecoration(labelText: "- Ángulo parte superior"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtLongVanoController,
              decoration:
                  const InputDecoration(labelText: "- Longitud del vano"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtAngInfController,
              decoration:
                  const InputDecoration(labelText: "- Ángulo parte inferior"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                calculateHeight();
              },
              child: const Text("Comprobar"),
            ),
            Text(
              "Altura Medida: $result",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "(*) $errorMessage",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void calculateHeight() {
    // Implementa la lógica de cálculo aquí.
    // Utiliza los valores ingresados en txtAngSupController, txtLongVanoController y txtAngInfController.
    // Actualiza el estado y muestra el resultado o mensajes de error.
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
            Image.asset('Assets/Images/flechar1vano.jpg'), // Ruta de la imagen
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
