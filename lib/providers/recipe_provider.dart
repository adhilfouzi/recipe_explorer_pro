import 'dart:developer';

import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../data/models/recipe_model.dart';
import '../utils/http/common_site.dart';
import '../utils/http/http_service.dart';

class RecipeProvider with ChangeNotifier {
  final List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  List<CategoryModel> _category = [];
  List<CategoryModel> get categories => _category;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<RecipeModel> _filteredRecipes = [];
  List<RecipeModel> get filteredRecipes =>
      _searchQuery.isEmpty ? _recipes : _filteredRecipes;

  RecipeProvider() {
    fetchAll();
  }

  Future<void> fetchAll() async {
    await fetchRecipesCategories();
  }

  Future<void> fetchRecipesCategories() async {
    await HttpService.getRequest(Site.allCategories(), false)
        .then((value) async {
      final List<dynamic>? categoriesJson = value['categories'];
      if (categoriesJson != null) {
        _category =
            categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
        for (var category in _category) {
          await fetchRecipesbySearch(category.name);
          await fetchRecipesSeafood(category.name);
        }
      } else {
        _category = [];
      }
      notifyListeners();
    });
  }

  Future<void> fetchRecipesSeafood(String query) async {
    if (query.isEmpty) {
      return;
    }
    await HttpService.getRequest(Site.filterByCategory(query), false)
        .then((value) async {
      final List<dynamic>? categoriesJson = value['meals'];
      if (categoriesJson != null) {
        for (var json in categoriesJson) {
          await fetchRecipeById(json['idMeal']);
        }
      } else {
        log('No data found');
      }
      notifyListeners();
    });
  }

  Future<void> fetchRecipeById(String id) async {
    if (_recipes.any((element) => element.id == id)) {
      return;
    }
    await HttpService.getRequest(Site.lookupMealById(id), false).then((value) {
      if (value['meals'] != null) {
        RecipeModel recipe = RecipeModel.fromJson(value['meals'].first ?? {});
        if (!_recipes.any((element) => element.id == recipe.id)) {
          _recipes.add(recipe);
        }
      }
      notifyListeners();
    });
  }

  void searchRecipes(String query) {
    _searchQuery = query;
    fetchRecipesbySearch(query);
    if (query.isEmpty) {
      _filteredRecipes = [];
    } else {
      _filteredRecipes = _recipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchRecipesbySearch(String query) async {
    if (query.isEmpty) {
      return;
    }
    await HttpService.getRequest(Site.searchMealByName(query), false)
        .then((value) {
      final List<dynamic>? categoriesJson = value['meals'];
      if (categoriesJson != null) {
        for (var json in categoriesJson) {
          RecipeModel recipe = RecipeModel.fromJson(json);
          if (!_recipes.any((element) => element.id == recipe.id)) {
            _recipes.add(recipe);
          }
        }
      } else {
        // _recipes = [];
        log('No data found');
      }
      notifyListeners();
    });
  }
}
