import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class FlechaEstacionLibrePage extends StatefulWidget {
  const FlechaEstacionLibrePage({super.key});

  @override
  State<FlechaEstacionLibrePage> createState() =>
      _FlechaEstacionLibrePageState();
}

class _FlechaEstacionLibrePageState extends State<FlechaEstacionLibrePage> {
  final _altura1 = TextEditingController();
  final _altura2 = TextEditingController();
  final _distancia1 = TextEditingController();
  final _distancia2 = TextEditingController();
  final _anguloGrados = TextEditingController();
  final _anguloMinutos = TextEditingController();
  final _anguloSegundos = TextEditingController();
  final _flecha = TextEditingController();

  String ubicacion = "";
  String viento = "";
  String temperatura = "";
  String radiacion = "";
  String horaUTM = "";
  String resultadoTheta = "";

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionYDatosMeteo();
  }

  Future<void> _obtenerUbicacionYDatosMeteo() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.deniedForever) return;
      }

      final posicion = await Geolocator.getCurrentPosition();
      setState(() => ubicacion = "${posicion.latitude}, ${posicion.longitude}");

      final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=${posicion.latitude}&longitude=${posicion.longitude}"
        "&current_weather=true&hourly=solar_radiation"
        "&timezone=Europe/Berlin",
      );

      final respuesta = await http.get(url);
      final datos = json.decode(respuesta.body);

      setState(() {
        viento = "${datos['current_weather']['windspeed']} m/s";
        temperatura = "${datos['current_weather']['temperature']} °C";
        horaUTM = datos['current_weather']['time'];
        radiacion = "${datos['hourly']['solar_radiation'][0]} W/m²";
      });
    } catch (e) {
      // Error al obtener ubicación o datos meteorológicos
    }
  }

  void _comprobarDatos() {
    if ([
      _altura1,
      _altura2,
      _distancia1,
      _distancia2,
      _anguloGrados,
      _anguloMinutos,
      _anguloSegundos,
      _flecha
    ].any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todos los campos deben estar completos")),
      );
      return;
    }

    try {
      final ha = double.parse(_altura1.text);
      final hb = double.parse(_altura2.text);
      final da = double.parse(_distancia1.text);
      final db = double.parse(_distancia2.text);
      final flecha = double.parse(_flecha.text);

      final theta = 90 -
          atan(((ha + hb) / 2 - flecha) / sqrt(pow(da, 2) + pow(db, 2))) *
              180 /
              pi;

      setState(() => resultadoTheta = "${theta.toStringAsFixed(2)}°");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error en los datos numéricos")),
      );
    }
  }

  void _mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ayuda - Estación Libre"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Introduce las alturas, distancias, ángulo y flecha topográfica. Se calcula el ángulo θ exacto."),
            const SizedBox(height: 12),
            Image.asset('assets/images/flechar2vanos.jpg'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flecha Estación Libre"),
        backgroundColor: const Color(0xFF003057),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: "Ayuda",
            onPressed: () => _mostrarAyuda(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Parámetros de entrada",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _campo("Altura útil Torre 1 (m)", _altura1),
            _campo("Altura útil Torre 2 (m)", _altura2),
            _campo("Distancia Torre 1 (m)", _distancia1),
            _campo("Distancia Torre 2 (m)", _distancia2),
            Row(
              children: [
                Expanded(child: _campo("Grados", _anguloGrados)),
                const SizedBox(width: 6),
                Expanded(child: _campo("Minutos", _anguloMinutos)),
                const SizedBox(width: 6),
                Expanded(child: _campo("Segundos", _anguloSegundos)),
              ],
            ),
            _campo("Flecha (m)", _flecha),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _comprobarDatos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003057),
                foregroundColor: Colors.white,
              ),
              child: const Text("Comprobar"),
            ),
            const SizedBox(height: 16),
            const Text("Resultado θ (flecha topográfica):",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(resultadoTheta, style: const TextStyle(fontSize: 24)),
            const Divider(height: 40),
            const Text("Datos Meteorológicos",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _info("Ubicación", ubicacion),
            _info("Viento", viento),
            _info("Temperatura", temperatura),
            _info("Radiación Solar", radiacion),
            _info("Hora UTM", horaUTM),
          ],
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
