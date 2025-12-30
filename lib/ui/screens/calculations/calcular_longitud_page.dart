import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import 'package:elecnorappflechas/ui/widgets/widgets.dart';

/// Pantalla para calcular la longitud de un vano a partir de la altura y los ángulos.
///
/// Utiliza los ángulos superior e inferior del cable y la altura del vano
/// para determinar la longitud mediante cálculos trigonométricos.
///
/// **Fórmula aplicada:**
/// ```
/// longitud = altura / tan(ángulo)
/// ```
/// donde el tipo de tangente se selecciona automáticamente según los valores
/// de los ángulos (centesimales).
class CalcularLongitudPage extends StatefulWidget {
  const CalcularLongitudPage({super.key});

  @override
  State<CalcularLongitudPage> createState() => _CalcularLongitudPageState();
}

class _CalcularLongitudPageState extends State<CalcularLongitudPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _txtAlturaController = TextEditingController();
  final TextEditingController _txtAnguloSupController = TextEditingController();
  final TextEditingController _txtAnguloInfController = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _errorMessage = '';
  String _result = '';
  final _operaciones = const OperacionesMatematicas();

  @override
  void dispose() {
    _txtAlturaController.dispose();
    _txtAnguloSupController.dispose();
    _txtAnguloInfController.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular Longitud'),
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
              title: 'Calcular Longitud de Vano',
              content:
                  'Calcula la longitud del vano usando la altura y los ángulos superior e inferior medidos.',
              icon: Icons.straighten,
            ),
            const SizedBox(height: 24),
            const Text(
              'Parámetros de entrada',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campos de entrada
            NumericTextField(
              label: 'Altura',
              controller: _txtAlturaController,
              suffix: 'm',
              prefixIcon: Icons.height,
            ),
            NumericTextField(
              label: 'Ángulo parte superior',
              controller: _txtAnguloSupController,
              suffix: '°',
              prefixIcon: Icons.arrow_upward,
            ),
            NumericTextField(
              label: 'Ángulo parte inferior',
              controller: _txtAnguloInfController,
              suffix: '°',
              prefixIcon: Icons.arrow_downward,
            ),

            const SizedBox(height: 24),

            // Botón calcular
            PrimaryButton(
              text: 'Calcular',
              onPressed: _calcularLongitud,
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
            if (_result.isNotEmpty)
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
                  title: 'Longitud Calculada',
                  value: _result,
                  icon: Icons.straighten,
                ),
              ),

            // Mensaje de error con animación
            if (_errorMessage.isNotEmpty)
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

  /// Calcula la longitud del vano basándose en la altura y los ángulos.
  ///
  /// Selecciona automáticamente el tipo de tangente según los valores:
  /// - calculotang1: ambos ángulos < 100°
  /// - calculotang2: ambos ángulos > 100°
  /// - calculotang3: ángulos en rangos diferentes
  void _calcularLongitud() {
    setState(() {
      _errorMessage = '';
      _result = '';
    });

    try {
      final double altura = double.parse(_txtAlturaController.text);
      final double anguloSuperior = double.parse(_txtAnguloSupController.text);
      final double anguloInferior = double.parse(_txtAnguloInfController.text);

      // Validaciones
      if (altura <= 0) {
        setState(() => _errorMessage = 'La altura debe ser mayor que cero.');
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

      // Validación adicional: evitar división por cero
      if (tangente == 0) {
        setState(() =>
            _errorMessage = 'Error: tangente inválida (división por cero).');
        return;
      }

      final longitud = altura / tangente;

      setState(() {
        _result = '${longitud.toStringAsFixed(3)} m';
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

  /// Limpia todos los campos de entrada y resultados.
  void _limpiarCampos() {
    _txtAlturaController.clear();
    _txtAnguloSupController.clear();
    _txtAnguloInfController.clear();
    setState(() {
      _result = '';
      _errorMessage = '';
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
        title: const Text('Ayuda - Calcular Longitud'),
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
                'Esta herramienta calcula la longitud del vano a partir de la altura y los ángulos medidos.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('• Altura (en metros)'),
              const Text('• Ángulo superior (en grados centesimales)'),
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
