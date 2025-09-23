// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
// import 'package:quikle_user/features/prescription/data/services/prescription_service.dart';
// import 'package:quikle_user/features/home/data/models/product_model.dart';
// import 'package:quikle_user/features/cart/controllers/cart_controller.dart';

// class PrescriptionController extends GetxController {
//   final PrescriptionService _prescriptionService = PrescriptionService();
//   final ImagePicker _imagePicker = ImagePicker();

//   final isUploading = false.obs;
//   final isLoading = false.obs;
//   final prescriptions = <PrescriptionModel>[].obs;
//   final prescriptionMedicines = <ProductModel>[].obs;
//   final recentPrescriptionMedicines = <ProductModel>[].obs;
//   final selectedPrescription = Rxn<PrescriptionModel>();

//   final uploadProgress = 0.0.obs;
//   final uploadNotes = ''.obs;

//   final prescriptionStats = <String, int>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadUserPrescriptions();
//     loadPrescriptionMedicines();
//     loadRecentPrescriptionMedicines();
//     loadPrescriptionStats();
//   }

//   Future<void> uploadFromCamera() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//         maxWidth: 1920,
//         maxHeight: 1080,
//       );

//       if (image != null) {
//         await _uploadPrescription(File(image.path));
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to capture image: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> uploadFromGallery() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//         maxWidth: 1920,
//         maxHeight: 1080,
//       );

//       if (image != null) {
//         await _uploadPrescription(File(image.path));
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to select image: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> _uploadPrescription(File imageFile) async {
//     try {
//       isUploading.value = true;
//       uploadProgress.value = 0.0;

//       for (int i = 0; i <= 100; i += 10) {
//         uploadProgress.value = i / 100.0;
//         await Future.delayed(const Duration(milliseconds: 100));
//       }

//       final prescription = await _prescriptionService.uploadPrescription(
//         userId: 'current_user_id',
//         imageFile: imageFile,
//         notes: uploadNotes.value.isEmpty ? null : uploadNotes.value,
//       );

//       prescriptions.insert(0, prescription);
//       uploadNotes.value = '';

//       // Get.snackbar(
//       //   'Success',
//       //   'Prescription uploaded successfully! Vendors will review it shortly.',
//       //   snackPosition: SnackPosition.BOTTOM,
//       //   duration: const Duration(seconds: 4),
//       // );

//       await Future.wait([
//         loadPrescriptionStats(),
//         loadRecentPrescriptionMedicines(),
//       ]);
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to upload prescription: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//     }
//   }

//   Future<void> loadUserPrescriptions() async {
//     try {
//       isLoading.value = true;
//       final userPrescriptions = await _prescriptionService.getUserPrescriptions(
//         'current_user_id',
//       );
//       prescriptions.value = userPrescriptions;
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load prescriptions: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadPrescriptionMedicines() async {
//     try {
//       final medicines = await _prescriptionService
//           .getPendingPrescriptionMedicines('current_user_id');
//       prescriptionMedicines.value = medicines;
//     } catch (e) {
//       print('Error loading prescription medicines: $e');
//     }
//   }

//   Future<void> loadRecentPrescriptionMedicines() async {
//     try {
//       final medicines = await _prescriptionService
//           .getRecentPrescriptionMedicines('current_user_id');
//       recentPrescriptionMedicines.value = medicines;
//     } catch (e) {
//       print('Error loading recent prescription medicines: $e');
//     }
//   }

//   Future<void> loadPrescriptionStats() async {
//     try {
//       final stats = await _prescriptionService.getPrescriptionStats(
//         'current_user_id',
//       );
//       prescriptionStats.value = stats;
//     } catch (e) {
//       print('Error loading prescription stats: $e');
//     }
//   }

//   void viewPrescriptionDetails(PrescriptionModel prescription) {
//     selectedPrescription.value = prescription;
//     Get.toNamed('/prescription-details', arguments: prescription);
//   }

//   Future<void> deletePrescription(String prescriptionId) async {
//     try {
//       final success = await _prescriptionService.deletePrescription(
//         prescriptionId,
//       );
//       if (success) {
//         prescriptions.removeWhere((p) => p.id == prescriptionId);
//         // Get.snackbar(
//         //   'Success',
//         //   'Prescription deleted successfully',
//         //   snackPosition: SnackPosition.BOTTOM,
//         // );
//         loadPrescriptionStats();
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to delete prescription: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   void addPrescriptionMedicineToCart(ProductModel medicine) {
//     try {
//       final cartController = Get.find<CartController>();
//       cartController.addToCart(medicine);
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to add medicine to cart: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   void addPrescriptionMedicineToCartWithQuantity(
//     ProductModel medicine,
//     int quantity,
//   ) {
//     try {
//       final cartController = Get.find<CartController>();

//       for (int i = 0; i < quantity; i++) {
//         cartController.addToCart(medicine);
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to add medicine to cart: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> acceptVendorResponse(PrescriptionResponseModel response) async {
//     try {
//       final success = await _prescriptionService.acceptVendorResponse(
//         response.id,
//       );
//       if (success) {
//         for (final medicine in response.medicines) {
//           if (medicine.isMedicineAvailable) {
//             final product = ProductModel(
//               id: 'presc_med_${medicine.id}',
//               title: '${medicine.brandName} ${medicine.medicineName}',
//               description: '${medicine.dosage} - Prescription Medicine',
//               price: medicine.medicinePrice.toStringAsFixed(2),
//               imagePath: 'assets/icons/medicine.png',
//               categoryId: '3',
//               subcategoryId: 'medicine_prescription',
//               shopId: response.vendorId,
//               rating: 4.5,
//               weight: '${medicine.prescriptionQuantity} units',
//               isOTC: false,
//               hasPrescriptionUploaded: true,
//               productType: 'prescription_medicine',
//             );

//             addPrescriptionMedicineToCartWithQuantity(
//               product,
//               medicine.prescriptionQuantity,
//             );
//           }
//         }
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to accept vendor response: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> refreshData() async {
//     await Future.wait([
//       loadUserPrescriptions(),
//       loadPrescriptionMedicines(),
//       loadRecentPrescriptionMedicines(),
//       loadPrescriptionStats(),
//     ]);
//   }

//   void setUploadNotes(String notes) {
//     uploadNotes.value = notes;
//   }

//   void showUploadOptions() {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Upload Prescription',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Take Photo'),
//               onTap: () {
//                 Get.back();
//                 uploadFromCamera();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Get.back();
//                 uploadFromGallery();
//               },
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/features/prescription/data/services/prescription_service.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';

class PrescriptionController extends GetxController {
  final PrescriptionService _prescriptionService = PrescriptionService();
  final ImagePicker _imagePicker = ImagePicker();

  final isUploading = false.obs;
  final isLoading = false.obs;
  final prescriptions = <PrescriptionModel>[].obs;
  final prescriptionMedicines = <ProductModel>[].obs;
  final recentPrescriptionMedicines = <ProductModel>[].obs;
  final selectedPrescription = Rxn<PrescriptionModel>();

  final uploadProgress = 0.0.obs;
  final uploadNotes = ''.obs;

  final prescriptionStats = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserPrescriptions();
    loadPrescriptionMedicines();
    loadRecentPrescriptionMedicines();
    loadPrescriptionStats();
  }

  Future<void> uploadFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        await _uploadPrescription(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> uploadFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        await _uploadPrescription(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// NEW: Upload from Files (PDF or Image)
  Future<void> uploadFromFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'webp'],
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.first;
        if (picked.path != null) {
          await _uploadPrescription(File(picked.path!));
        } else {
          Get.snackbar(
            'Error',
            'Could not read the selected file.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _uploadPrescription(File imageFile) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Fake client-side progress
      for (int i = 0; i <= 100; i += 10) {
        uploadProgress.value = i / 100.0;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final prescription = await _prescriptionService.uploadPrescription(
        userId: 'current_user_id',
        imageFile: imageFile, // supports image or PDF
        notes: uploadNotes.value.isEmpty ? null : uploadNotes.value,
      );

      prescriptions.insert(0, prescription);
      uploadNotes.value = '';

      await Future.wait([
        loadPrescriptionStats(),
        loadRecentPrescriptionMedicines(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload prescription: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  Future<void> loadUserPrescriptions() async {
    try {
      isLoading.value = true;
      final userPrescriptions = await _prescriptionService.getUserPrescriptions(
        'current_user_id',
      );
      prescriptions.value = userPrescriptions;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load prescriptions: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPrescriptionMedicines() async {
    try {
      final medicines = await _prescriptionService
          .getPendingPrescriptionMedicines('current_user_id');
      prescriptionMedicines.value = medicines;
    } catch (e) {
      // ignore for mock
    }
  }

  Future<void> loadRecentPrescriptionMedicines() async {
    try {
      final medicines = await _prescriptionService
          .getRecentPrescriptionMedicines('current_user_id');
      recentPrescriptionMedicines.value = medicines;
    } catch (e) {
      // ignore for mock
    }
  }

  Future<void> loadPrescriptionStats() async {
    try {
      final stats = await _prescriptionService.getPrescriptionStats(
        'current_user_id',
      );
      prescriptionStats.value = stats;
    } catch (e) {
      // ignore for mock
    }
  }

  void viewPrescriptionDetails(PrescriptionModel prescription) {
    selectedPrescription.value = prescription;
    Get.toNamed('/prescription-details', arguments: prescription);
  }

  Future<void> deletePrescription(String prescriptionId) async {
    try {
      final success = await _prescriptionService.deletePrescription(
        prescriptionId,
      );
      if (success) {
        prescriptions.removeWhere((p) => p.id == prescriptionId);
        loadPrescriptionStats();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete prescription: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addPrescriptionMedicineToCart(ProductModel medicine) {
    try {
      final cartController = Get.find<CartController>();
      cartController.addToCart(medicine);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add medicine to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addPrescriptionMedicineToCartWithQuantity(
    ProductModel medicine,
    int quantity,
  ) {
    try {
      final cartController = Get.find<CartController>();
      for (int i = 0; i < quantity; i++) {
        cartController.addToCart(medicine);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add medicine to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> acceptVendorResponse(PrescriptionResponseModel response) async {
    try {
      final success = await _prescriptionService.acceptVendorResponse(
        response.id,
      );
      if (success) {
        for (final medicine in response.medicines) {
          if (medicine.isMedicineAvailable) {
            final product = ProductModel(
              id: 'presc_med_${medicine.id}',
              title: '${medicine.brandName} ${medicine.medicineName}',
              description: '${medicine.dosage} - Prescription Medicine',
              price: medicine.medicinePrice.toStringAsFixed(2),
              imagePath: 'assets/icons/medicine.png',
              categoryId: '3',
              subcategoryId: 'medicine_prescription',
              shopId: response.vendorId,
              rating: 4.5,
              weight: '${medicine.prescriptionQuantity} units',
              isOTC: false,
              hasPrescriptionUploaded: true,
              productType: 'prescription_medicine',
            );

            addPrescriptionMedicineToCartWithQuantity(
              product,
              medicine.prescriptionQuantity,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to accept vendor response: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadUserPrescriptions(),
      loadPrescriptionMedicines(),
      loadRecentPrescriptionMedicines(),
      loadPrescriptionStats(),
    ]);
  }

  void setUploadNotes(String notes) {
    uploadNotes.value = notes;
  }

  void showUploadOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload Prescription',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                uploadFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                uploadFromGallery();
              },
            ),
            // NEW: Files (PDF/Image)
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Upload from Files (PDF/Image)'),
              subtitle: const Text('Select a PDF or image from device storage'),
              onTap: () {
                Get.back();
                uploadFromFiles();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
