class SubcategoryModel {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final String categoryId;
  final String? parentSubcategoryId;

  const SubcategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.categoryId,
    this.parentSubcategoryId,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'].toString(),
      title: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      iconPath: (json['avatar'] as String?) ?? '',
      // iconPath: 'assets/images/logo.png',
      categoryId: json['category']['id'].toString(),
      parentSubcategoryId: json['parent_subcategory_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'avatar': iconPath,
      'category': {'id': categoryId},
      'parent_subcategory_id': parentSubcategoryId,
    };
  }
}
