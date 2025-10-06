import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class PrescriptionService {
  // In-memory mock store
  static final List<PrescriptionModel> _prescriptions = [];

  // ---------- Helpers (handy for future real uploads) ----------
  //bool _isPdfPath(String path) => path.toLowerCase().endsWith('.pdf');

  // String _inferMime(String path) {
  //   final p = path.toLowerCase();
  //   if (p.endsWith('.pdf')) return 'application/pdf';
  //   if (p.endsWith('.png')) return 'image/png';
  //   if (p.endsWith('.jpg') || p.endsWith('.jpeg')) return 'image/jpeg';
  //   if (p.endsWith('.heic')) return 'image/heic';
  //   if (p.endsWith('.webp')) return 'image/webp';
  //   return 'application/octet-stream';
  // }

  // ---------- Public API ----------
  Future<PrescriptionModel> uploadPrescription({
    required String userId,
    required File imageFile, // can be image OR pdf
    String? notes,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final prescriptionId = 'presc_${DateTime.now().millisecondsSinceEpoch}';

    // (Optional) Use MIME for debug/logging (kept here for future real API)
    //final mime = _inferMime(imageFile.path);
    // print('Uploading file ${imageFile.path} with mime: $mime');

    final prescription = PrescriptionModel(
      id: prescriptionId,
      userId: userId,
      imagePath: imageFile.path, // path to file (image or pdf)
      fileName: imageFile.path.split('/').last,
      uploadedAt: DateTime.now(),
      status: PrescriptionStatus.uploaded,
      notes: notes,
      // If your model later adds fields like isPdf/mimeType, set them here using _isPdfPath/mime
    );

    _prescriptions.add(prescription);

    // Kick off mock processing → response
    _simulateVendorProcessing(prescriptionId);

    return prescription;
  }

  Future<List<PrescriptionModel>> getUserPrescriptions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _prescriptions.where((p) => p.userId == userId).toList()
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
  }

  Future<PrescriptionModel?> getPrescriptionById(String prescriptionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _prescriptions.firstWhere((p) => p.id == prescriptionId);
    } catch (_) {
      return null;
    }
  }

  Future<List<ProductModel>> getPendingPrescriptionMedicines(
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final userPrescriptions = await getUserPrescriptions(userId);
    final prescriptionMedicines = <ProductModel>[];

    for (final prescription in userPrescriptions) {
      if (prescription.status == PrescriptionStatus.medicinesReady) {
        for (final response in prescription.vendorResponses) {
          if (response.status == VendorResponseStatus.approved ||
              response.status == VendorResponseStatus.partiallyApproved) {
            for (final medicine in response.medicines) {
              if (medicine.isMedicineAvailable) {
                // IMPORTANT: keep price string numeric only (no $)
                final product = ProductModel(
                  id: 'presc_med_${medicine.id}',
                  title: '${medicine.brandName} ${medicine.medicineName}',
                  description: '${medicine.dosage} - Prescription Medicine',
                  price: medicine.medicinePrice.toStringAsFixed(2),
                  imagePath: ImagePath.medicineIcon,
                  categoryId: '3',
                  subcategoryId: 'medicine_prescription',
                  shopId: response.vendorId,
                  rating: 4.5,
                  weight: '${medicine.prescriptionQuantity} units',
                  isOTC: false,
                  hasPrescriptionUploaded: true,
                  productType: 'prescription_medicine',
                );

                prescriptionMedicines.add(product);
              }
            }
          }
        }
      }
    }

    return prescriptionMedicines;
  }

  Future<List<ProductModel>> getRecentPrescriptionMedicines(
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final userPrescriptions = await getUserPrescriptions(userId);
    final prescriptionMedicines = <ProductModel>[];

    final recentPrescription = userPrescriptions
        .where((p) => p.status == PrescriptionStatus.medicinesReady)
        .firstOrNull;

    if (recentPrescription != null) {
      for (final response in recentPrescription.vendorResponses) {
        if (response.status == VendorResponseStatus.approved ||
            response.status == VendorResponseStatus.partiallyApproved) {
          for (final medicine in response.medicines) {
            if (medicine.isMedicineAvailable) {
              final product = ProductModel(
                id: 'presc_med_${medicine.id}',
                title: '${medicine.brandName} ${medicine.medicineName}',
                description: '${medicine.dosage} - Prescription Medicine',
                price: medicine.medicinePrice.toStringAsFixed(2),
                imagePath: ImagePath.medicineIcon,
                categoryId: '3',
                subcategoryId: 'medicine_prescription',
                shopId: response.vendorId,
                rating: 4.5,
                weight: '${medicine.prescriptionQuantity} units',
                isOTC: false,
                hasPrescriptionUploaded: true,
                productType: 'prescription_medicine',
              );

              prescriptionMedicines.add(product);
            }
          }
        }
      }
    }

    return prescriptionMedicines;
  }

  Future<bool> deletePrescription(String prescriptionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _prescriptions.indexWhere((p) => p.id == prescriptionId);
    if (index != -1) {
      _prescriptions.removeAt(index);
      return true;
    }
    return false;
  }

  Future<bool> acceptVendorResponse(String responseId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real service: persist acceptance & lock the quote
    return true;
  }

  Future<Map<String, int>> getPrescriptionStats(String userId) async {
    final prescriptions = await getUserPrescriptions(userId);

    return {
      'total': prescriptions.length,
      'uploaded': prescriptions
          .where((p) => p.status == PrescriptionStatus.uploaded)
          .length,
      'underReview': prescriptions
          .where((p) => p.status == PrescriptionStatus.underReview)
          .length,
      'valid': prescriptions
          .where((p) => p.status == PrescriptionStatus.valid)
          .length,
      'invalid': prescriptions
          .where((p) => p.status == PrescriptionStatus.invalid)
          .length,
      'medicinesReady': prescriptions
          .where((p) => p.status == PrescriptionStatus.medicinesReady)
          .length,
    };
  }

  // ---------- Mock pipeline ----------
  void _simulateVendorProcessing(String prescriptionId) {
    Future.delayed(const Duration(seconds: 5), () async {
      final prescriptionIndex = _prescriptions.indexWhere(
        (p) => p.id == prescriptionId,
      );
      if (prescriptionIndex != -1) {
        _prescriptions[prescriptionIndex] = _prescriptions[prescriptionIndex]
            .copyWith(status: PrescriptionStatus.underReview);

        Future.delayed(const Duration(seconds: 10), () {
          _validatePrescription(prescriptionId);
        });
      }
    });
  }

  void _validatePrescription(String prescriptionId) {
    final prescriptionIndex = _prescriptions.indexWhere(
      (p) => p.id == prescriptionId,
    );

    if (prescriptionIndex != -1) {
      final random = Random();
      final isValid = random.nextDouble() >= 0.5;

      if (isValid) {
        _prescriptions[prescriptionIndex] = _prescriptions[prescriptionIndex]
            .copyWith(status: PrescriptionStatus.valid);

        Future.delayed(const Duration(seconds: 8), () {
          _generateMockVendorResponses(prescriptionId);
        });
      } else {
        final mockRejectionReasons = [
          'The prescription image is too blurry and the text cannot be read clearly. Please upload a clearer photo.',
          'The prescription has expired. Please upload a current prescription dated within the last 6 months.',
          'Doctor\'s signature is missing or not clearly visible. A valid prescription must have a licensed doctor\'s signature.',
          'Patient name on the prescription does not match the account holder name. Please ensure the prescription is in your name.',
          'The prescription appears to be incomplete. Some medicine details and dosage information are not visible.',
        ];

        final rejectionReason =
            mockRejectionReasons[random.nextInt(mockRejectionReasons.length)];

        _prescriptions[prescriptionIndex] = _prescriptions[prescriptionIndex]
            .copyWith(
              status: PrescriptionStatus.invalid,
              notes: rejectionReason,
            );
      }
    }
  }

  void _generateMockVendorResponses(String prescriptionId) {
    final random = Random();

    final approvedVendor = {
      'id': 'vendor_${random.nextInt(3) + 1}',
      'name': [
        'HealthPlus Pharmacy',
        'MediCare Store',
        'WellCare Pharmacy',
      ][random.nextInt(3)],
    };

    final sampleMedicines = [
      {'name': 'Amoxicillin', 'brand': 'Amoxil', 'dosage': '500mg'},
      {'name': 'Metformin', 'brand': 'Glucophage', 'dosage': '850mg'},
      {'name': 'Lisinopril', 'brand': 'Prinivil', 'dosage': '10mg'},
      {'name': 'Atorvastatin', 'brand': 'Lipitor', 'dosage': '20mg'},
      {'name': 'Omeprazole', 'brand': 'Prilosec', 'dosage': '40mg'},
    ];

    final responses = <PrescriptionResponseModel>[];

    final numMedicines = random.nextInt(3) + 2;
    final medicines = <ProductModel>[];

    for (int j = 0; j < numMedicines; j++) {
      final medicineData =
          sampleMedicines[random.nextInt(sampleMedicines.length)];
      final medicine = ProductModel(
        id: 'med_${DateTime.now().millisecondsSinceEpoch}_$j',
        title: medicineData['name']!,
        description: medicineData['brand']!,
        price: ((random.nextDouble() * 50) + 5).toStringAsFixed(2),
        weight: medicineData['dosage'],
        vendorResponseId:
            'med_${DateTime.now().millisecondsSinceEpoch}_${j}_${random.nextInt(30) + 1}',
        categoryId: '3',
        subcategoryId: 'medicine_prescription',
        imagePath: 'assets/icons/medicine.png',
        rating: 4.5,
        isOTC: false,
        hasPrescriptionUploaded: true,
        productType: 'prescription_medicine',
        isPrescriptionMedicine: true,
        shopId: approvedVendor['id']!,
      );
      medicines.add(medicine);
    }

    final totalAmount = medicines.fold<double>(
      0.0,
      (sum, med) => sum + (med.medicinePrice * med.prescriptionQuantity),
    );

    final response = PrescriptionResponseModel(
      id: 'resp_${DateTime.now().millisecondsSinceEpoch}',
      prescriptionId: prescriptionId,
      vendorId: approvedVendor['id']!,
      vendorName: approvedVendor['name']!,
      medicines: medicines,
      totalAmount: totalAmount,
      status: VendorResponseStatus.approved,
      respondedAt: DateTime.now(),
      notes:
          'We can provide all medicines from your prescription. Please add them to your cart.',
    );

    responses.add(response);

    final prescriptionIndex = _prescriptions.indexWhere(
      (p) => p.id == prescriptionId,
    );
    if (prescriptionIndex != -1) {
      _prescriptions[prescriptionIndex] = _prescriptions[prescriptionIndex]
          .copyWith(
            status: PrescriptionStatus.medicinesReady,
            vendorResponses: responses,
          );
    }
  }
}
