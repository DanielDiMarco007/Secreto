import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  FirestoreService._();

  static const String collection = 'messages';

  static Future<String> createMessage({
    required Map<String, dynamic> data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = prefs.getStringList(collection) ?? <String>[];
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final payload = {
        'id': id,
        ...data,
        'createdAt': DateTime.now().toIso8601String(),
      };
      messages.add(jsonEncode(payload));
      await prefs.setStringList(collection, messages);
      return id;
    } catch (e) {
      throw Exception('No se pudo guardar el mensaje: $e');
    }
  }

  static Future<Map<String, dynamic>?> getLatestMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final messages = prefs.getStringList(collection) ?? <String>[];

    if (messages.isEmpty) {
      return null;
    }

    final raw = messages.last;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> updateMessage({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = prefs.getStringList(collection) ?? <String>[];
    final updated = <String>[];

    for (final item in messages) {
      final decoded = jsonDecode(item) as Map<String, dynamic>;
      if (decoded['id'] == id) {
        updated.add(jsonEncode({...decoded, ...data}));
      } else {
        updated.add(item);
      }
    }

    await prefs.setStringList(collection, updated);
  }
}
