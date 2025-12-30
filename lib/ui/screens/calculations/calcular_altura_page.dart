import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import '../../widgets/widgets.dart';

/// Pantalla para calcular la altura de un cable entre dos puntos.
///
/// Utiliza los ángulos superior e inferior del cable y la longitud del vano
/// para determinar la altura proyectada mediante cálculos trigonométricos.
///
/// **Fórmula aplicada:**
/// ```
/// altura = L × tan(ángulo)
/// ```
/// donde el tipo de tangente se selecciona automáticamente según los valores
/// de los ángulos (centesimales).
class CalcularAlturaPage extends StatefulWidget {
  const CalcularAlturaPage({super.key});

  @override
  State<CalcularAlturaPage> createState() => _CalcularAlturaPageState();
}

class _CalcularAlturaPageState extends State<CalcularAlturaPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _txtAngSupController = TextEditingController();
  final TextEditingController _txtLongVanoController = TextEditingController();
  final TextEditingController _txtAngInfController = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _errorMessage = '';
  String _result = '';
  final OperacionesMatematicas _operaciones = const OperacionesMatematicas();

  @override
  void dispose() {
    _txtAngSupController.dispose();
    _txtLongVanoController.dispose();
    _txtAngInfController.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular Altura'),
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
            // Sección de información
            const InfoCard(
              title: '¿Qué calcula esta herramienta?',
              content:
                  'Calcula la altura de un cable entre dos puntos usando los ángulos superior e inferior y la longitud del vano.',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 24),

            // Título de sección
            Text(
              'Datos de entrada',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Campos de entrada modernos
            NumericTextField(
              label: 'Ángulo parte superior',
              controller: _txtAngSupController,
              suffix: '°',
              prefixIcon: Icons.arrow_upward,
            ),
            const SizedBox(height: 16),

            NumericTextField(
              label: 'Longitud del vano',
              controller: _txtLongVanoController,
              suffix: 'm',
              prefixIcon: Icons.straighten,
            ),
            const SizedBox(height: 16),

            NumericTextField(
              label: 'Ángulo parte inferior',
              controller: _txtAngInfController,
              suffix: '°',
              prefixIcon: Icons.arrow_downward,
            ),
            const SizedBox(height: 24),

            // Botón calcular moderno
            PrimaryButton(
              text: 'Calcular Altura',
              icon: Icons.calculate_rounded,
              onPressed: _calcularAltura,
            ),
            const SizedBox(height: 24),

            // Resultado con animación
            if (_result.isNotEmpty)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: ResultCard(
                  title: 'Altura Calculada',
                  value: _result,
                  icon: Icons.height,
                ),
              ),

            // Mensaje de error
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: ErrorCard(message: _errorMessage),
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

  /// Calcula la altura del cable basándose en los ángulos y la longitud del vano.
  ///
  /// Selecciona automáticamente el tipo de tangente según los valores:
  /// - calculotang1: ambos ángulos < 100°
  /// - calculotang2: ambos ángulos > 100°
  /// - calculotang3: ángulos en rangos diferentes
  void _calcularAltura() {
    setState(() {
      _errorMessage = '';
      _result = '';
    });

    try {
      final double anguloSuperior = double.parse(_txtAngSupController.text);
      final double longitudVano = double.parse(_txtLongVanoController.text);
      final double anguloInferior = double.parse(_txtAngInfController.text);

      // Validaciones
      if (longitudVano <= 0) {
        setState(() =>
            _errorMessage = 'La longitud del vano debe ser mayor que cero.');
        return;
      }

      // Selección del tipo de tangente según los ángulos
      double tangente;
      if (anguloInferior < 100.0 && anguloSuperior < 100.0) {
        tangente = _operaciones.calculotang1(anguloSuperior, anguloInferior);
      } else if (anguloInferior > 100.0 && anguloSuperior > 100.0) {
        tangente = _operaciones.calculotang2(anguloSuperior, anguloInferior);
      } else {
        tangente = _operaciones.calculotang3(anguloSuperior, anguloInferior);
      }

      final altura = longitudVano * tangente;

      setState(() {
        _result = '${altura.toStringAsFixed(3)} m';
      });
    } on FormatException {
      setState(() {
        _errorMessage = 'Por favor, introduzca valores numéricos válidos.';
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error en el cálculo. Verifique los datos introducidos.';
      });
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
        title: const Text('Ayuda - Calcular Altura'),
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
                'Esta herramienta calcula la altura proyectada del cable entre dos puntos.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('• Ángulo superior (en grados centesimales)'),
              const Text('• Longitud del vano (en metros)'),
              const Text('• Ángulo inferior (en grados centesimales)'),

              const SizedBox(height: 12),

              const Text(
                'La fórmula selecciona automáticamente el tipo de tangente según los valores angulares para obtener el resultado más preciso.',
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
