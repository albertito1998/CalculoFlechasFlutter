/// Mocks de Firebase para testing
///
/// Proporciona implementaciones mock de Firebase Auth y Firestore
/// para uso en tests sin necesidad de conexión real.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Mock de FirebaseAuth para testing
class MockFirebaseAuth {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  
  Stream<User?> authStateChanges() {
    return Stream.value(_currentUser);
  }
  
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!email.endsWith('@elecnor.com')) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'El correo debe ser de dominio @elecnor.com',
      );
    }
    
    _currentUser = MockUser(email: email);
    return MockUserCredential(_currentUser!);
  }
  
  Future<void> signOut() async {
    _currentUser = null;
  }
}

/// Mock de User
class MockUser implements User {
  MockUser({required this.email});
  
  @override
  final String? email;
  
  @override
  String get uid => 'mock-uid-123';
  
  @override
  String? get displayName => email?.split('@').first;
  
  @override
  String? get photoURL => null;
  
  @override
  bool get emailVerified => true;
  
  @override
  bool get isAnonymous => false;
  
  @override
  UserMetadata get metadata => MockUserMetadata();
  
  @override
  List<UserInfo> get providerData => [];
  
  @override
  String? get phoneNumber => null;
  
  @override
  String? get refreshToken => null;
  
  @override
  String? get tenantId => null;
  
  @override
  Future<void> delete() async {}
  
  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock-token';
  
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    throw UnimplementedError();
  }
  
  @override
  Future<void> reload() async {}
  
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}
  
  @override
  Future<User> linkWithCredential(AuthCredential credential) async {
    throw UnimplementedError();
  }
  
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    throw UnimplementedError();
  }
  
  @override
  Future<void> unlink(String providerId) async {}
  
  @override
  Future<void> updateEmail(String newEmail) async {}
  
  @override
  Future<void> updatePassword(String newPassword) async {}
  
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}
  
  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}
  
  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) async {}
  
  @override
  MultiFactor get multiFactor => throw UnimplementedError();
  
  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }
  
  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }
}

/// Mock de UserCredential
class MockUserCredential implements UserCredential {
  MockUserCredential(this.user);
  
  @override
  final User user;
  
  @override
  AuthCredential? get credential => null;
  
  @override
  AdditionalUserInfo? get additionalUserInfo => null;
}

/// Mock de UserMetadata
class MockUserMetadata implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now();
  
  @override
  DateTime? get lastSignInTime => DateTime.now();
}

/// Mock de Firestore para testing
class MockFirestore {
  final Map<String, Map<String, dynamic>> _data = {};
  
  MockCollectionReference collection(String path) {
    return MockCollectionReference(path, this);
  }
  
  void setMockData(String path, String docId, Map<String, dynamic> data) {
    final key = '$path/$docId';
    _data[key] = data;
  }
  
  Map<String, dynamic>? getMockData(String path, String docId) {
    final key = '$path/$docId';
    return _data[key];
  }
}

/// Mock de CollectionReference
class MockCollectionReference {
  final String path;
  final MockFirestore firestore;
  
  MockCollectionReference(this.path, this.firestore);
  
  MockDocumentReference doc([String? documentPath]) {
    return MockDocumentReference(
      '$path/${documentPath ?? 'mock-doc'}',
      firestore,
    );
  }
  
  Future<void> add(Map<String, dynamic> data) async {
    firestore.setMockData(path, 'mock-doc-${DateTime.now().millisecondsSinceEpoch}', data);
  }
}

/// Mock de DocumentReference
class MockDocumentReference {
  final String path;
  final MockFirestore firestore;
  
  MockDocumentReference(this.path, this.firestore);
  
  Future<void> set(Map<String, dynamic> data) async {
    final parts = path.split('/');
    final docId = parts.last;
    final collectionPath = parts.sublist(0, parts.length - 1).join('/');
    firestore.setMockData(collectionPath, docId, data);
  }
  
  Future<void> update(Map<String, dynamic> data) async {
    final parts = path.split('/');
    final docId = parts.last;
    final collectionPath = parts.sublist(0, parts.length - 1).join('/');
    final existing = firestore.getMockData(collectionPath, docId) ?? {};
    existing.addAll(data);
    firestore.setMockData(collectionPath, docId, existing);
  }
  
  Future<void> delete() async {
    // Mock implementation
  }
  
  Future<MockDocumentSnapshot> get() async {
    final parts = path.split('/');
    final docId = parts.last;
    final collectionPath = parts.sublist(0, parts.length - 1).join('/');
    final data = firestore.getMockData(collectionPath, docId);
    return MockDocumentSnapshot(data, exists: data != null);
  }
}

/// Mock de DocumentSnapshot
class MockDocumentSnapshot {
  final Map<String, dynamic>? data;
  final bool exists;
  
  MockDocumentSnapshot(this.data, {required this.exists});
}
