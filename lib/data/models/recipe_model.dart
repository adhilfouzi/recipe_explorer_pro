import 'package:hive_ce/hive.dart';
part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String area;
  @HiveField(4)
  final String instructions;
  @HiveField(5)
  final String thumbnailUrl;
  @HiveField(6)
  final String youtubeUrl;
  @HiveField(7)
  final List<String> ingredients;
  @HiveField(8)
  final List<String> measurements;
  @HiveField(9)
  final String? source;
  @HiveField(10)
  final bool isFavorite;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.youtubeUrl,
    required this.ingredients,
    required this.measurements,
    this.source,
    this.isFavorite = false,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    List<String> extractedIngredients = [];
    List<String> extractedMeasurements = [];

    // Extract ingredients and measurements dynamically
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measurement = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        extractedIngredients.add(ingredient);
        extractedMeasurements.add(measurement ?? "");
      } else {
        break;
      }
    }

    return RecipeModel(
        id: json['idMeal'] ?? '',
        name: json['strMeal'] ?? 'Unknown',
        category: json['strCategory'] ?? 'Unknown',
        area: json['strArea'] ?? 'Unknown',
        instructions: json['strInstructions'] ?? '',
        thumbnailUrl: json['strMealThumb'] ?? '',
        youtubeUrl: json['strYoutube'] ?? '',
        ingredients: extractedIngredients,
        measurements: extractedMeasurements,
        source: json['strSource'],
        isFavorite: false);
  }

  factory RecipeModel.empty() {
    return RecipeModel(
      id: '',
      name: '',
      category: '',
      area: '',
      instructions: '',
      thumbnailUrl: '',
      youtubeUrl: '',
      ingredients: [],
      measurements: [],
      source: null,
      isFavorite: false,
    );
  }
}
