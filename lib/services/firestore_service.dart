import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static Future<void> createMessage({
    required Map<String, dynamic> data,
  }) async {
    await _db.collection('messages').add(data);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getMessages() {
    return _db
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getMessage(String id) async {
    return await _db
        .collection('messages')
        .doc(id)
        .get();
  }

  static Future<void> deleteMessage(
    String id,
  ) async {
    await _db
        .collection('messages')
        .doc(id)
        .delete();
  }
}