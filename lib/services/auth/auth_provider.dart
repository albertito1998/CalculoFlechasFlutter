/// Provider de autenticación para InheritedWidget
/// 
/// Proporciona acceso al servicio de autenticación en todo el árbol de widgets
/// sin necesidad de pasar el objeto explícitamente.
library;

import 'package:flutter/material.dart';
import 'auth.dart';

/// Widget que proporciona el servicio de autenticación a sus descendientes
/// 
/// Utiliza el patrón InheritedWidget para hacer que el servicio de
/// autenticación esté disponible en cualquier parte del árbol de widgets.
/// 
/// Ejemplo de uso:
/// ```dart
/// final auth = AuthProvider.of(context).auth;
/// await auth.signInWithEmailAndPassword(email, password);
/// ```
class AuthProvider extends InheritedWidget {
  /// Servicio de autenticación
  final BaseAuth auth;

  /// Constructor
  const AuthProvider({
    super.key,
    required this.auth,
    required super.child,
  });

  /// Obtiene la instancia del AuthProvider más cercana en el árbol de widgets
  /// 
  /// Lanza una excepción si no se encuentra ningún AuthProvider.
  /// 
  /// [context] El BuildContext desde el cual buscar el provider.
  static AuthProvider of(BuildContext context) {
    final AuthProvider? result =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    
    assert(
      result != null,
      'No AuthProvider found in context. '
      'Ensure that AuthProvider wraps your app.',
    );
    
    return result!;
  }

  /// Método que determina si los widgets dependientes deben reconstruirse
  /// 
  /// Retorna false porque el servicio de auth no cambia durante la vida de la app.
  @override
  bool updateShouldNotify(covariant AuthProvider oldWidget) {
    // Solo notifica si la instancia de auth cambia (raro en la práctica)
    return auth != oldWidget.auth;
  }
}
