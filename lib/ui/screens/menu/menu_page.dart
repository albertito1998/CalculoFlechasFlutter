/// Pantalla del menú principal de la aplicación
/// 
/// Muestra todas las herramientas disponibles para el cálculo y
/// comprobación de flechas en líneas eléctricas.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importaciones de configuración
import '../../../core/constants/app_constants.dart';

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

  /// Construye el cuerpo de la pantalla con el fondo y la lista de opciones
  Widget _buildBody() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: SafeArea(
        child: Center(
          child: _buildMenuList(),
        ),
      ),
    );
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

  /// Construye la lista scrolleable de opciones del menú
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      child: ListView(
        shrinkWrap: true,
        children: [
          // Botones de las opciones del menú
          ..._menuItems.map(
            (item) => _MenuButton(
              label: item.label,
              icon: item.icon,
              onPressed: () => _navigateToScreen(item),
            ),
          ),

          // Espacio entre las opciones y el botón de salir
          const SizedBox(height: AppConstants.standardPadding),

          // Botón de cerrar sesión
          _MenuButton(
            label: 'Salir',
            icon: Icons.exit_to_app,
            onPressed: _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

/// Widget personalizado para los botones del menú
/// 
/// Proporciona un estilo consistente para todos los botones del menú
/// con soporte para iconos y diseño responsivo.
class _MenuButton extends StatelessWidget {
  /// Texto del botón
  final String label;

  /// Icono del botón
  final IconData icon;

  /// Callback cuando se presiona el botón
  final VoidCallback onPressed;

  /// Indica si es una acción destructiva (como salir o eliminar)
  final bool isDestructive;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth < AppConstants.largeScreenBreakpoint
        ? screenWidth * 0.85
        : AppConstants.maxFormWidth;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppConstants.smallPadding,
      ),
      width: buttonWidth,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.standardPadding,
          ),
          backgroundColor: isDestructive
              ? Colors.red.shade600
              : Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
