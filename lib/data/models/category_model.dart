class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      image: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategory': id,
      'strCategory': name,
      'strCategoryThumb': image,
      'strCategoryDescription': description,
    };
  }

  static List<CategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
