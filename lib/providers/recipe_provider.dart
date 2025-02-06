import 'package:flutter/material.dart';
import '../data/models/recipe_model.dart';
import '../utils/http/common_site.dart';
import '../utils/http/http_service.dart';

class RecipeProvider with ChangeNotifier {
  List<RecipeModel> _recipes = [];

  List<RecipeModel> get recipes => _recipes;

  Future<void> fetchRecipes() async {
    await HttpService.getRequest(Site.randomMeal(), true).then((value) {
      _recipes = value;
      notifyListeners();
    });
  }
}
