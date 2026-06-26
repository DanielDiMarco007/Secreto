import 'package:flutter/material.dart';

import '../services/encryption_service.dart';
import '../services/firestore_service.dart';
import '../services/message_service.dart';

class UnlockMessageScreen extends StatefulWidget {
  final String messageId;
  final String encryptedMessage;
  final double latitude;
  final double longitude;

  const UnlockMessageScreen({
    super.key,
    required this.messageId,
    required this.encryptedMessage,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<UnlockMessageScreen> createState() =>
      _UnlockMessageScreenState();
}

class _UnlockMessageScreenState
    extends State<UnlockMessageScreen> {

  bool loading = true;
  bool unlocked = false;
  String message = "";
  String status = "";

  @override
  void initState() {
    super.initState();
    validateLocation();
  }

  Future<void> validateLocation() async {
    try {
      final canUnlock =
          await MessageService.canUnlock(
        latitude: widget.latitude,
        longitude: widget.longitude,
      );

      if (canUnlock) {
        final decrypted =
            EncryptionService.decrypt(
          widget.encryptedMessage,
        );

        await FirestoreService.markAsRead(
          widget.messageId,
        );

        setState(() {
          unlocked = true;
          message = decrypted;
        });
      } else {
        final text =
            await MessageService.getStatus(
          latitude: widget.latitude,
          longitude: widget.longitude,
        );

        setState(() {
          status = text;
        });
      }
    } catch (e) {
      status = e.toString();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Desbloquear Mensaje",
        ),
      ),

      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    Icon(
                      unlocked
                          ? Icons.lock_open
                          : Icons.lock,
                      size: 80,
                      color: unlocked
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      unlocked
                          ? message
                          : status,
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}