import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import 'package:elecnorappflechas/ui/widgets/widgets.dart';

/// Pantalla para calcular el ángulo necesario para flechar un vano.
///
/// Utiliza la distancia del taquímetro, el ángulo en grapa, la longitud
/// del vano y la flecha teórica para determinar el ángulo correcto de flechado.
///
/// **Proceso:**
/// 1. Calcula el parámetro S a partir de la flecha, distancia y longitud
/// 2. Determina el ángulo mediante arctan
/// 3. Si el resultado es negativo, aplica una corrección
class Flechar1VanoPage extends StatefulWidget {
  const Flechar1VanoPage({super.key});

  @override
  State<Flechar1VanoPage> createState() => _Flechar1VanoPageState();
}

class _Flechar1VanoPageState extends State<Flechar1VanoPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _distController = TextEditingController();
  final TextEditingController _angGrapaController = TextEditingController();
  final TextEditingController _longVanoController = TextEditingController();
  final TextEditingController _flechaTeorController = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _resultado = '';
  String _msgError = '';
  final _operaciones = const OperacionesMatematicas();

  @override
  void dispose() {
    _distController.dispose();
    _angGrapaController.dispose();
    _longVanoController.dispose();
    _flechaTeorController.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flechar 1 Vano'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoCard(
              title: 'Flechar 1 Vano',
              content:
                  'Calcula el ángulo necesario para flechar correctamente el vano usando el taquímetro.',
              icon: Icons.architecture,
            ),
            const SizedBox(height: 24),
            const Text(
              'Parámetros de entrada',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campos de entrada
            NumericTextField(
              label: 'Distancia taquímetro',
              controller: _distController,
              suffix: 'm',
              prefixIcon: Icons.straighten,
            ),
            NumericTextField(
              label: 'Ángulo en grapa',
              controller: _angGrapaController,
              suffix: '°',
              prefixIcon: Icons.architecture,
            ),
            NumericTextField(
              label: 'Longitud del vano',
              controller: _longVanoController,
              suffix: 'm',
              prefixIcon: Icons.linear_scale,
            ),
            NumericTextField(
              label: 'Flecha teórica',
              controller: _flechaTeorController,
              suffix: 'm',
              prefixIcon: Icons.show_chart,
            ),

            const SizedBox(height: 24),

            // Botón calcular
            PrimaryButton(
              text: 'Calcular',
              onPressed: _calcularFlecha1Vano,
              icon: Icons.calculate,
            ),

            const SizedBox(height: 16),

            // Botón limpiar
            SecondaryButton(
              text: 'Vaciar',
              onPressed: _limpiarCampos,
              icon: Icons.clear,
            ),

            const SizedBox(height: 24),

            // Resultado con animación
            if (_resultado.isNotEmpty)
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
                  title: 'Ángulo para flechar',
                  value: _resultado,
                  icon: Icons.architecture,
                ),
              ),

            // Mensaje de error
            if (_msgError.isNotEmpty)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ErrorCard(message: _msgError),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ========================================================================
  // LÓGICA DE CÁLCULO
  // ========================================================================

  /// Calcula el ángulo necesario para flechar un vano.
  ///
  /// El algoritmo:
  /// 1. Valida que todos los campos tengan valores
  /// 2. Calcula el parámetro S usando la fórmula: S = ((√F × 2) - √H)² / V
  /// 3. Calcula el ángulo usando arctan
  /// 4. Si el ángulo es negativo, aplica corrección
  void _calcularFlecha1Vano() {
    setState(() {
      _resultado = '';
      _msgError = '';
    });

    // Validación de campos vacíos
    if (_distController.text.isEmpty ||
        _angGrapaController.text.isEmpty ||
        _longVanoController.text.isEmpty ||
        _flechaTeorController.text.isEmpty) {
      setState(() => _msgError = 'Todos los campos son obligatorios.');
      return;
    }

    try {
      final double H = double.parse(_distController.text);
      final double G = double.parse(_angGrapaController.text);
      final double V = double.parse(_longVanoController.text);
      final double F = double.parse(_flechaTeorController.text);

      // Validaciones
      if (H <= 0 || V <= 0 || F <= 0) {
        setState(() => _msgError = 'Los valores deben ser mayores que cero.');
        return;
      }

      // Cálculo del parámetro S
      final double S = _calculoS(F, H, V);

      // Cálculo del ángulo
      double ang = _calculoArcTan(G, S);

      // Si el ángulo es negativo, aplicar corrección
      if (ang < 0.0) {
        ang = _calculoC(S, G);
      }

      setState(() {
        _resultado = '${ang.toStringAsFixed(3)} °';
      });
    } on FormatException {
      setState(
          () => _msgError = 'Por favor, introduzca valores numéricos válidos.');
    } catch (e) {
      setState(() => _msgError = 'Error en el cálculo. Revise los datos.');
    }
  }

  /// Calcula el parámetro S según la fórmula:
  /// S = ((√F × 2) - √H)² / V
  double _calculoS(double F, double H, double V) {
    return pow((sqrt(F) * 2.0) - sqrt(H), 2.0) / V;
  }

  /// Calcula el ángulo mediante arctan.
  /// Convierte de centesimales a radianes y viceversa.
  double _calculoArcTan(double G, double S) {
    final genrad = _operaciones.aradianes(G); // Centesimales → radianes
    final op1 = 1.0 / ((1.0 / tan(genrad)) - S);
    final res = atan(op1);
    return _operaciones.agrados(res); // Radianes → centesimales
  }

  /// Calcula el ángulo con corrección cuando el resultado inicial es negativo.
  double _calculoC(double S, double G) {
    final genrad = _operaciones.aradianes(G - 100.0);
    final op1 = S + tan(genrad);
    final res = atan(op1);
    return 100.0 + _operaciones.agrados(res);
  }

  /// Limpia todos los campos de entrada y resultados.
  void _limpiarCampos() {
    _distController.clear();
    _angGrapaController.clear();
    _longVanoController.clear();
    _flechaTeorController.clear();

    setState(() {
      _resultado = '';
      _msgError = '';
    });
  }

  // ========================================================================
  // DIÁLOGOS
  // ========================================================================

  /// Muestra el diálogo de ayuda con información sobre el cálculo.
  void _mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Flechar 1 Vano'),
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
                    'Assets/Images/flechar1vano.jpg',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Esta herramienta calcula el ángulo necesario para flechar correctamente un vano.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('• Distancia del taquímetro (en metros)'),
              const Text('• Ángulo en grapa (en grados centesimales)'),
              const Text('• Longitud del vano (en metros)'),
              const Text('• Flecha teórica (en metros)'),

              const SizedBox(height: 12),

              const Text(
                'El cálculo reproduce exactamente la lógica de la aplicación Android original.',
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
              'Assets/Images/flechar1vano.jpg',
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
