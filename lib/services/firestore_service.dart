import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static const String collection = "messages";

  /// Crear mensaje
  static Future<String> createMessage({
    required Map<String, dynamic> data,
  }) async {
    try {
      final doc = await _db
          .collection(collection)
          .add(data);

      return doc.id;
    } catch (e) {
      throw Exception(
        "Error al crear mensaje: $e",
      );
    }
  }

  /// Obtener todos los mensajes
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getMessages() {
    return _db
        .collection(collection)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  /// Obtener mensaje por ID
  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getMessage(String id) async {
    return await _db
        .collection(collection)
        .doc(id)
        .get();
  }

  /// Marcar como leído
  static Future<void> markAsRead(
    String id,
  ) async {
    await _db
        .collection(collection)
        .doc(id)
        .update({
      'isRead': true,
      'readAt': Timestamp.now(),
    });
  }

  /// Actualizar mensaje
  static Future<void> updateMessage({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _db
        .collection(collection)
        .doc(id)
        .update(data);
  }

  /// Eliminar mensaje
  static Future<void> deleteMessage(
    String id,
  ) async {
    await _db
        .collection(collection)
        .doc(id)
        .delete();
  }
}