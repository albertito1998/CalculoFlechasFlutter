/// Pantalla del menú principal de la aplicación
///
/// Muestra todas las herramientas disponibles para el cálculo y
/// comprobación de flechas en líneas eléctricas.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importaciones de configuración
import '../../../core/constants/app_constants.dart';

// Importaciones de UI
import '../../widgets/widgets.dart';

// Importaciones de pantallas (a través de exports)
import '../calculations/calcular_altura_page.dart';
import '../calculations/calcular_longitud_page.dart';
import '../calculations/comprobar_flecha_1_vano_page.dart';
import '../calculations/comprobar_flecha_2_vanos_page.dart';
import '../calculations/flechar_1_vano_page.dart';
import '../calculations/flechar_2_vanos_page.dart';
import '../calculations/flecha_estacion_libre_page.dart';
import '../calculations/tolerancias_page.dart';

/// Modelo para representar una opción del menú
class MenuItem {
  /// Texto que se muestra en el botón
  final String label;

  /// Icono que se muestra en el botón
  final IconData icon;

  /// Tipo del widget de destino al presionar el botón
  final Type destinationType;

  /// Constructor
  const MenuItem({
    required this.label,
    required this.icon,
    required this.destinationType,
  });

  /// Crea una instancia del widget de destino
  Widget createDestination() {
    // Map de tipos a constructores
    final constructors = <Type, Widget Function()>{
      Flechar1VanoPage: () => const Flechar1VanoPage(),
      Flechar2VanosPage: () => const Flechar2VanosPage(),
      CalcularAlturaPage: () => const CalcularAlturaPage(),
      CalcularLongitudPage: () => const CalcularLongitudPage(),
      ComprobarFlecha1VanoPage: () => const ComprobarFlecha1VanoPage(),
      ComprobarFlecha2VanosPage: () => const ComprobarFlecha2VanosPage(),
      FlechaEstacionLibrePage: () => const FlechaEstacionLibrePage(),
      ToleranciasPage: () => const ToleranciasPage(),
    };

    final constructor = constructors[destinationType];
    if (constructor == null) {
      throw Exception('No constructor found for $destinationType');
    }
    return constructor();
  }
}

/// Página del menú principal
///
/// Proporciona acceso a todas las funcionalidades de la aplicación
/// relacionadas con el cálculo y comprobación de flechas.
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // ==================== Configuración del menú ====================

  /// Lista de opciones del menú
  late final List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = _buildMenuItems();
  }

  /// Construye la lista de elementos del menú
  List<MenuItem> _buildMenuItems() {
    return const [
      MenuItem(
        label: 'Flechar 1 vano',
        icon: Icons.straighten,
        destinationType: Flechar1VanoPage,
      ),
      MenuItem(
        label: 'Flechar 2 vanos',
        icon: Icons.straighten,
        destinationType: Flechar2VanosPage,
      ),
      MenuItem(
        label: 'Medir altura',
        icon: Icons.height,
        destinationType: CalcularAlturaPage,
      ),
      MenuItem(
        label: 'Medir longitud',
        icon: Icons.straighten,
        destinationType: CalcularLongitudPage,
      ),
      MenuItem(
        label: 'Comprobar flecha 1 vano',
        icon: Icons.check_circle_outline,
        destinationType: ComprobarFlecha1VanoPage,
      ),
      MenuItem(
        label: 'Comprobar flecha 2 vanos',
        icon: Icons.check_circle_outline,
        destinationType: ComprobarFlecha2VanosPage,
      ),
      MenuItem(
        label: 'Flechar con estación total libre',
        icon: Icons.location_searching,
        destinationType: FlechaEstacionLibrePage,
      ),
      MenuItem(
        label: 'Tolerancias Alemania',
        icon: Icons.table_chart,
        destinationType: ToleranciasPage,
      ),
    ];
  }

  // ==================== Métodos de negocio ====================

  /// Muestra el diálogo de confirmación para cerrar sesión
  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppMessages.logoutTitle),
        content: const Text(AppMessages.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppMessages.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppMessages.accept),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      _performLogout();
    }
  }

  /// Realiza el cierre de sesión
  void _performLogout() {
    // Navega al login
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);

    // Muestra mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppMessages.logoutSuccess),
        duration: Duration(
          seconds: AppConstants.snackBarDurationSeconds,
        ),
      ),
    );
  }

  /// Maneja el evento de botón atrás (salir de la app)
  Future<void> _onPopInvokedWithResult(
    bool didPop,
    Object? result,
  ) async {
    if (!didPop) {
      final shouldExit = await _showExitDialog();

      if (shouldExit && mounted) {
        SystemNavigator.pop();
      }
    }
  }

  /// Muestra el diálogo de confirmación para salir de la app
  Future<bool> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppMessages.exitTitle),
        content: const Text(AppMessages.exitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppMessages.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppMessages.yes),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  /// Navega a una pantalla específica
  void _navigateToScreen(MenuItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => item.createDestination(),
      ),
    );
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  /// Construye el AppBar con el título y botón de cerrar sesión
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        AppConstants.companyName,
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: AppMessages.logoutTitle,
          onPressed: _showLogoutDialog,
        ),
      ],
    );
  }

  /// Construye el cuerpo de la pantalla con el fondo y el grid de opciones
  Widget _buildBody() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header con título y descripción
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Herramientas de Cálculo',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona la herramienta que necesitas',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Grid de botones
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _menuItems[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: MenuButton(
                        label: item.label,
                        icon: item.icon,
                        onPressed: () => _navigateToScreen(item),
                      ),
                    );
                  },
                  childCount: _menuItems.length,
                ),
              ),
            ),

            // Botón de cerrar sesión al final
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SecondaryButton(
                  text: 'Cerrar Sesión',
                  icon: Icons.logout_rounded,
                  onPressed: _showLogoutDialog,
                  fullWidth: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calcula el número de columnas según el ancho de pantalla
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  /// Construye la decoración del fondo con la imagen corporativa
  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(AppConstants.backgroundImagePath),
        fit: BoxFit.cover,
        opacity: 0.3, // Reduce la opacidad para mejor legibilidad
      ),
    );
  }
}
