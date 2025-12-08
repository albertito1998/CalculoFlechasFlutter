import 'package:elecnorappflechas/Pantallas/tolerancias.dart';
import 'package:flutter/material.dart';

// Importación de cada pantalla (revisadas y renombradas correctamente)
import 'calcularAltura.dart';
import 'calcularLongitud.dart';
import 'comprobarFlecha1Vano.dart';
import 'comprobarFlecha2Vanos.dart';
import 'flechar1vano.dart';
import 'flechar2vanos.dart';
import 'flecha_estacion_libre.dart'; // Nueva importación

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Diálogo de confirmación para cerrar sesión
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Confirmación al pulsar botón atrás (salir de la app)
  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir de la aplicación?'),
            content: const Text('¿Estás seguro de que deseas cerrar la app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.7;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ELECNOR PROYECTOS Y SERVICIOS'),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: _showLogoutDialog,
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/Elecnor.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  MenuButton(
                    label: 'Flechar 1 vano',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Flechar1VanoPage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Flechar 2 vanos',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Flechar2VanosPage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Medir altura',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CalcularAlturaPage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Medir longitud',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CalcularLongitudPage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Comprobar flecha 1 vano',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ComprobarFlecha1VanoPage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Comprobar flecha 2 vanos',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ComprobarFlecha2VanosPage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Flechar con estación total libre',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FlechaEstacionLibrePage(),
                      ),
                    ),
                  ),
                  MenuButton(
                    label: 'Tolerancias Alemania',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ToleranciasPage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  MenuButton(label: 'Salir', onPressed: _showLogoutDialog),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MenuButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.7;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
