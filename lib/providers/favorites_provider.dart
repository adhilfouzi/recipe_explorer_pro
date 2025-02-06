import 'package:flutter/material.dart';

import '../data/models/recipe_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<RecipeModel> _favorites = [];

  List<RecipeModel> get favorites => _favorites;

  void toggleFavorite(RecipeModel recipe) {
    if (_favorites.contains(recipe)) {
      _favorites.remove(recipe);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
  }
}
