class RecipeModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final String youtubeUrl;
  final List<String> ingredients;
  final List<String> measurements;
  final String? source;

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
    );
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
    );
  }
}
