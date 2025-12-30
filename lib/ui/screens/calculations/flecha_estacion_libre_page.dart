import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:elecnorappflechas/ui/widgets/widgets.dart';

/// Pantalla para calcular la flecha desde una estación libre.
///
/// Utiliza las alturas útiles de las torres, las distancias desde la estación libre,
/// el ángulo medido y la flecha topográfica para determinar el ángulo θ correcto.
///
/// **Características adicionales:**
/// - Obtención automática de ubicación GPS
/// - Consulta de datos meteorológicos en tiempo real
/// - Información de viento, temperatura y radiación solar
class FlechaEstacionLibrePage extends StatefulWidget {
  const FlechaEstacionLibrePage({super.key});

  @override
  State<FlechaEstacionLibrePage> createState() =>
      _FlechaEstacionLibrePageState();
}

class _FlechaEstacionLibrePageState extends State<FlechaEstacionLibrePage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _altura1 = TextEditingController();
  final TextEditingController _altura2 = TextEditingController();
  final TextEditingController _distancia1 = TextEditingController();
  final TextEditingController _distancia2 = TextEditingController();
  final TextEditingController _anguloGrados = TextEditingController();
  final TextEditingController _anguloMinutos = TextEditingController();
  final TextEditingController _anguloSegundos = TextEditingController();
  final TextEditingController _flecha = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _ubicacion = '';
  String _viento = '';
  String _temperatura = '';
  String _radiacion = '';
  String _horaUTM = '';
  String _resultadoTheta = '';

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionYDatosMeteo();
  }

  @override
  void dispose() {
    _altura1.dispose();
    _altura2.dispose();
    _distancia1.dispose();
    _distancia2.dispose();
    _anguloGrados.dispose();
    _anguloMinutos.dispose();
    _anguloSegundos.dispose();
    _flecha.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flecha Estación Libre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Ayuda',
            onPressed: () => _mostrarAyuda(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _mostrarLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InfoCard(
              title: 'Flecha desde Estación Libre',
              content:
                  'Calcula el ángulo θ para flechado desde una estación libre usando las alturas de las torres y distancias.',
              icon: Icons.location_searching,
            ),
            const SizedBox(height: 24),
            const Text(
              'Parámetros de entrada',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campos de entrada
            NumericTextField(
              label: 'Altura útil Torre 1',
              controller: _altura1,
              suffix: 'm',
              prefixIcon: Icons.height,
            ),
            NumericTextField(
              label: 'Altura útil Torre 2',
              controller: _altura2,
              suffix: 'm',
              prefixIcon: Icons.height,
            ),
            NumericTextField(
              label: 'Distancia Torre 1',
              controller: _distancia1,
              suffix: 'm',
              prefixIcon: Icons.straighten,
            ),
            NumericTextField(
              label: 'Distancia Torre 2',
              controller: _distancia2,
              suffix: 'm',
              prefixIcon: Icons.straighten,
            ),

            const SizedBox(height: 16),
            const Text(
              'Ángulo medido:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: NumericTextField(
                    label: 'Grados',
                    controller: _anguloGrados,
                    prefixIcon: null,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: NumericTextField(
                    label: 'Minutos',
                    controller: _anguloMinutos,
                    prefixIcon: null,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: NumericTextField(
                    label: 'Segundos',
                    controller: _anguloSegundos,
                    prefixIcon: null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            NumericTextField(
              label: 'Flecha',
              controller: _flecha,
              suffix: 'm',
              prefixIcon: Icons.show_chart,
            ),

            const SizedBox(height: 24),

            // Botón comprobar
            PrimaryButton(
              text: 'Comprobar',
              onPressed: _comprobarDatos,
              icon: Icons.calculate,
            ),

            const SizedBox(height: 24),

            // Resultado
            if (_resultadoTheta.isNotEmpty)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: ResultCard(
                  title: 'Resultado θ (flecha topográfica)',
                  value: _resultadoTheta,
                  icon: Icons.architecture,
                ),
              ),

            const Divider(height: 40),

            // Datos meteorológicos
            const Text(
              'Datos Meteorológicos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ModernCard(
              child: Column(
                children: [
                  _buildInfoTile('Ubicación', _ubicacion),
                  _buildInfoTile('Viento', _viento),
                  _buildInfoTile('Temperatura', _temperatura),
                  _buildInfoTile('Radiación Solar', _radiacion),
                  _buildInfoTile('Hora UTM', _horaUTM),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================================
  // WIDGETS AUXILIARES
  // ========================================================================

  /// Construye una fila de información con título y valor.
  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value.isEmpty ? 'Cargando...' : value),
    );
  }

  // ========================================================================
  // LÓGICA DE CÁLCULO
  // ========================================================================

  /// Comprueba los datos y calcula el ángulo θ.
  ///
  /// Fórmula: θ = 90 - arctan(((ha + hb)/2 - f) / √(da² + db²))
  void _comprobarDatos() {
    // Validar que todos los campos estén completos
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
      _mostrarSnackBar('Todos los campos deben estar completos');
      return;
    }

    try {
      final ha = double.parse(_altura1.text);
      final hb = double.parse(_altura2.text);
      final da = double.parse(_distancia1.text);
      final db = double.parse(_distancia2.text);
      final flecha = double.parse(_flecha.text);

      // Validaciones
      if (ha <= 0 || hb <= 0 || da <= 0 || db <= 0 || flecha <= 0) {
        _mostrarSnackBar('Todos los valores deben ser mayores que cero');
        return;
      }

      // Cálculo del ángulo θ
      final alturaPromedio = (ha + hb) / 2;
      final distanciaTotal = sqrt(pow(da, 2) + pow(db, 2));
      final theta =
          90 - atan((alturaPromedio - flecha) / distanciaTotal) * 180 / pi;

      setState(() {
        _resultadoTheta = '${theta.toStringAsFixed(2)}°';
      });
    } on FormatException {
      _mostrarSnackBar('Error en los datos numéricos');
    } catch (e) {
      _mostrarSnackBar('Error en el cálculo: ${e.toString()}');
    }
  }

  /// Muestra un mensaje en la parte inferior de la pantalla.
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  // ========================================================================
  // DATOS METEOROLÓGICOS
  // ========================================================================

  /// Obtiene la ubicación GPS y consulta los datos meteorológicos.
  Future<void> _obtenerUbicacionYDatosMeteo() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _ubicacion = 'Servicio de ubicación deshabilitado');
        return;
      }

      // Verificar permisos
      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.deniedForever) {
          setState(() =>
              _ubicacion = 'Permisos de ubicación denegados permanentemente');
          return;
        }
      }

      // Obtener posición actual
      final posicion = await Geolocator.getCurrentPosition();
      setState(() {
        _ubicacion =
            '${posicion.latitude.toStringAsFixed(4)}, ${posicion.longitude.toStringAsFixed(4)}';
      });

      // Consultar API meteorológica
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=${posicion.latitude}&longitude=${posicion.longitude}'
        '&current_weather=true&hourly=solar_radiation'
        '&timezone=Europe/Berlin',
      );

      final respuesta = await http.get(url);
      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);

        setState(() {
          _viento = '${datos['current_weather']['windspeed']} m/s';
          _temperatura = '${datos['current_weather']['temperature']} °C';
          _horaUTM = datos['current_weather']['time'] ?? '';
          _radiacion = '${datos['hourly']['solar_radiation'][0]} W/m²';
        });
      }
    } catch (e) {
      setState(() => _ubicacion = 'Error al obtener ubicación');
    }
  }

  // ========================================================================
  // DIÁLOGOS
  // ========================================================================

  /// Muestra el diálogo de ayuda con información sobre el cálculo.
  void _mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Estación Libre'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen ilustrativa
              GestureDetector(
                onTap: () => _mostrarImagenAmpliada(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'Assets/Images/flechar2vanos.jpg',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Esta herramienta calcula el ángulo θ para flechado desde una estación libre.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('• Alturas útiles de las torres (m)'),
              const Text('• Distancias desde la estación libre (m)'),
              const Text('• Ángulo medido (grados, minutos, segundos)'),
              const Text('• Flecha topográfica (m)'),

              const SizedBox(height: 12),

              const Text(
                'Adicionalmente, se obtienen datos meteorológicos en tiempo real para '
                'facilitar el análisis de condiciones de trabajo.',
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

              const Text(
                '💡 Toque la imagen para verla ampliada',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra la imagen en pantalla completa con zoom.
  void _mostrarImagenAmpliada(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 4.0,
            child: Image.asset(
              'Assets/Images/flechar2vanos.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de confirmación para cerrar sesión.
  void _mostrarLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Desea volver a la pantalla de inicio de sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}
