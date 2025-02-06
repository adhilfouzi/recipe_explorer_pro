import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'recipe_glass_card.dart';

class InstructionsSection extends StatelessWidget {
  final String instructions;

  const InstructionsSection({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return RecipeGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Instructions",
              style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800),
            ),
          ),
          Text(instructions,
              style: GoogleFonts.lato(fontSize: 16),
              textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
