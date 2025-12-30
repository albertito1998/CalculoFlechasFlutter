import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/ui/theme/app_theme.dart';
import 'package:elecnorappflechas/utils/operaciones_matematicas.dart';
import 'package:elecnorappflechas/ui/widgets/widgets.dart';

/// Pantalla para comprobar la flecha real en dos vanos.
///
/// Utiliza los ángulos en las grapas y en el cable del vano 2,
/// las longitudes de ambos vanos y la flecha teórica del vano 2
/// para determinar si el cable está correctamente tensado.
///
/// **Resultado:**
/// - Flecha real calculada en el vano 2
/// - Diferencia respecto a la flecha teórica (cable alto/bajo)
class ComprobarFlecha2VanosPage extends StatefulWidget {
  const ComprobarFlecha2VanosPage({super.key});

  @override
  State<ComprobarFlecha2VanosPage> createState() =>
      _ComprobarFlecha2VanosPageState();
}

class _ComprobarFlecha2VanosPageState extends State<ComprobarFlecha2VanosPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _txtAngGrapa1 = TextEditingController();
  final TextEditingController _txtAngGrapa2 = TextEditingController();
  final TextEditingController _txtAngCableVano2 = TextEditingController();
  final TextEditingController _txtLongVano1 = TextEditingController();
  final TextEditingController _txtLongVano2 = TextEditingController();
  final TextEditingController _txtFlechaVano2 = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _result = '';
  String _cableBajo = '';
  String _error = '';
  final _operaciones = const OperacionesMatematicas();

  @override
  void dispose() {
    _txtAngGrapa1.dispose();
    _txtAngGrapa2.dispose();
    _txtAngCableVano2.dispose();
    _txtLongVano1.dispose();
    _txtLongVano2.dispose();
    _txtFlechaVano2.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprobar Flecha 2 Vanos'),
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
              title: 'Comprobar Flecha en 2 Vanos',
              content:
                  'Determina la flecha real en el vano 2 y verifica si el cable está correctamente tensado.',
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 24),
            const Text(
              'Parámetros de entrada',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campos de entrada
            NumericTextField(
              label: 'Ángulo en grapa 1',
              controller: _txtAngGrapa1,
              suffix: '°',
              prefixIcon: Icons.architecture,
            ),
            NumericTextField(
              label: 'Ángulo en grapa 2',
              controller: _txtAngGrapa2,
              suffix: '°',
              prefixIcon: Icons.architecture,
            ),
            NumericTextField(
              label: 'Ángulo en cable del vano 2',
              controller: _txtAngCableVano2,
              suffix: '°',
              prefixIcon: Icons.cable,
            ),
            NumericTextField(
              label: 'Longitud del vano 1',
              controller: _txtLongVano1,
              suffix: 'm',
              prefixIcon: Icons.linear_scale,
            ),
            NumericTextField(
              label: 'Longitud del vano 2',
              controller: _txtLongVano2,
              suffix: 'm',
              prefixIcon: Icons.linear_scale,
            ),
            NumericTextField(
              label: 'Flecha teórica del vano 2',
              controller: _txtFlechaVano2,
              suffix: 'm',
              prefixIcon: Icons.show_chart,
            ),

            const SizedBox(height: 24),

            // Botón calcular
            PrimaryButton(
              text: 'Calcular',
              onPressed: _calcular,
              icon: Icons.calculate,
            ),

            const SizedBox(height: 16),

            // Botón limpiar
            SecondaryButton(
              text: 'Limpiar',
              onPressed: _limpiar,
              icon: Icons.clear,
            ),

            const SizedBox(height: 24),

            // Resultado - Flecha Real
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
                  title: 'Flecha Real',
                  value: '$_result m',
                  icon: Icons.done,
                ),
              ),

            // Resultado - Cable Alto/Bajo
            if (_cableBajo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: ModernCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            _cableBajo.contains('ALTO')
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: AppTheme.secondaryOrange,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _cableBajo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondaryOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

  /// Calcula la flecha real en el vano 2 y determina si el cable está alto o bajo.
  ///
  /// El algoritmo:
  /// 1. Calcula el parámetro H según los ángulos de las grapas
  /// 2. Calcula la longitud total (L)
  /// 3. Determina la flecha real usando la fórmula apropiada
  /// 4. Compara con la flecha teórica
  void _calcular() {
    setState(() {
      _result = '';
      _cableBajo = '';
      _error = '';
    });

    try {
      final E = double.parse(_txtAngGrapa1.text);
      final G = double.parse(_txtAngGrapa2.text);
      final C = double.parse(_txtAngCableVano2.text);
      final J = double.parse(_txtLongVano1.text);
      final K = double.parse(_txtLongVano2.text);
      final F = double.parse(_txtFlechaVano2.text);

      // Validaciones
      if (J <= 0 || K <= 0 || F <= 0) {
        setState(() =>
            _error = 'Las longitudes y flecha deben ser mayores que cero.');
        return;
      }

      // Cálculo del parámetro H según los ángulos
      double H;
      if (E >= 100 || C >= 100) {
        if (E < 100 && C > 100) {
          H = _calculoH2(J, E, C);
        } else {
          H = _calculoH3(J, E, C);
        }
      } else {
        H = _calculoH1(J, E, C);
      }

      // Longitud total
      final double L = J + K;

      // Cálculo de la flecha real
      double resultado;
      double rescable;

      if (C >= 100 || E >= 100) {
        if (C > 100 && G < 100) {
          resultado = _flechareal2(G, C, L, H);
        } else {
          resultado = _flechareal3(G, C, L, H);
        }
      } else {
        resultado = _flechareal1(G, C, L, H);
      }

      // Diferencia con la flecha teórica
      rescable = _calculocable(resultado, F);

      setState(() {
        _result = resultado.toStringAsFixed(3);
        _cableBajo = rescable < 0
            ? 'Cable ALTO: ${rescable.abs().toStringAsFixed(3)} m'
            : 'Cable BAJO: ${rescable.toStringAsFixed(3)} m';
      });
    } on FormatException {
      setState(
          () => _error = 'Por favor, introduzca valores numéricos válidos.');
    } catch (e) {
      setState(() => _error = 'Datos inválidos. Verifique los valores.');
    }
  }

  /// Calcula H usando la tangente tipo 1.
  double _calculoH1(double J, double E, double C) =>
      J * _operaciones.calculotang1(E, C);

  /// Calcula H usando la tangente tipo 2.
  double _calculoH2(double J, double E, double C) =>
      J * _operaciones.calculotang2(E, C);

  /// Calcula H usando la tangente tipo 3.
  double _calculoH3(double J, double E, double C) =>
      J * _operaciones.calculotang3(E, C);

  /// Calcula la flecha real usando la tangente tipo 1.
  double _flechareal1(double G, double C, double L, double H) {
    final tg = _operaciones.calculotang1(G, C);
    final raiz = _operaciones.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  /// Calcula la flecha real usando la tangente tipo 2.
  double _flechareal2(double G, double C, double L, double H) {
    final tg = _operaciones.calculotang2(G, C);
    final raiz = _operaciones.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  /// Calcula la flecha real usando la tangente tipo 3.
  double _flechareal3(double G, double C, double L, double H) {
    final tg = _operaciones.calculotang3(G, C);
    final raiz = _operaciones.calculoraiz(tg, L, H);
    return pow(raiz / 2.0, 2.0).toDouble();
  }

  /// Calcula la diferencia entre la flecha real y la teórica.
  double _calculocable(double res, double F) => res - F;

  /// Limpia todos los campos de entrada y resultados.
  void _limpiar() {
    _txtAngGrapa1.clear();
    _txtAngGrapa2.clear();
    _txtAngCableVano2.clear();
    _txtLongVano1.clear();
    _txtLongVano2.clear();
    _txtFlechaVano2.clear();
    setState(() {
      _result = '';
      _cableBajo = '';
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
        title: const Text('Ayuda - Comprobar Flecha 2 Vanos'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta herramienta calcula la flecha real del vano 2 y la compara con la flecha teórica.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Parámetros necesarios:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('• Ángulos en grapas 1 y 2 (° centesimales)'),
              Text('• Ángulo en cable del vano 2 (° centesimales)'),
              Text('• Longitudes de vanos 1 y 2 (m)'),
              Text('• Flecha teórica del vano 2 (m)'),
              SizedBox(height: 12),
              Text(
                'La fórmula calcula el parámetro H y luego la flecha real, para comprobar si el cable está '
                'por encima o por debajo de lo esperado.',
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
