import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants/shimmer.dart';
import '../app_theme/app_theme_screen.dart';
import 'widget/category_item.dart';
import 'widget/recipe_item.dart';
import 'widget/searchbar_widget.dart';
import 'widget/trending_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final filteredRecipes = recipeProvider.filteredRecipes;
    final trending = recipeProvider.trending;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: recipeProvider.isLoading
          ? HomeScreenShimmer()
          : KeyboardDismissOnTap(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Subtitle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Cook Book",
                              style: GoogleFonts.lato(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge!.color,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AppThemeScreen(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.dark_mode,
                                  color: isDarkMode
                                      ? Colors.amberAccent
                                      : Colors.blueAccent,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Looking for your favourite meal",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium!
                                .color, // ✅ Adaptive Text Color
                          ),
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
                                  final category =
                                      recipeProvider.categories[index];
                                  return CategoryItem(category: category);
                                },
                              ),
                            ),
                          const SizedBox(height: 16),

                          // Trending Section
                          if (recipeProvider.recipes.isNotEmpty)
                            Text(
                              "Trending",
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge!.color,
                              ),
                            ),
                          const SizedBox(height: 12),

                          // Trending List
                          if (trending.isNotEmpty)
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                itemCount: trending.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final recipe = trending[index];
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
                                color: theme.textTheme.bodyMedium!.color,
                              ),
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
