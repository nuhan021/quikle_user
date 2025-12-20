import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';

class PrescriptionService {
  // In-memory mock store
  static final List<PrescriptionModel> _prescriptions = [];
  final NetworkCaller _networkCaller = NetworkCaller();

  // ---------- Helpers ----------
  String _inferMime(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.pdf')) return 'application/pdf';
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.jpg') || p.endsWith('.jpeg')) return 'image/jpeg';
    if (p.endsWith('.heic')) return 'image/heic';
    if (p.endsWith('.webp')) return 'image/webp';
    return 'application/octet-stream';
  }

  // ---------- Public API ----------
  Future<PrescriptionModel> uploadPrescription({
    required String userId,
    required File imageFile, // can be image OR pdf
    String? notes,
  }) async {
    try {
      final token = StorageService.token;
      final mime = _inferMime(imageFile.path);
      final fileName = imageFile.path.split('/').last;

      // Create multipart file
      final multipartFile = await http.MultipartFile.fromPath(
        'image_path',
        imageFile.path,
        contentType: MediaType.parse(mime),
      );

      // Make API call
      final response = await _networkCaller.multipartRequest(
        ApiConstants.uploadPrescription,
        files: [multipartFile],
        token: 'Bearer $token',
      );

      if (!response.isSuccess || response.responseData == null) {
        throw Exception(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to upload prescription',
        );
      }

      // Parse response
      final data = response.responseData;
      final prescription = PrescriptionModel(
        id: data['id'].toString(),
        userId: data['user_id'].toString(),
        imagePath: data['image_path'] as String,
        fileName: data['file_name'] as String? ?? fileName,
        uploadedAt: DateTime.parse(data['uploaded_at'] as String),
        status: _parseStatus(data['status'] as String),
        notes: data['notes'] as String?,
        vendorResponses: [],
      );

      _prescriptions.add(prescription);

      return prescription;
    } catch (e) {
      throw Exception('Failed to upload prescription: $e');
    }
  }

  PrescriptionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'uploaded':
        return PrescriptionStatus.uploaded;
      case 'under_review':
      case 'underreview':
        return PrescriptionStatus.underReview;
      case 'valid':
        return PrescriptionStatus.valid;
      case 'invalid':
        return PrescriptionStatus.invalid;
      case 'medicines_ready':
      case 'medicinesready':
        return PrescriptionStatus.medicinesReady;
      default:
        return PrescriptionStatus.uploaded;
    }
  }

  Future<List<PrescriptionModel>> getUserPrescriptions(String userId) async {
    try {
      final token = StorageService.token;

      // Fetch from API
      final response = await _networkCaller.getRequest(
        ApiConstants.getPrescriptions,
        token: 'Bearer $token',
      );

      print('getUserPrescriptions response: ${response.isSuccess}');
      print('getUserPrescriptions data: ${response.responseData}');

      if (response.isSuccess && response.responseData != null) {
        // Clear local storage and repopulate from API
        _prescriptions.clear();

        final List<dynamic> data = response.responseData as List<dynamic>;
        print('Number of prescriptions from API: ${data.length}');

        for (var item in data) {
          final prescription = PrescriptionModel(
            id: item['id'].toString(),
            userId: item['user_id'].toString(),
            imagePath: item['image_path'] as String,
            fileName: item['file_name'] as String? ?? '',
            uploadedAt: DateTime.parse(item['uploaded_at'] as String),
            status: _parseStatus(item['status'] as String),
            notes: item['notes'] as String?,
            vendorResponses: [],
          );
          _prescriptions.add(prescription);
          print('Added prescription: ${prescription.id}');
        }
      }

      print('Total prescriptions in list: ${_prescriptions.length}');

      // Return sorted by upload date
      return _prescriptions.where((p) => p.userId == userId).toList()
        ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    } catch (e) {
      print('Error in getUserPrescriptions: $e');
      // If API fails, return local data
      return _prescriptions.where((p) => p.userId == userId).toList()
        ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    }
  }

  Future<PrescriptionModel?> getPrescriptionById(String prescriptionId) async {
    try {
      final token = StorageService.token;

      // Fetch from API
      final url = ApiConstants.getPrescriptionById.replaceAll(
        '{id}',
        prescriptionId,
      );
      final response = await _networkCaller.getRequest(
        url,
        token: 'Bearer $token',
      );

      if (response.isSuccess && response.responseData != null) {
        final item = response.responseData;

        // Parse vendor responses
        final vendorResponsesList = <PrescriptionResponseModel>[];
        if (item['vendor_responses'] != null) {
          final responses = item['vendor_responses'] as List<dynamic>;
          for (var vendorResp in responses) {
            // Parse medicines
            final medicinesList = <ProductModel>[];
            if (vendorResp['medicines'] != null) {
              final medicines = vendorResp['medicines'] as List<dynamic>;
              for (var med in medicines) {
                final medicine = ProductModel(
                  id: med['id'].toString(),
                  title: med['name'] as String,
                  description: med['brand'] as String,
                  price: med['price'].toString(),
                  imagePath: med['image_path'] as String? ?? ImagePath.vitaminC,
                  categoryId: '3',
                  subcategoryId: 'medicine_prescription',
                  shopId: med['vendor_id'].toString(),
                  rating: 4.5,
                  weight: med['dosage'] as String?,
                  isOTC: false,
                  hasPrescriptionUploaded: true,
                  productType: 'prescription_medicine',
                  isPrescriptionMedicine: true,
                  prescriptionId: prescriptionId,
                  vendorResponseId: 'med_${med['id']}_${med['quantity'] ?? 1}',
                );
                medicinesList.add(medicine);
              }
            }

            final vendorResponse = PrescriptionResponseModel(
              id: vendorResp['id'].toString(),
              prescriptionId: vendorResp['prescription_id'].toString(),
              vendorId: vendorResp['vendor_id'].toString(),
              vendorName: vendorResp['vendor_name'] as String,
              medicines: medicinesList,
              totalAmount:
                  double.tryParse(vendorResp['total_amount'].toString()) ?? 0.0,
              status: _parseVendorStatus(vendorResp['status'] as String),
              respondedAt: DateTime.parse(vendorResp['responded_at'] as String),
              notes: vendorResp['notes'] as String?,
            );
            vendorResponsesList.add(vendorResponse);
          }
        }

        final prescription = PrescriptionModel(
          id: item['id'].toString(),
          userId: item['user_id'].toString(),
          imagePath: item['image_path'] as String,
          fileName: item['file_name'] as String? ?? '',
          uploadedAt: DateTime.parse(item['uploaded_at'] as String),
          status: _parseStatus(item['status'] as String),
          notes: item['notes'] as String?,
          vendorResponses: vendorResponsesList,
        );

        // Update local cache
        final index = _prescriptions.indexWhere((p) => p.id == prescriptionId);
        if (index != -1) {
          _prescriptions[index] = prescription;
        } else {
          _prescriptions.add(prescription);
        }

        return prescription;
      }

      // Fallback to local data if API fails
      return _prescriptions.firstWhere((p) => p.id == prescriptionId);
    } catch (_) {
      // Return local data if available
      try {
        return _prescriptions.firstWhere((p) => p.id == prescriptionId);
      } catch (_) {
        return null;
      }
    }
  }

  VendorResponseStatus _parseVendorStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return VendorResponseStatus.pending;
      case 'approved':
        return VendorResponseStatus.approved;
      case 'partially_approved':
      case 'partiallyapproved':
        return VendorResponseStatus.partiallyApproved;
      case 'rejected':
        return VendorResponseStatus.rejected;
      case 'expired':
        return VendorResponseStatus.expired;
      case 'medicinesready':
      case 'medicines_ready':
        return VendorResponseStatus.approved;
      default:
        return VendorResponseStatus.pending;
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
                  imagePath: ImagePath.vitaminC,
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
                imagePath: ImagePath.vitaminC,
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
    try {
      final token = StorageService.token;

      // Make API call to delete
      final url = ApiConstants.deletePrescription.replaceAll(
        '{id}',
        prescriptionId,
      );

      AppLoggerHelper.debug('Deleting prescription at URL: $url');

      final response = await _networkCaller.deleteRequest(
        url,
        token: 'Bearer $token',
      );

      AppLoggerHelper.debug(
        'Delete prescription response: ${response.responseData}, ${response.statusCode}',
      );

      if (!response.isSuccess) {
        throw Exception(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to delete prescription',
        );
      }

      // Remove from local cache
      _prescriptions.removeWhere((p) => p.id == prescriptionId);

      return true;
    } catch (e) {
      throw Exception('Failed to delete prescription: $e');
    }
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
