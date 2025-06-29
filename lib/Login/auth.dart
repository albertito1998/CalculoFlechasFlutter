import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<User?> get onAuthStateChanged;

  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<void> sendPasswordResetEmail(
    String email,
  );

  Future<String?> currentUser();

  Future<void> signOut();

  Future<String> signInWithGoogle();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<User?> get onAuthStateChanged =>
      FirebaseAuth.instance.authStateChanges();

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = authResult.user;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception('El usuario es nulo después de la creación.');
    }
  }

  @override
  Future<String?> currentUser() async {
    final User? user = _firebaseAuth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return null; // Devuelve un valor nulo si el usuario no está autenticado
    }
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
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
        throw Exception('La autenticación no se completó correctamente.');
      }
    } catch (e) {
      throw Exception('Error durante la autenticación: $e');
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final User user = authResult.user!;

      return user.uid;
    } catch (e) {
      throw Exception('Error durante el inicio de sesión con Google: $e');
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    _firebaseAuth.setLanguageCode("es");
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
