import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> register() async {
    try {
      setState(() => loading = true);

      await AuthService.register(
        email: emailController.text,
        password: passwordController.text,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(
                labelText: "Correo",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: "Contraseña",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  loading ? null : register,
              child: const Text(
                "Crear Cuenta",
              ),
            ),
          ],
        ),
      ),
    );
  }
}