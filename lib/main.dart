import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BuzonSecretoApp());
}

class BuzonSecretoApp extends StatelessWidget {
  const BuzonSecretoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzón Secreto',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      home: const LoginScreen(),
    );
  }
}
