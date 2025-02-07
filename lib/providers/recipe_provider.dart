import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../data/models/category_model.dart';
import '../data/models/recipe_model.dart';
import '../utils/http/common_site.dart';
import '../utils/http/http_service.dart';

class RecipeProvider with ChangeNotifier {
  late Box<RecipeModel> _recipeBox;
  late Box<CategoryModel> _categoryBox;

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
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    _recipeBox = await Hive.openBox<RecipeModel>('recipes');
    _categoryBox = await Hive.openBox<CategoryModel>('categories');
    fetchAll();
  }

  Future<void> fetchAll() async {
    if (_categoryBox.isEmpty) {
      await fetchRecipesCategories();
    } else {
      _category = _categoryBox.values.toList();
      _recipes.addAll(_recipeBox.values);
      await fetchRecipesCategories();
    }
    notifyListeners();
  }

  Future<void> fetchRecipesCategories() async {
    try {
      final value = await HttpService.getRequest(Site.allCategories(), false);
      final List<dynamic>? categoriesJson = value['categories'];
      if (categoriesJson != null) {
        _category.addAll(
          categoriesJson
              .map((json) => CategoryModel.fromJson(json))
              .where((category) => !_categoryBox.values.any(
                  (existingCategory) => existingCategory.id == category.id))
              .toList(),
        );

        _categoryBox.addAll(_category);
        for (var category in _category) {
          await fetchRecipesByCategory(category.name);
        }
      }
      notifyListeners();
    } catch (e) {
      log('Error fetching categories: $e');
    }
  }

  Future<void> fetchRecipesByCategory(String category) async {
    await fetchRecipesBySearch(category);
    await fetchRecipesSeafood(category);
  }

  Future<void> fetchRecipesSeafood(String query) async {
    if (query.isEmpty) return;
    try {
      final value =
          await HttpService.getRequest(Site.filterByCategory(query), false);
      final List<dynamic>? mealsJson = value['meals'];
      if (mealsJson != null) {
        for (var json in mealsJson) {
          await fetchRecipeById(json['idMeal']);
        }
      } else {
        log('No data found');
      }
      notifyListeners();
    } catch (e) {
      log('Error fetching seafood recipes: $e');
    }
  }

  Future<void> fetchRecipeById(String id) async {
    if (_recipes.any((element) => element.id == id)) return;
    try {
      final value =
          await HttpService.getRequest(Site.lookupMealById(id), false);
      if (value['meals'] != null) {
        RecipeModel recipe = RecipeModel.fromJson(value['meals'].first ?? {});
        if (!_recipes.any((element) => element.id == recipe.id)) {
          _recipes.add(recipe);
          _recipeBox.put(recipe.id, recipe);
        }
      }
      notifyListeners();
    } catch (e) {
      log('Error fetching recipe by ID: $e');
    }
  }

  void searchRecipes(String query) {
    _searchQuery = query;
    fetchRecipesBySearch(query);
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

  Future<void> fetchRecipesBySearch(String query) async {
    if (query.isEmpty) return;
    try {
      final value =
          await HttpService.getRequest(Site.searchMealByName(query), false);
      final List<dynamic>? mealsJson = value['meals'];
      if (mealsJson != null) {
        for (var json in mealsJson) {
          RecipeModel recipe = RecipeModel.fromJson(json);
          if (!_recipes.any((element) => element.id == recipe.id)) {
            _recipes.add(recipe);
            _recipeBox.put(recipe.id, recipe);
          }
        }
      } else {
        log('No data found');
      }
      notifyListeners();
    } catch (e) {
      log('Error fetching recipes by search: $e');
    }
  }

  void toggleFavorite(String id) {
    final recipeIndex = _recipes.indexWhere((recipe) => recipe.id == id);
    if (recipeIndex != -1) {
      _recipes[recipeIndex] = RecipeModel(
        id: _recipes[recipeIndex].id,
        name: _recipes[recipeIndex].name,
        category: _recipes[recipeIndex].category,
        area: _recipes[recipeIndex].area,
        instructions: _recipes[recipeIndex].instructions,
        thumbnailUrl: _recipes[recipeIndex].thumbnailUrl,
        youtubeUrl: _recipes[recipeIndex].youtubeUrl,
        ingredients: _recipes[recipeIndex].ingredients,
        measurements: _recipes[recipeIndex].measurements,
        source: _recipes[recipeIndex].source,
        isFavorite: !_recipes[recipeIndex].isFavorite,
      );
      _recipeBox.put(id, _recipes[recipeIndex]);
      notifyListeners();
    }
  }
}
