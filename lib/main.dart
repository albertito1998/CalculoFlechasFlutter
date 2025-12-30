/// Punto de entrada principal de la aplicación Elecnor Flechas
///
/// Esta aplicación proporciona herramientas para el cálculo y comprobación
/// de flechas en líneas eléctricas aéreas.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importaciones de configuración
import 'core/constants/app_constants.dart';
import 'firebase_options.dart';

// Importaciones de servicios
import 'services/auth/auth.dart';
import 'services/auth/auth_provider.dart';

// Importaciones de UI
import 'ui/screens/auth/login_page.dart';
import 'ui/screens/menu/menu_page.dart';
import 'ui/theme/app_theme.dart';

/// Función principal de la aplicación
///
/// Inicializa Firebase y configura la aplicación antes de ejecutarla.
/// También establece las orientaciones permitidas (solo portrait).
void main() async {
  // Asegura que los widgets estén inicializados antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones específicas de la plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura las orientaciones permitidas (solo vertical)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ejecuta la aplicación
  runApp(
    AuthProvider(
      auth: Auth(),
      child: const ElecnorApp(),
    ),
  );
}

/// Widget raíz de la aplicación Elecnor
///
/// Configura el tema, las rutas y la página inicial de la aplicación.
/// Mantiene compatibilidad con tests
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ElecnorApp();
  }
}

class ElecnorApp extends StatelessWidget {
  const ElecnorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuración general
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Tema de la aplicación
      theme: AppTheme.lightTheme,

      // Página inicial
      home: const LoginPage(),

      // Rutas nombradas para navegación
      routes: _buildRoutes(),

      // Manejador de rutas desconocidas
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      },
    );
  }

  /// Construye el mapa de rutas de la aplicación
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.login: (_) => const LoginPage(),
      AppRoutes.menu: (_) => const MenuPage(),
      // Las demás rutas se manejan mediante Navigator.push desde el menú
      // para mantener la navegación simple y directa
    };
  }
}
