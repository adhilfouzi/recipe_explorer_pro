import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_explorer_pro/data/models/recipe_model.dart';

import '../../../utils/constants/shimmer.dart';
import '../../view_recipe/view_recipe_screen.dart';

class RecipeItem extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeItem({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewRecipeScreen(recipe: recipe)));
        },
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: recipe.thumbnailUrl,
                  width: 100,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const ShimmerPlaceholder(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        {recipe.area, recipe.category}
                            .where((e) => e.isNotEmpty)
                            .join(' | '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
