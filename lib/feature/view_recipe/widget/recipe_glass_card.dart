import 'package:flutter/material.dart';

class RecipeGlassCard extends StatelessWidget {
  final Widget child;
  const RecipeGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
