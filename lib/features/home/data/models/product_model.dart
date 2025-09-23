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
  final String? productType;
  final bool isPrescriptionMedicine;
  final String? prescriptionId;
  final String? vendorResponseId;

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
    this.productType,
    this.isPrescriptionMedicine = false,
    this.prescriptionId,
    this.vendorResponseId,
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
    String? productType,
    bool? isPrescriptionMedicine,
    String? prescriptionId,
    String? vendorResponseId,
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
      productType: productType ?? this.productType,
      isPrescriptionMedicine:
          isPrescriptionMedicine ?? this.isPrescriptionMedicine,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      vendorResponseId: vendorResponseId ?? this.vendorResponseId,
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
        other.hasPrescriptionUploaded == hasPrescriptionUploaded &&
        other.productType == productType &&
        other.isPrescriptionMedicine == isPrescriptionMedicine &&
        other.prescriptionId == prescriptionId &&
        other.vendorResponseId == vendorResponseId;
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
        hasPrescriptionUploaded.hashCode ^
        productType.hashCode ^
        isPrescriptionMedicine.hashCode ^
        prescriptionId.hashCode ^
        vendorResponseId.hashCode;
  }

  // Medicine related getters
  bool get isMedicine => categoryId == '3';

  bool get canAddToCart {
    if (!isMedicine) return true;

    // For prescription medicines (from uploaded prescriptions) - always addable
    if (isPrescriptionMedicine) return true;

    // For OTC medicines (displayed in app) - always addable without restrictions
    if (isOTC) return true;

    // Non-OTC medicines should not be visible in the app
    return false;
  }

  bool get requiresPrescription =>
      isMedicine && !isOTC && !isPrescriptionMedicine;

  String get medicineType {
    if (!isMedicine) return 'regular';
    if (isPrescriptionMedicine) return 'prescription_approved';
    if (isOTC) return 'otc';
    return 'prescription_required';
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
