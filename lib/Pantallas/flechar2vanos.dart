import 'package:flutter/material.dart';

import '../Login/provider.dart';

class Sag2Span extends StatefulWidget {
  @override
  _Flechar2VanosScreenState createState() => _Flechar2VanosScreenState();
}

class _Flechar2VanosScreenState extends State<Sag2Span> {
  TextEditingController anggrapa1Controller = TextEditingController();
  TextEditingController anggrapa2Controller = TextEditingController();
  TextEditingController lonvan1Controller = TextEditingController();
  TextEditingController lonvan2Controller = TextEditingController();
  TextEditingController flechteorvan2Controller = TextEditingController();
  String anguloflechar2 = "Ángulo para flechar vano 2: --";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FLECHAR 2 VANOS"),
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
            Image.asset(
              'Assets/Images/Elecnor.png',
              // Asegúrate de tener la imagen en la carpeta assets
              width: 56.0,
              height: 31.0,
            ),
            const Text(
              'ELECNOR PROYECTYOS Y SERVICIOS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Introduzca los siguientes datos:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const Text(
              'FLECHAR 2 VANOS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('- Ángulo en grapa 1:'),
            TextField(
              controller: anggrapa1Controller,
              keyboardType: TextInputType.number,
            ),
            const Text('- Ángulo en grapa 2:'),
            TextField(
              controller: anggrapa2Controller,
              keyboardType: TextInputType.number,
            ),
            const Text('- Longitud del vano 1:'),
            TextField(
              controller: lonvan1Controller,
              keyboardType: TextInputType.number,
            ),
            const Text('- Longitud del vano 2:'),
            TextField(
              controller: lonvan2Controller,
              keyboardType: TextInputType.number,
            ),
            const Text('- Flecha teórica del vano 2:'),
            TextField(
              controller: flechteorvan2Controller,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                calculateAngle();
              },
              child: const Text('Comprobar'),
            ),
            Text(anguloflechar2),
            ElevatedButton(
              onPressed: () {
                clearFields();
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
              Image.asset('Assets/Images/flechar2vanos.jpg'),
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

  void calculateAngle() {
    // Realiza los cálculos aquí y actualiza anguloflechar2 con el resultado.
  }

  void clearFields() {
    anggrapa1Controller.text = '';
    anggrapa2Controller.text = '';
    lonvan1Controller.text = '';
    lonvan2Controller.text = '';
    flechteorvan2Controller.text = '';
    setState(() {
      anguloflechar2 = 'Ángulo para flechar vano 2: --';
    });
  }
}
