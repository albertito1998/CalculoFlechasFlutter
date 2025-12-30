/// Servicio de base de datos Firestore
///
/// Proporciona acceso centralizado a Cloud Firestore para operaciones CRUD
/// (Create, Read, Update, Delete) en la base de datos de la aplicación.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio para interactuar con Cloud Firestore
///
/// Esta clase proporciona métodos para realizar operaciones comunes
/// en la base de datos Firestore de Firebase.
///
/// Ejemplo de uso:
/// ```dart
/// final dbService = DatabaseService();
///
/// // Crear un documento
/// await dbService.createDocument(
///   collection: 'users',
///   documentId: 'user123',
///   data: {'name': 'Juan', 'email': 'juan@example.com'},
/// );
///
/// // Leer un documento
/// final userData = await dbService.getDocument(
///   collection: 'users',
///   documentId: 'user123',
/// );
/// ```
class DatabaseService {
  /// Instancia de Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Constructor
  DatabaseService();

  /// Obtiene la instancia de Firestore (para casos especiales)
  FirebaseFirestore get instance => _db;

  // ==================== Operaciones CRUD ====================

  /// Crea un nuevo documento en una colección
  ///
  /// [collection] Nombre de la colección donde crear el documento
  /// [documentId] ID del documento (opcional, se genera automáticamente si no se proporciona)
  /// [data] Datos del documento como mapa
  ///
  /// Retorna el ID del documento creado
  Future<String> createDocument({
    required String collection,
    String? documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Añade timestamp de creación automáticamente
      final dataWithTimestamp = {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (documentId != null) {
        // Crea con ID específico
        await _db.collection(collection).doc(documentId).set(dataWithTimestamp);
        return documentId;
      } else {
        // Genera ID automáticamente
        final docRef = await _db.collection(collection).add(dataWithTimestamp);
        return docRef.id;
      }
    } catch (e) {
      throw DatabaseException('Error al crear documento: $e');
    }
  }

  /// Obtiene un documento por su ID
  ///
  /// [collection] Nombre de la colección
  /// [documentId] ID del documento a obtener
  ///
  /// Retorna los datos del documento o null si no existe
  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      final docSnapshot =
          await _db.collection(collection).doc(documentId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      throw DatabaseException('Error al obtener documento: $e');
    }
  }

  /// Actualiza un documento existente
  ///
  /// [collection] Nombre de la colección
  /// [documentId] ID del documento a actualizar
  /// [data] Datos a actualizar
  /// [merge] Si es true, mezcla con datos existentes. Si es false, reemplaza todo
  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      // Añade timestamp de actualización
      final dataWithTimestamp = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (merge) {
        await _db
            .collection(collection)
            .doc(documentId)
            .set(dataWithTimestamp, SetOptions(merge: true));
      } else {
        await _db
            .collection(collection)
            .doc(documentId)
            .update(dataWithTimestamp);
      }
    } catch (e) {
      throw DatabaseException('Error al actualizar documento: $e');
    }
  }

  /// Elimina un documento
  ///
  /// [collection] Nombre de la colección
  /// [documentId] ID del documento a eliminar
  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _db.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw DatabaseException('Error al eliminar documento: $e');
    }
  }

  // ==================== Consultas ====================

  /// Obtiene todos los documentos de una colección
  ///
  /// [collection] Nombre de la colección
  /// [orderBy] Campo por el que ordenar (opcional)
  /// [descending] Si es true, ordena de forma descendente
  /// [limit] Número máximo de documentos a obtener
  ///
  /// Retorna una lista de mapas con los datos de cada documento
  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _db.collection(collection);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener colección: $e');
    }
  }

  /// Consulta documentos con una condición
  ///
  /// [collection] Nombre de la colección
  /// [field] Campo a filtrar
  /// [value] Valor del campo
  /// [operator] Operador de comparación (==, !=, <, <=, >, >=, array-contains)
  Future<List<Map<String, dynamic>>> queryDocuments({
    required String collection,
    required String field,
    required dynamic value,
    String operator = '==',
  }) async {
    try {
      Query query = _db.collection(collection);

      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case 'array-contains':
          query = query.where(field, arrayContains: value);
          break;
        default:
          throw DatabaseException('Operador no soportado: $operator');
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      throw DatabaseException('Error en consulta: $e');
    }
  }

  // ==================== Streams (para datos en tiempo real) ====================

  /// Obtiene un stream de un documento para actualizaciones en tiempo real
  ///
  /// [collection] Nombre de la colección
  /// [documentId] ID del documento
  Stream<Map<String, dynamic>?> streamDocument({
    required String collection,
    required String documentId,
  }) {
    return _db
        .collection(collection)
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  /// Obtiene un stream de una colección para actualizaciones en tiempo real
  ///
  /// [collection] Nombre de la colección
  /// [orderBy] Campo por el que ordenar (opcional)
  /// [descending] Si es true, ordena de forma descendente
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
  }) {
    Query query = _db.collection(collection);

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    });
  }
}

/// Excepción personalizada para errores de base de datos
class DatabaseException implements Exception {
  /// Mensaje de error
  final String message;

  /// Constructor
  DatabaseException(this.message);

  @override
  String toString() => message;
}

// Instancia global para mantener compatibilidad con código existente
final FirebaseFirestore db = FirebaseFirestore.instance;
