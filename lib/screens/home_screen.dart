import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'create_message_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secret Drop"),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CreateMessageScreen(),
                  ),
                );
              },
              child: const Text(
                "Crear Mensaje",
              ),
            ),
          ],
        ),
      ),
    );
  }
}