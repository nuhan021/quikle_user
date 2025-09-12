class SubcategoryModel {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final String categoryId;
  final String?
  parentSubcategoryId; 
  final bool isPopular;

  const SubcategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.categoryId,
    this.parentSubcategoryId,
    this.isPopular = false,
  });

  SubcategoryModel copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    String? categoryId,
    String? parentSubcategoryId,
    bool? isPopular,
  }) {
    return SubcategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      categoryId: categoryId ?? this.categoryId,
      parentSubcategoryId: parentSubcategoryId ?? this.parentSubcategoryId,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubcategoryModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.iconPath == iconPath &&
        other.categoryId == categoryId &&
        other.parentSubcategoryId == parentSubcategoryId &&
        other.isPopular == isPopular;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        iconPath.hashCode ^
        categoryId.hashCode ^
        parentSubcategoryId.hashCode ^
        isPopular.hashCode;
  }
}
