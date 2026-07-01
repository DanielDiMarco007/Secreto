import 'package:flutter/material.dart';

import '../services/encryption_service.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';

class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({super.key});

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  final controller = TextEditingController();

  Future<void> saveMessage() async {
    final position = await LocationService.getCurrentLocation();

    final encrypted = EncryptionService.encrypt(controller.text);

    await FirestoreService.createMessage(
      data: {
        'message': encrypted,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'createdAt': DateTime.now().toIso8601String(),
        'isRead': false,
      },
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Mensaje")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(labelText: "Mensaje secreto"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveMessage,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
