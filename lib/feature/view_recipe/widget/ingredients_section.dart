import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/recipe_model.dart';
import 'recipe_glass_card.dart';

class IngredientsSection extends StatelessWidget {
  final RecipeModel recipe;

  const IngredientsSection({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return RecipeGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Ingredients",
              style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800),
            ),
          ),
          ...List.generate(
            recipe.ingredients.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${index + 1}.",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        "${recipe.ingredients[index]} - ${recipe.measurements[index]}",
                        style: GoogleFonts.poppins(fontSize: 16),
                        textAlign: TextAlign.justify),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
