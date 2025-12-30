/// Servicio de autenticación de Firebase
/// 
/// Proporciona una abstracción sobre Firebase Authentication para
/// gestionar el inicio de sesión, registro y cierre de sesión de usuarios.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Interfaz base para servicios de autenticación
/// 
/// Define el contrato que debe cumplir cualquier implementación
/// de autenticación en la aplicación.
abstract class BaseAuth {
  /// Stream que emite cambios en el estado de autenticación del usuario
  Stream<User?> get onAuthStateChanged;

  /// Inicia sesión con email y contraseña
  /// 
  /// Retorna el UID del usuario autenticado.
  /// Lanza una excepción si la autenticación falla.
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Crea una nueva cuenta de usuario con email y contraseña
  /// 
  /// Retorna el UID del usuario creado.
  /// Lanza una excepción si la creación falla.
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  /// Envía un email de recuperación de contraseña
  /// 
  /// Lanza una excepción si el envío falla.
  Future<void> sendPasswordResetEmail(String email);

  /// Obtiene el UID del usuario actualmente autenticado
  /// 
  /// Retorna null si no hay usuario autenticado.
  Future<String?> currentUser();

  /// Cierra la sesión del usuario actual
  Future<void> signOut();

  /// Inicia sesión con Google
  /// 
  /// Retorna el UID del usuario autenticado.
  /// Lanza una excepción si la autenticación falla.
  Future<String> signInWithGoogle();
}

/// Implementación del servicio de autenticación usando Firebase
/// 
/// Esta clase implementa [BaseAuth] y proporciona todos los métodos
/// de autenticación usando Firebase Authentication.
class Auth implements BaseAuth {
  /// Instancia de Firebase Authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Instancia de Google Sign In para autenticación con Google
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<User?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges();

  @override
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;

      if (user != null) {
        return user.uid;
      } else {
        throw AuthException(
          'El usuario es nulo después de la creación.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Error inesperado durante la creación: $e');
    }
  }

  @override
  Future<String?> currentUser() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential authResult =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;

      if (user != null) {
        return user.uid;
      } else {
        throw AuthException(
          'La autenticación no se completó correctamente.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Error inesperado durante la autenticación: $e');
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      // Inicia el flujo de autenticación con Google
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw AuthException('El inicio de sesión con Google fue cancelado.');
      }

      // Obtiene las credenciales de autenticación
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Crea la credencial de Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Inicia sesión con Firebase usando la credencial de Google
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = authResult.user;

      if (user != null) {
        return user.uid;
      } else {
        throw AuthException(
          'El usuario es nulo después del inicio de sesión con Google.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(
        'Error durante el inicio de sesión con Google: $e',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Cierra sesión de Google si está activo
      await _googleSignIn.signOut();
      // Cierra sesión de Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Configura el idioma para el email
      _firebaseAuth.setLanguageCode('es');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(
        'Error al enviar el email de recuperación: $e',
      );
    }
  }

  /// Maneja las excepciones de Firebase Auth y las convierte en mensajes legibles
  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No existe una cuenta con este correo electrónico.';
        break;
      case 'wrong-password':
        message = 'Contraseña incorrecta.';
        break;
      case 'email-already-in-use':
        message = 'Ya existe una cuenta con este correo electrónico.';
        break;
      case 'invalid-email':
        message = 'El correo electrónico no es válido.';
        break;
      case 'weak-password':
        message = 'La contraseña es demasiado débil.';
        break;
      case 'user-disabled':
        message = 'Esta cuenta ha sido deshabilitada.';
        break;
      case 'too-many-requests':
        message = 'Demasiados intentos. Por favor, intenta más tarde.';
        break;
      case 'operation-not-allowed':
        message = 'Esta operación no está permitida.';
        break;
      default:
        message = 'Error de autenticación: ${e.message ?? e.code}';
    }

    return AuthException(message);
  }
}

/// Excepción personalizada para errores de autenticación
/// 
/// Proporciona mensajes de error más legibles para el usuario.
class AuthException implements Exception {
  /// Mensaje de error
  final String message;

  /// Constructor
  AuthException(this.message);

  @override
  String toString() => message;
}
