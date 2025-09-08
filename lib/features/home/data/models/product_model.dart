class ProductModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final String imagePath;
  final String categoryId;
  final String? subcategoryId;
  final String shopId;
  final bool isFavorite;
  final double rating;
  final int reviewsCount;
  final String? weight;
  final bool isOTC;
  final bool hasPrescriptionUploaded;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.categoryId,
    this.subcategoryId,
    required this.shopId,
    this.isFavorite = false,
    this.rating = 4.5,
    this.reviewsCount = 25,
    this.weight,
    this.isOTC = false,
    this.hasPrescriptionUploaded = false,
  });
  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    String? imagePath,
    String? categoryId,
    String? subcategoryId,
    String? shopId,
    bool? isFavorite,
    double? rating,
    int? reviewsCount,
    String? weight,
    bool? isOTC,
    bool? hasPrescriptionUploaded,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      shopId: shopId ?? this.shopId,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      weight: weight ?? this.weight,
      isOTC: isOTC ?? this.isOTC,
      hasPrescriptionUploaded:
          hasPrescriptionUploaded ?? this.hasPrescriptionUploaded,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.imagePath == imagePath &&
        other.categoryId == categoryId &&
        other.subcategoryId == subcategoryId &&
        other.shopId == shopId &&
        other.isFavorite == isFavorite &&
        other.rating == rating &&
        other.weight == weight &&
        other.isOTC == isOTC &&
        other.hasPrescriptionUploaded == hasPrescriptionUploaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        price.hashCode ^
        imagePath.hashCode ^
        categoryId.hashCode ^
        subcategoryId.hashCode ^
        shopId.hashCode ^
        isFavorite.hashCode ^
        rating.hashCode ^
        weight.hashCode ^
        isOTC.hashCode ^
        hasPrescriptionUploaded.hashCode;
  }

  // Helper methods
  bool get isMedicine => categoryId == '3';

  bool get canAddToCart {
    if (!isMedicine) return true;
    if (isOTC)
      return hasPrescriptionUploaded; // OTC medicines need prescription
    return true; // Normal medicines can be added directly
  }
}

class ProductSectionModel {
  final String id;
  final String viewAllText;
  final List<ProductModel> products;
  final String categoryId;

  const ProductSectionModel({
    required this.id,
    required this.viewAllText,
    required this.products,
    required this.categoryId,
  });
}
