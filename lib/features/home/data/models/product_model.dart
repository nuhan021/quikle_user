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

  /// Factory constructor to create ProductModel from API response or cached data
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Check if this is cached data (has 'imagePath') or API data (has 'image')
    final bool isCachedData = json.containsKey('imagePath');

    return ProductModel(
      id: json['id'].toString(),
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      // Handle both cached format and API format for price
      price: isCachedData
          ? (json['price'] as String?) ?? '\$0'
          : '\$${json['sell_price'] ?? 0}',
      // Handle both cached format (imagePath) and API format (image)
      imagePath: isCachedData
          ? (json['imagePath'] as String?) ?? ''
          : (json['image'] as String?) ?? '',
      // Handle both cached format and API format for categoryId
      categoryId: isCachedData
          ? (json['categoryId'] as String?) ?? ''
          : json['category_id']?.toString() ?? '',
      subcategoryId:
          json['subcategoryId']?.toString() ??
          json['subcategory_id']?.toString(),
      // Handle both cached format and API format for shopId
      shopId: isCachedData
          ? (json['shopId'] as String?) ?? ''
          : json['vendor_id']?.toString() ?? '',
      rating: isCachedData
          ? (json['rating'] as num?)?.toDouble() ?? 4.5
          : (json['ratings'] as num?)?.toDouble() ?? 4.5,
      weight: json['weight']?.toString(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      reviewsCount: isCachedData
          ? (json['reviewsCount'] as int?) ?? 0
          : (json['total_sale'] as int?) ?? 0,
      isOTC: isCachedData
          ? (json['isOTC'] as bool?) ?? false
          : (json['is_otc'] as bool?) ?? false,
      productType:
          json['productType'] as String? ?? json['product_type'] as String?,
      isPrescriptionMedicine: isCachedData
          ? (json['isPrescriptionMedicine'] as bool?) ?? false
          : (json['is_prescription_medicine'] as bool?) ?? false,
      hasPrescriptionUploaded:
          json['hasPrescriptionUploaded'] as bool? ?? false,
      prescriptionId: json['prescriptionId'] as String?,
      vendorResponseId: json['vendorResponseId'] as String?,
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'shopId': shopId,
      'isFavorite': isFavorite,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'weight': weight,
      'isOTC': isOTC,
      'hasPrescriptionUploaded': hasPrescriptionUploaded,
      'productType': productType,
      'isPrescriptionMedicine': isPrescriptionMedicine,
      'prescriptionId': prescriptionId,
      'vendorResponseId': vendorResponseId,
    };
  }

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
  bool get isMedicine => categoryId == '6';

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
