class ProductModel {
  final String title;
  final String price;
  final String imagePath;
  final int categoryId;
  final bool isFavorite;

  const ProductModel({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.categoryId,
    this.isFavorite = false,
  });

  // CopyWith method for easy state updates
  ProductModel copyWith({
    String? title,
    String? price,
    String? imagePath,
    int? categoryId,
    bool? isFavorite,
  }) {
    return ProductModel(
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Equality and hashCode for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.title == title &&
        other.price == price &&
        other.imagePath == imagePath &&
        other.categoryId == categoryId &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        price.hashCode ^
        imagePath.hashCode ^
        categoryId.hashCode ^
        isFavorite.hashCode;
  }
}

class ProductSectionModel {
  final String viewAllText;
  final List<ProductModel> products;
  final int categoryId;

  const ProductSectionModel({
    required this.viewAllText,
    required this.products,
    required this.categoryId,
  });
}
