import 'package:quikle_user/features/home/data/models/product_model.dart';

class PrescriptionModel {
  final String id;
  final String userId;
  final String imagePath;
  final String fileName;
  final DateTime uploadedAt;
  final PrescriptionStatus status;
  final String? notes;
  final List<PrescriptionResponseModel> vendorResponses;

  const PrescriptionModel({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.fileName,
    required this.uploadedAt,
    required this.status,
    this.notes,
    this.vendorResponses = const [],
  });

  PrescriptionModel copyWith({
    String? id,
    String? userId,
    String? imagePath,
    String? fileName,
    DateTime? uploadedAt,
    PrescriptionStatus? status,
    String? notes,
    List<PrescriptionResponseModel>? vendorResponses,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      fileName: fileName ?? this.fileName,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      vendorResponses: vendorResponses ?? this.vendorResponses,
    );
  }

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      imagePath: json['imagePath'] as String,
      fileName: json['fileName'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      status: PrescriptionStatus.values.firstWhere(
        (e) => e.toString() == 'PrescriptionStatus.${json['status']}',
      ),
      notes: json['notes'] as String?,
      vendorResponses:
          (json['vendorResponses'] as List<dynamic>?)
              ?.map(
                (e) => PrescriptionResponseModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imagePath': imagePath,
      'fileName': fileName,
      'uploadedAt': uploadedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'notes': notes,
      'vendorResponses': vendorResponses.map((e) => e.toJson()).toList(),
    };
  }
}

class PrescriptionResponseModel {
  final String id;
  final String prescriptionId;
  final String vendorId;
  final String vendorName;
  final List<ProductModel> medicines;
  final double totalAmount;
  final VendorResponseStatus status;
  final DateTime respondedAt;
  final String? notes;

  const PrescriptionResponseModel({
    required this.id,
    required this.prescriptionId,
    required this.vendorId,
    required this.vendorName,
    required this.medicines,
    required this.totalAmount,
    required this.status,
    required this.respondedAt,
    this.notes,
  });

  PrescriptionResponseModel copyWith({
    String? id,
    String? prescriptionId,
    String? vendorId,
    String? vendorName,
    List<ProductModel>? medicines,
    double? totalAmount,
    VendorResponseStatus? status,
    DateTime? respondedAt,
    String? notes,
  }) {
    return PrescriptionResponseModel(
      id: id ?? this.id,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      medicines: medicines ?? this.medicines,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      respondedAt: respondedAt ?? this.respondedAt,
      notes: notes ?? this.notes,
    );
  }

  factory PrescriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionResponseModel(
      id: json['id'] as String,
      prescriptionId: json['prescriptionId'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      medicines: (json['medicines'] as List<dynamic>)
          .map(
            (e) => ProductModel(
              id: e['id'] as String,
              title: e['name'] as String,
              description: e['brand'] as String,
              price: (e['price'] as num).toDouble().toString(),
              imagePath: e['imagePath'] as String? ?? '',
              categoryId: '3',
              shopId: e['vendorId'] as String? ?? '',
              weight: e['dosage'] as String?,
              isPrescriptionMedicine: true,
              prescriptionId: json['prescriptionId'] as String,
            ),
          )
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: VendorResponseStatus.values.firstWhere(
        (e) => e.toString() == 'VendorResponseStatus.${json['status']}',
      ),
      respondedAt: DateTime.parse(json['respondedAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescriptionId': prescriptionId,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'medicines': medicines.map((e) => _productToMedicineJson(e)).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'respondedAt': respondedAt.toIso8601String(),
      'notes': notes,
    };
  }

  Map<String, dynamic> _productToMedicineJson(ProductModel product) {
    return {
      'id': product.id,
      'name': product.title,
      'brand': product.description,
      'dosage': product.weight ?? '',
      'quantity': 1,
      'price': double.tryParse(product.price) ?? 0.0,
      'notes': null,
      'isAvailable': true,
      'imagePath': product.imagePath,
      'vendorId': product.shopId,
    };
  }
}

enum PrescriptionStatus { uploaded, processing, responded, expired, rejected }

enum VendorResponseStatus {
  pending,
  approved,
  partiallyApproved,
  rejected,
  expired,
}

extension PrescriptionStatusExtension on PrescriptionStatus {
  String get displayName {
    switch (this) {
      case PrescriptionStatus.uploaded:
        return 'Uploaded';
      case PrescriptionStatus.processing:
        return 'Processing';
      case PrescriptionStatus.responded:
        return 'Approved';
      case PrescriptionStatus.expired:
        return 'Expired';
      case PrescriptionStatus.rejected:
        return 'Rejected';
    }
  }

  String get description {
    switch (this) {
      case PrescriptionStatus.uploaded:
        return 'Your prescription has been uploaded successfully';
      case PrescriptionStatus.processing:
        return 'Vendors are reviewing your prescription';
      case PrescriptionStatus.responded:
        return 'Vendors have responded with available medicines';
      case PrescriptionStatus.expired:
        return 'Prescription has expired';
      case PrescriptionStatus.rejected:
        return 'Prescription was rejected';
    }
  }
}

extension VendorResponseStatusExtension on VendorResponseStatus {
  String get displayName {
    switch (this) {
      case VendorResponseStatus.pending:
        return 'Pending';
      case VendorResponseStatus.approved:
        return 'Approved';
      case VendorResponseStatus.partiallyApproved:
        return 'Partially Approved';
      case VendorResponseStatus.rejected:
        return 'Rejected';
      case VendorResponseStatus.expired:
        return 'Expired';
    }
  }
}

extension PrescriptionProductExtension on ProductModel {
  int get prescriptionQuantity {
    if (vendorResponseId?.isNotEmpty == true) {
      return int.tryParse(vendorResponseId!.split('_').last) ?? 1;
    }
    return 1;
  }

  String get dosage => weight ?? '';

  String get medicineName => title;

  String get brandName => description;

  double get medicinePrice => double.tryParse(price) ?? 0.0;

  bool get isMedicineAvailable => true;

  ProductModel copyWithPrescriptionData({
    String? dosage,
    int? quantity,
    String? prescriptionId,
    String? vendorResponseId,
  }) {
    return copyWith(
      weight: dosage ?? this.weight,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      vendorResponseId:
          vendorResponseId ??
          '${this.vendorResponseId?.split('_').first ?? 'med'}_${quantity ?? 1}',
      isPrescriptionMedicine: true,
    );
  }
}
