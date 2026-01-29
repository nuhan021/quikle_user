import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_user/features/profile/help_support/data/models/faq_model.dart';
import 'package:quikle_user/features/profile/help_support/data/models/support_ticket_model.dart';
import 'package:quikle_user/features/profile/help_support/data/services/help_support_service.dart';

class HelpSupportController extends GetxController {
  final HelpSupportService _helpSupportService = Get.find<HelpSupportService>();
  final ImagePicker _picker = ImagePicker();

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedIssueType = Rx<SupportIssueType?>(null);
  final attachmentPath = RxString('');
  final attachmentFile = Rx<XFile?>(null);
  final isSubmitting = RxBool(false);
  final faqs = <FaqModel>[].obs;
  final recentTickets = <SupportTicketModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void loadData() {
    faqs.value = _helpSupportService.getFaqs();
    recentTickets.value = _helpSupportService.getRecentSupportHistory();
  }

  void toggleFaqExpansion(int index) {
    final updatedFaqs = List<FaqModel>.from(faqs);
    updatedFaqs[index] = updatedFaqs[index].copyWith(
      isExpanded: !updatedFaqs[index].isExpanded,
    );
    faqs.value = updatedFaqs;
  }

  void selectIssueType(SupportIssueType issueType) {
    selectedIssueType.value = issueType;
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickImageFromCamera();
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 50, color: Colors.blue),
                      SizedBox(height: 8),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickAttachment();
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.photo_library, size: 50, color: Colors.green),
                      SizedBox(height: 8),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        attachmentFile.value = pickedFile;

        final uploadedUrl = await _helpSupportService.uploadAttachment(
          pickedFile.path,
        );

        if (uploadedUrl != null) {
          attachmentPath.value = uploadedUrl;
          Get.snackbar(
            'Success',
            'Photo captured and uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to upload photo',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickAttachment() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        attachmentFile.value = pickedFile;

        final uploadedUrl = await _helpSupportService.uploadAttachment(
          pickedFile.path,
        );

        if (uploadedUrl != null) {
          attachmentPath.value = uploadedUrl;
          Get.snackbar(
            'Success',
            'Image uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to upload image',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeAttachment() {
    attachmentPath.value = '';
    attachmentFile.value = null;
  }

  Future<void> submitSupportTicket() async {
    if (!_validateForm()) return;

    isSubmitting.value = true;

    try {
      final success = await _helpSupportService.submitSupportTicket(
        issueType: selectedIssueType.value!,
        description: descriptionController.text,
        attachmentPath: attachmentPath.value.isEmpty
            ? null
            : attachmentPath.value,
      );

      if (success) {
        _clearForm();
        Get.snackbar(
          'Success',
          'Your support ticket has been submitted successfully. We\'ll get back to you soon.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        recentTickets.value = _helpSupportService.getRecentSupportHistory();
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit support ticket. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _validateForm() {
    if (selectedIssueType.value == null) {
      Get.snackbar(
        'Error',
        'Please select an issue type',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide a description of your issue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void _clearForm() {
    subjectController.clear();
    descriptionController.clear();
    selectedIssueType.value = null;
    attachmentPath.value = '';
    attachmentFile.value = null;
  }

  List<DropdownMenuItem<SupportIssueType>> get issueTypeOptions {
    return SupportIssueType.values.map((type) {
      return DropdownMenuItem<SupportIssueType>(
        value: type,
        child: Text(type.label),
      );
    }).toList();
  }
}
