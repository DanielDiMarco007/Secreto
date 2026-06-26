import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HackerBackground extends StatelessWidget {
  final Widget child;

  const HackerBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF08080D),
            Color(0xFF13131C),
            Color(0xFF1A1030),
          ],
        ),
      ),
      child: child,
    );
  }
}