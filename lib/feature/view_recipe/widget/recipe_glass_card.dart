import 'package:flutter/material.dart';

class RecipeGlassCard extends StatelessWidget {
  final Widget child;
  const RecipeGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.grey.withOpacity(0.2)
                : Colors.brown.withOpacity(0.1),
          ),
        ],
      ),
      child: child,
    );
  }
}
