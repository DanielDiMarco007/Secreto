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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.background,
            AppTheme.surface,
            AppTheme.purple.withOpacity(0.25),
          ],
        ),
      ),
      child: child,
    );
  }
}