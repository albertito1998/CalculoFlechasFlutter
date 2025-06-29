import 'package:flutter/material.dart';

import '../Login/provider.dart';

class CheckSag2SpanPage extends StatefulWidget {
  @override
  _CalculateSag2SpansPageState createState() => _CalculateSag2SpansPageState();
}

class _CalculateSag2SpansPageState extends State<CheckSag2SpanPage> {
  TextEditingController txtAngGrapa1Controller = TextEditingController();
  TextEditingController txtAngGrapa2Controller = TextEditingController();
  TextEditingController txtAngCableVano2Controller = TextEditingController();
  TextEditingController txtLongVano1Controller = TextEditingController();
  TextEditingController txtLongVano2Controller = TextEditingController();
  TextEditingController txtFlechaVano2Controller = TextEditingController();

  String errorMessage = "";
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COMPROBAR FLECHA EN 2 VANOS"),
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
              controller: txtAngGrapa1Controller,
              decoration:
                  const InputDecoration(labelText: "- Ángulo en grapa 1"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtAngGrapa2Controller,
              decoration:
                  const InputDecoration(labelText: "- Ángulo en grapa 2"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtAngCableVano2Controller,
              decoration: const InputDecoration(
                  labelText: "- Ángulo en cable del vano 2"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtLongVano1Controller,
              decoration:
                  const InputDecoration(labelText: "- Longitud del vano 1"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtLongVano2Controller,
              decoration:
                  const InputDecoration(labelText: "- Longitud del vano 2"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: txtFlechaVano2Controller,
              decoration: const InputDecoration(
                  labelText: "- Flecha teórica del vano 2"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                calculateSag2Spans();
              },
              child: const Text("Comprobar"),
            ),
            Text(
              "Flecha Real: $result",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "(*) $errorMessage",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementa aquí la lógica para vaciar los campos de entrada.
        },
        child: const Icon(Icons.clear),
      ),
    );
  }

  void calculateSag2Spans() {
    // Implementa la lógica de cálculo aquí.
    // Utiliza los valores ingresados en los controladores de texto.
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
            Image.asset('Assets/Images/comprobarflecha2vanos.jpg'),
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
