import 'package:flutter/material.dart';
import 'Login/login.dart'; // Asegúrate de que existe este archivo
import 'theme.dart'; // Este archivo contiene elecnorTheme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elecnor App',
      debugShowCheckedModeBanner: false,
      theme: elecnorTheme,
      home: const LoginPage(), // Página inicial de la app
      routes: {
        '/login': (context) => const LoginPage(),
        '/menu': (context) =>
            const Placeholder(), // Sustituye por MenuPage si está hecho
        // Añade aquí más rutas si las necesitas
      },
    );
  }
}
