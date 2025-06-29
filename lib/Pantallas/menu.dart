import 'package:elecnorappflechas/Pantallas/flechar1vano.dart';
import 'package:flutter/material.dart';

import '../Login/provider.dart';
import 'calcularAltura.dart';
import 'carcularLongitud.dart';
import 'comprobarFlecha1Vano.dart';
import 'comprobarFlecha2Vanos.dart';
import 'flechar2vanos.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ELECNOR PROYECTOS Y SERVICIOS'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              label: 'Flechar 1 vano',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Sag1Span()));
              },
            ),
            MenuButton(
              label: 'Flechar 2 Vanos',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Sag2Span()));
              },
            ),
            MenuButton(
              label: 'Medir altura',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalculateHeightPage()));
              },
            ),
            MenuButton(
              label: 'Medir longitud',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalculateLengthPage()));
              },
            ),
            MenuButton(
              label: 'Comprobar flecha 1 vano',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckSag1SpanPage()));
              },
            ),
            MenuButton(
              label: 'Comprobar flecha 2 vanos',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckSag2SpanPage()));
              },
            ),
            MenuButton(
              label: 'Salir',
              onPressed: () {
                final auth = Provider.of(context).auth;
                auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MenuButton({required this.label, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
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
