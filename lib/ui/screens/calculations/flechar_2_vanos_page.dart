import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import 'package:elecnorappflechas/ui/widgets/widgets.dart';

/// Pantalla para calcular el ángulo necesario para flechar el segundo vano.
///
/// Utiliza los ángulos en las grapas 1 y 2, las longitudes de ambos vanos
/// y la flecha teórica del vano 2 para determinar el ángulo correcto de flechado.
///
/// **Proceso:**
/// 1. Calcula el parámetro E usando una fórmula compleja
/// 2. Determina el parámetro X
/// 3. Calcula el ángulo P
/// 4. Ajusta el resultado según sea necesario
class Flechar2VanosPage extends StatefulWidget {
  const Flechar2VanosPage({super.key});

  @override
  State<Flechar2VanosPage> createState() => _Flechar2VanosPageState();
}

class _Flechar2VanosPageState extends State<Flechar2VanosPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _txtAngGrapa1 = TextEditingController();
  final TextEditingController _txtAngGrapa2 = TextEditingController();
  final TextEditingController _txtLongVano1 = TextEditingController();
  final TextEditingController _txtLongVano2 = TextEditingController();
  final TextEditingController _txtFlechaTeor2 = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _resultado = '';
  String _error = '';
  final _operaciones = const OperacionesMatematicas();

  @override
  void dispose() {
    _txtAngGrapa1.dispose();
    _txtAngGrapa2.dispose();
    _txtLongVano1.dispose();
    _txtLongVano2.dispose();
    _txtFlechaTeor2.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flechar 2 Vanos'),
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
              title: 'Flechar 2 Vanos',
              content:
                  'Calcula el ángulo necesario para flechar correctamente el segundo vano.',
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
              label: 'Ángulo grapa 1',
              controller: _txtAngGrapa1,
              suffix: '°',
              prefixIcon: Icons.architecture,
            ),
            NumericTextField(
              label: 'Ángulo grapa 2',
              controller: _txtAngGrapa2,
              suffix: '°',
              prefixIcon: Icons.architecture,
            ),
            NumericTextField(
              label: 'Longitud vano 1',
              controller: _txtLongVano1,
              suffix: 'm',
              prefixIcon: Icons.linear_scale,
            ),
            NumericTextField(
              label: 'Longitud vano 2',
              controller: _txtLongVano2,
              suffix: 'm',
              prefixIcon: Icons.linear_scale,
            ),
            NumericTextField(
              label: 'Flecha teórica vano 2',
              controller: _txtFlechaTeor2,
              suffix: 'm',
              prefixIcon: Icons.show_chart,
            ),

            const SizedBox(height: 24),

            // Botón calcular
            PrimaryButton(
              text: 'Comprobar',
              onPressed: _calcularFlechar2Vanos,
              icon: Icons.calculate,
            ),

            const SizedBox(height: 16),

            // Botón limpiar
            SecondaryButton(
              text: 'Vaciar',
              onPressed: _limpiar,
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
                  title: 'Ángulo para flechar vano 2',
                  value: _resultado,
                  icon: Icons.architecture,
                ),
              ),

            // Mensaje de error
            if (_error.isNotEmpty)
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
                  child: ErrorCard(message: _error),
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

  /// Calcula el ángulo necesario para flechar el segundo vano.
  ///
  /// Utiliza fórmulas complejas basadas en las tangentes de los ángulos
  /// y las proporciones entre las longitudes de los vanos.
  void _calcularFlechar2Vanos() {
    setState(() {
      _error = '';
      _resultado = '';
    });

    try {
      final A = double.parse(_txtAngGrapa1.text);
      final B = double.parse(_txtAngGrapa2.text);
      final C = double.parse(_txtLongVano1.text);
      final J = double.parse(_txtLongVano2.text);
      final F = double.parse(_txtFlechaTeor2.text);

      // Validaciones
      if (C <= 0 || J <= 0 || F <= 0) {
        setState(() =>
            _error = 'Las longitudes y flecha deben ser mayores que cero.');
        return;
      }

      final D = J + C;

      // Cálculo de los parámetros intermedios
      final E = _calcularE(F, D, C, B, A);
      final X = _calcularX(F, E, D, C);
      final P = _calcularP(A, X, C);

      // Ajuste del ángulo: si es negativo, sumar 200°
      final double angulo = P > 0.0 ? P : 200.0 + P;

      setState(() {
        _resultado = '${angulo.toStringAsFixed(3)} °';
      });
    } on FormatException {
      setState(() {
        _error = 'Por favor, introduzca valores numéricos válidos.';
      });
    } catch (e) {
      setState(() {
        _error = 'Error de cálculo. Verifique los valores introducidos.';
      });
    }
  }

  /// Calcula el parámetro E según la fórmula compleja.
  double _calcularE(double F, double D, double C, double B, double A) {
    final benrad = _operaciones.aradianes(B);
    final aenrad = _operaciones.aradianes(A);
    final opTan = (1.0 / tan(benrad)) - (1.0 / tan(aenrad));
    final prim = 4.0 * ((D / C) - 1.0);
    final seg = (D * opTan) - (4.0 * F);
    return sqrt((16.0 * F) - (prim * seg));
  }

  /// Calcula el parámetro X.
  double _calcularX(double F, double E, double D, double C) {
    return ((-4.0 * sqrt(F)) + E) / (2.0 * ((D / C) - 1.0));
  }

  /// Calcula el ángulo P final.
  double _calcularP(double A, double X, double C) {
    final aenrad = _operaciones.aradianes(A);
    final res1 = pow((1.0 / tan(aenrad)) - (pow(X, 2.0) / C), -1.0);
    return _operaciones.agrados(atan(res1));
  }

  /// Limpia todos los campos de entrada y resultados.
  void _limpiar() {
    _txtAngGrapa1.clear();
    _txtAngGrapa2.clear();
    _txtLongVano1.clear();
    _txtLongVano2.clear();
    _txtFlechaTeor2.clear();
    setState(() {
      _resultado = '';
      _error = '';
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
        title: const Text('Ayuda - Flechar 2 Vanos'),
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
                'Esta herramienta calcula el ángulo necesario para flechar correctamente el segundo vano.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('• Ángulos en grapas 1 y 2 (en grados centesimales)'),
              const Text('• Longitudes de vanos 1 y 2 (en metros)'),
              const Text('• Flecha teórica del vano 2 (en metros)'),

              const SizedBox(height: 12),

              const Text(
                'El cálculo utiliza fórmulas complejas para garantizar el flechado preciso del segundo vano.',
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
