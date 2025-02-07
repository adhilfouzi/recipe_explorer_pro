import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import 'widget/category_item.dart';
import 'widget/recipe_item.dart';
import 'widget/searchbar_widget.dart';
import 'widget/trending_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final filteredRecipes = recipeProvider.filteredRecipes;

    return Scaffold(
      backgroundColor: Colors.white,
      body: KeyboardDismissOnTap(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Subtitle
                  Text(
                    "Cook Book",
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Looking for your favourite meal",
                    style:
                        GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  const SearchBarWidget(),
                  const SizedBox(height: 16),

                  if (recipeProvider.searchQuery.isEmpty) ...[
                    // Categories
                    if (recipeProvider.categories.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: recipeProvider.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = recipeProvider.categories[index];
                            return CategoryItem(
                                title: category.strCategory,
                                image: category.strCategoryThumb);
                          },
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Trending Section
                    if (recipeProvider.trending.isNotEmpty)
                      Text(
                        "Trending",
                        style: GoogleFonts.lato(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 12),

                    // Trending List
                    if (recipeProvider.trending.isNotEmpty)
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          itemCount: recipeProvider.trending.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final recipe = recipeProvider.trending[index];
                            return TrendingItem(recipe: recipe);
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],

                  // Recipe List (Filtered by Search)
                  if (filteredRecipes.isNotEmpty)
                    ListView.builder(
                      controller: ScrollController(),
                      itemCount: filteredRecipes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return RecipeItem(recipe: recipe);
                      },
                    )
                  else
                    Center(
                      child: Text(
                        "No recipes found!",
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
