import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/theme.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';

/// Pantalla para comprobar la flecha real de un vano.
///
/// Utiliza la distancia del taquímetro, los ángulos en grapa y cable,
/// la longitud del vano y la flecha teórica para determinar si el cable
/// está correctamente tensado o si está alto o bajo respecto al diseño.
///
/// **Resultado:**
/// - Flecha real calculada
/// - Diferencia respecto a la flecha teórica (cable alto/bajo)
class ComprobarFlecha1VanoPage extends StatefulWidget {
  const ComprobarFlecha1VanoPage({super.key});

  @override
  State<ComprobarFlecha1VanoPage> createState() =>
      _ComprobarFlecha1VanoPageState();
}

class _ComprobarFlecha1VanoPageState extends State<ComprobarFlecha1VanoPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _txtDistancia = TextEditingController();
  final TextEditingController _txtAngGrapa = TextEditingController();
  final TextEditingController _txtAngCable = TextEditingController();
  final TextEditingController _txtLongVano = TextEditingController();
  final TextEditingController _txtFlechaTeorica = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _flechaRealTxt = '';
  String _cableBajoTxt = '';
  String _errorMessage = '';
  final _operaciones = const OperacionesMatematicas();

  @override
  void dispose() {
    _txtDistancia.dispose();
    _txtAngGrapa.dispose();
    _txtAngCable.dispose();
    _txtLongVano.dispose();
    _txtFlechaTeorica.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprobar Flecha 1 Vano'),
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
            const Text(
              'Introduzca los siguientes datos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campos de entrada
            _buildTextField(
              label: 'Distancia taquímetro (m)',
              controller: _txtDistancia,
            ),
            _buildTextField(
              label: 'Ángulo en grapa (°)',
              controller: _txtAngGrapa,
            ),
            _buildTextField(
              label: 'Ángulo en cable (°)',
              controller: _txtAngCable,
            ),
            _buildTextField(
              label: 'Longitud del vano (m)',
              controller: _txtLongVano,
            ),
            _buildTextField(
              label: 'Flecha teórica (m)',
              controller: _txtFlechaTeorica,
            ),

            const SizedBox(height: 24),

            // Botón calcular
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _calcular,
                child: const Text('Calcular Flecha Real'),
              ),
            ),

            const SizedBox(height: 16),

            // Botón limpiar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _limpiar,
                icon: const Icon(Icons.clear),
                label: const Text('Limpiar'),
              ),
            ),

            const SizedBox(height: 16),

            // Resultado - Flecha Real
            if (_flechaRealTxt.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _flechaRealTxt,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Resultado - Cable Alto/Bajo
            if (_cableBajoTxt.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _cableBajoTxt,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryOrange,
                      ),
                    ),
                  ),
                ),
              ),

            // Mensaje de error
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  /// Construye un campo de texto numérico con estilo consistente.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.straighten),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  // ========================================================================
  // LÓGICA DE CÁLCULO
  // ========================================================================

  /// Calcula la flecha real del vano y determina si el cable está alto o bajo.
  ///
  /// El algoritmo selecciona automáticamente la fórmula correcta según
  /// los valores de los ángulos medidos (centesimales).
  void _calcular() {
    setState(() {
      _errorMessage = '';
      _flechaRealTxt = '';
      _cableBajoTxt = '';
    });

    try {
      final double H = double.parse(_txtDistancia.text);
      final double G = double.parse(_txtAngGrapa.text);
      final double C = double.parse(_txtAngCable.text);
      final double L = double.parse(_txtLongVano.text);
      final double F = double.parse(_txtFlechaTeorica.text);

      // Validaciones
      if (H <= 0 || L <= 0 || F <= 0) {
        setState(
            () => _errorMessage = 'Los valores deben ser mayores que cero.');
        return;
      }

      double resultado;

      // Selección de la fórmula según los ángulos
      if (C >= 100 || G >= 100) {
        if (C > 100 && G > 100) {
          resultado = _flechareal2(G, C, L, H);
        } else {
          resultado = _flechareal3(G, C, L, H);
        }
      } else {
        resultado = _flechareal1(G, C, L, H);
      }

      // Cálculo de la diferencia con la flecha teórica
      final rescable = _calculocable(resultado, F);

      setState(() {
        _flechaRealTxt = 'Flecha Real: ${resultado.toStringAsFixed(3)} m';

        _cableBajoTxt = rescable < 0
            ? 'Cable ALTO: ${rescable.abs().toStringAsFixed(3)} m'
            : 'Cable BAJO: ${rescable.toStringAsFixed(3)} m';
      });
    } on FormatException {
      setState(() =>
          _errorMessage = 'Por favor, introduzca valores numéricos válidos.');
    } catch (e) {
      setState(() => _errorMessage = 'Datos inválidos. Revise los valores.');
    }
  }

  /// Calcula la flecha real cuando ambos ángulos son menores a 100°.
  double _flechareal1(double G, double C, double L, double H) {
    final tg = _operaciones.calculotang1(G, C);
    final raiz = _operaciones.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  /// Calcula la flecha real cuando ambos ángulos son mayores a 100°.
  double _flechareal2(double G, double C, double L, double H) {
    final tg = _operaciones.calculotang2(G, C);
    final raiz = _operaciones.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  /// Calcula la flecha real cuando los ángulos están en rangos diferentes.
  double _flechareal3(double G, double C, double L, double H) {
    final tg = _operaciones.calculotang3(G, C);
    final raiz = _operaciones.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  /// Calcula la diferencia entre la flecha real y la teórica.
  /// Resultado positivo = cable bajo, negativo = cable alto.
  double _calculocable(double res, double F) {
    return res - F;
  }

  /// Limpia todos los campos de entrada y resultados.
  void _limpiar() {
    _txtDistancia.clear();
    _txtAngGrapa.clear();
    _txtAngCable.clear();
    _txtLongVano.clear();
    _txtFlechaTeorica.clear();

    setState(() {
      _flechaRealTxt = '';
      _cableBajoTxt = '';
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
        title: const Text('Ayuda - Comprobar Flecha 1 Vano'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta herramienta calcula la flecha real del vano y la compara con la flecha teórica.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('• Distancia del taquímetro (m)'),
              Text('• Ángulo en grapa (° centesimales)'),
              Text('• Ángulo en cable (° centesimales)'),
              Text('• Longitud del vano (m)'),
              Text('• Flecha teórica (m)'),
              SizedBox(height: 12),
              Text(
                'El resultado indica si el cable está correctamente tensado o si presenta desviaciones (alto o bajo).',
                textAlign: TextAlign.justify,
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
