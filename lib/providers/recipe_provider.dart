import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/models/recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  List<RecipeModel> _recipes = [];

  List<RecipeModel> get recipes => _recipes;

  Future<void> fetchRecipes() async {
    final response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s="));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _recipes = (data['meals'] as List)
          .map((meal) => RecipeModel.fromJson(meal))
          .toList();
      notifyListeners();
    }
  }
}
