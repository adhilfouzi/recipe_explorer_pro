import 'dart:developer';

import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../data/models/recipe_model.dart';
import '../utils/http/common_site.dart';
import '../utils/http/http_service.dart';

class RecipeProvider with ChangeNotifier {
  RecipeModel _recipes = RecipeModel.empty();
  RecipeModel get recipes => _recipes;

  List<RecipeModel> _trending = [];
  List<RecipeModel> get trending => _trending;

  List<RecipeModel> _tileList = [];
  List<RecipeModel> get tileList => _tileList;

  List<CategoryModel> _category = [];
  List<CategoryModel> get categories => _category;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<RecipeModel> _filteredRecipes = [];
  List<RecipeModel> get filteredRecipes =>
      _searchQuery.isEmpty ? _tileList : _filteredRecipes;

  RecipeProvider() {
    fetchAll();
  }

  Future<void> fetchAll() async {
    // fetchRecipes();
    await fetchRecipesCategories();
    await fetchRecipesIngredient();
    await fetchRecipesSeafood();
  }

  // Future<void> fetchRecipes() async {
  //   await HttpService.getRequest(Site.randomMeal(), false).then((value) {
  //     final List<dynamic>? mealsJson = value['meals'];
  //     if (mealsJson != null) {
  //       _recipes = mealsJson.map((json) => RecipeModel.fromJson(json)).toList();
  //     } else {
  //       _recipes = [];
  //     }

  //     notifyListeners();
  //   });
  // }

  Future<void> fetchRecipesCategories() async {
    await HttpService.getRequest(Site.allCategories(), false).then((value) {
      final List<dynamic>? categoriesJson = value['categories'];
      if (categoriesJson != null) {
        _category =
            categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        _category = [];
      }
      notifyListeners();
    });
  }

  Future<void> fetchRecipesSeafood() async {
    await HttpService.getRequest(Site.filterByCategory('Seafood'), false)
        .then((value) {
      final List<dynamic>? categoriesJson = value['meals'];
      if (categoriesJson != null) {
        _trending =
            categoriesJson.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        _trending = [];
      }
      notifyListeners();
    });
  }

  Future<void> fetchRecipeById(String id) async {
    await HttpService.getRequest(Site.lookupMealById(id), true).then((value) {
      if (value['meals'] != null) {
        _recipes = RecipeModel.fromJson(value['meals']);
      }
      notifyListeners();
    });
  }

  Future<void> fetchRecipesIngredient() async {
    // await fetchRecipesbySearch('chicken_breast');
    await HttpService.getRequest(Site.searchMealByName('chicken'), false)
        .then((value) {
      final List<dynamic>? categoriesJson = value['meals'];
      if (categoriesJson != null) {
        _tileList =
            categoriesJson.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        _tileList = [];
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
      _filteredRecipes = _tileList
          .where((recipe) =>
              recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchRecipesbySearch(String query) async {
    await HttpService.getRequest(Site.searchMealByName(query), false)
        .then((value) {
      final List<dynamic>? categoriesJson = value['meals'];
      if (categoriesJson != null) {
        for (var json in categoriesJson) {
          RecipeModel recipe = RecipeModel.fromJson(json);
          if (!_tileList.any((element) => element.id == recipe.id)) {
            _tileList.add(recipe);
          }
        }
      } else {
        // _tileList = [];
        log('No data found');
      }
      notifyListeners();
    });
  }
}
