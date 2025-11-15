class CategoryModel {
  final String id;
  final String title;
  final String type;
  final String iconPath;

  const CategoryModel({
    required this.id,
    required this.title,
    this.type = 'All',
    required this.iconPath,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      title: json['name'] as String,
      type: json['type'] ?? 'All',
      iconPath: json['avatar'] as String,
    );
  }
}
