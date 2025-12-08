// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ToleranciasPage extends StatefulWidget {
  const ToleranciasPage({super.key});

  @override
  State<ToleranciasPage> createState() => _ToleranciasPageState();
}

class _ToleranciasPageState extends State<ToleranciasPage> {
  final TextEditingController _longitudController = TextEditingController();
  String _resultado = "0 cm";

  // ===========================================================
  // CÁLCULO (replica exacto de tu Java)
  // ===========================================================
  void calcularTolerancia() {
    final text = _longitudController.text.trim();

    if (text.isEmpty) {
      setState(() => _resultado = "Ingrese un valor válido");
      return;
    }

    final double L = double.tryParse(text) ?? -1;
    if (L <= 0) {
      setState(() => _resultado = "Valor incorrecto");
      return;
    }

    double tolerancia;

    if (L < 200) {
      tolerancia = 5;
    } else if (L > 500) {
      tolerancia = 20;
    } else {
      tolerancia = ((0.05 * L - 5) * 10).round() / 10.0;
    }

    setState(() => _resultado = "$tolerancia cm");
  }

  // ===========================================================
  // DIÁLOGO DE AYUDA
  // ===========================================================
  void mostrarAyuda() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Ayuda - Tolerancias de Flecha"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("Assets/Images/tennettolerancias.jpg"),
            SizedBox(height: 12),
            Text(
              "La tolerancia depende de la longitud del vano.\n\n"
              "<200 m → 5 cm\n"
              "200–500 m → fórmula 0.05·L − 5\n"
              ">500 m → 20 cm",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          )
        ],
      ),
    );
  }

  // ===========================================================
  // BOTÓN SALIR
  // ===========================================================
  void mostrarSalir() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Salir"),
        content: Text("¿Desea volver al menú principal?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/menu');
            },
            child: Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tolerancias de Flecha"),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: mostrarAyuda,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: mostrarSalir,
          ),
        ],
      ),

      // ===========================================================
      // BODY CON FONDO CORPORATIVO
      // ===========================================================
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/Images/Elecnor.jpg"),
            fit: BoxFit.cover,
            opacity: 0.25,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------
              // LOGO ELECNOR
              // ----------------------------------------------------
              Row(
                children: [
                  Image.asset("Assets/Images/Elecnor.jpg",
                      width: 70, height: 35),
                  SizedBox(width: 12),
                  Text(
                    "ELECNOR PROYECTOS Y SERVICIOS",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),

              SizedBox(height: 25),

              Text(
                "Tolerancias de Flecha",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              // ----------------------------------------------------
              // CAMPO LONGITUD
              // ----------------------------------------------------
              Text("Longitud del vano (m):",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _longitudController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "0.00",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("m"),
                ],
              ),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: calcularTolerancia,
                  child: Text("Calcular"),
                ),
              ),

              SizedBox(height: 25),

              // ----------------------------------------------------
              // TABLA NORMATIVA
              // ----------------------------------------------------
              Text(
                "Normativa de Tolerancias",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              GestureDetector(
                onTap: () => mostrarImagen(
                    context, "Assets/Images/tennettolerancias.jpg"),
                child: Image.asset(
                  "Assets/Images/tennettolerancias.jpg",
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 25),

              // ----------------------------------------------------
              // RESULTADO
              // ----------------------------------------------------
              Text(
                "Tolerancia Calculada:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                _resultado,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              SizedBox(height: 35),

              // ----------------------------------------------------
              // LOGOS DE CLIENTES
              // ----------------------------------------------------
              Text(
                "Clientes en Alemania:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("Assets/Images/tennet.png", width: 60),
                  Image.asset("Assets/Images/transnetbw.png", width: 60),
                  Image.asset("Assets/Images/hertz50.png", width: 60),
                  Image.asset("Assets/Images/amprion.png", width: 60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // EXPANDIR IMAGEN EN PANTALLA COMPLETA
  // ===========================================================
  void mostrarImagen(BuildContext context, String ruta) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: InteractiveViewer(
          child: Image.asset(ruta),
        ),
      ),
    );
  }
}
