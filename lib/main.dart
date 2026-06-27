import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('$stackTrace');
  }

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
