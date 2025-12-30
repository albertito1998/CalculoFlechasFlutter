import 'package:flutter/material.dart';
import 'package:elecnorappflechas/core/constants/app_constants.dart';
import 'package:elecnorappflechas/ui/widgets/widgets.dart';

/// Pantalla para calcular las tolerancias de flecha según la normativa.
///
/// Las tolerancias dependen de la longitud del vano según las normas:
/// - Vanos < 200 m: tolerancia fija de 5 cm
/// - Vanos entre 200-500 m: tolerancia calculada según fórmula (0.05 × L - 5) cm
/// - Vanos > 500 m: tolerancia fija de 20 cm
///
/// **Normativa aplicable:**
/// Basado en estándares de TenneT y otros operadores de red en Alemania.
class ToleranciasPage extends StatefulWidget {
  const ToleranciasPage({super.key});

  @override
  State<ToleranciasPage> createState() => _ToleranciasPageState();
}

class _ToleranciasPageState extends State<ToleranciasPage> {
  // ========================================================================
  // CONTROLADORES DE TEXTO
  // ========================================================================

  final TextEditingController _longitudController = TextEditingController();

  // ========================================================================
  // VARIABLES DE ESTADO
  // ========================================================================

  String _resultado = '0 cm';

  @override
  void dispose() {
    _longitudController.dispose();
    super.dispose();
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tolerancias de Flecha'),
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
              title: 'Tolerancias de Flecha',
              content:
                  'Calcula la tolerancia permitida según la longitud del vano y la normativa aplicable.',
              icon: Icons.rule,
            ),
            const SizedBox(height: 24),

            // Campo de entrada
            const Text(
              'Longitud del vano',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            NumericTextField(
              label: 'Longitud del vano',
              controller: _longitudController,
              suffix: 'm',
              prefixIcon: Icons.straighten,
            ),

            const SizedBox(height: 24),

            // Botón calcular
            PrimaryButton(
              text: 'Calcular',
              onPressed: _calcularTolerancia,
              icon: Icons.calculate,
            ),

            const SizedBox(height: 32),

            // Tabla normativa
            const Text(
              'Normativa de Tolerancias',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => _mostrarImagenAmpliada(
                context,
                'Assets/Images/tennettolerancias.jpg',
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'Assets/Images/tennettolerancias.jpg',
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Resultado con animación
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
                title: 'Tolerancia Calculada',
                value: _resultado,
                icon: Icons.check_circle,
              ),
            ),

            const SizedBox(height: 35),

            // Logos de clientes
            const Text(
              'Clientes en Alemania:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('Assets/Images/tennet.png', width: 60),
                Image.asset('Assets/Images/transnetbw.png', width: 60),
                Image.asset('Assets/Images/hertz50.png', width: 60),
                Image.asset('Assets/Images/amprion.png', width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================================
  // LÓGICA DE CÁLCULO
  // ========================================================================

  /// Calcula la tolerancia de flecha según la normativa.
  ///
  /// Reglas:
  /// - L < 200 m → 5 cm
  /// - 200 m ≤ L ≤ 500 m → (0.05 × L - 5) cm
  /// - L > 500 m → 20 cm
  void _calcularTolerancia() {
    final text = _longitudController.text.trim();

    if (text.isEmpty) {
      setState(() => _resultado = 'Ingrese un valor válido');
      return;
    }

    final double? L = double.tryParse(text);
    if (L == null || L <= 0) {
      setState(() => _resultado = 'Valor incorrecto');
      return;
    }

    double tolerancia;

    if (L < 200) {
      tolerancia = 5;
    } else if (L > 500) {
      tolerancia = 20;
    } else {
      // Fórmula: (0.05 × L - 5) redondeada a 1 decimal
      tolerancia = ((0.05 * L - 5) * 10).round() / 10.0;
    }

    setState(() => _resultado = '$tolerancia cm');
  }

  // ========================================================================
  // DIÁLOGOS
  // ========================================================================

  /// Muestra el diálogo de ayuda con información sobre las tolerancias.
  void _mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Tolerancias de Flecha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen ilustrativa
              GestureDetector(
                onTap: () => _mostrarImagenAmpliada(
                  context,
                  'Assets/Images/tennettolerancias.jpg',
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'Assets/Images/tennettolerancias.jpg',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'La tolerancia de flecha depende de la longitud del vano según la normativa.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text(
                'Reglas aplicadas:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('• < 200 m → 5 cm'),
              const Text('• 200–500 m → fórmula 0.05 × L − 5'),
              const Text('• > 500 m → 20 cm'),

              const SizedBox(height: 12),

              const Text(
                'Donde L es la longitud del vano en metros.',
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

  /// Muestra una imagen en pantalla completa con zoom.
  void _mostrarImagenAmpliada(BuildContext context, String ruta) {
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
              ruta,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de confirmación para salir al menú.
  void _mostrarLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Volver al menú'),
        content: const Text('¿Desea volver al menú principal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pushReplacementNamed(context, AppRoutes.menu);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}
