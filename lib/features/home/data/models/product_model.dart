class ProductModel {
  final String title;
  final String price;
  final String imagePath;
  final int categoryId;
  final bool isFavorite;
  final double rating;
  final String? weight;

  const ProductModel({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.categoryId,
    this.isFavorite = false,
    this.rating = 4.5,
    this.weight,
  });
  ProductModel copyWith({
    String? title,
    String? price,
    String? imagePath,
    int? categoryId,
    bool? isFavorite,
    double? rating,
    String? weight,
  }) {
    return ProductModel(
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      weight: weight ?? this.weight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.title == title &&
        other.price == price &&
        other.imagePath == imagePath &&
        other.categoryId == categoryId &&
        other.isFavorite == isFavorite &&
        other.rating == rating &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        price.hashCode ^
        imagePath.hashCode ^
        categoryId.hashCode ^
        isFavorite.hashCode ^
        rating.hashCode ^
        weight.hashCode;
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
