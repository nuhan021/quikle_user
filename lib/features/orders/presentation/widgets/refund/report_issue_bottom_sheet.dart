import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/data/models/refund/issue_report_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

/// Bottom sheet for reporting order issues
class ReportIssueBottomSheet extends StatefulWidget {
  final OrderModel order;

  const ReportIssueBottomSheet({super.key, required this.order});

  @override
  State<ReportIssueBottomSheet> createState() => _ReportIssueBottomSheetState();
}

class _ReportIssueBottomSheetState extends State<ReportIssueBottomSheet> {
  final RefundController _refundController = Get.find<RefundController>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  IssueType? _selectedIssueType;
  String? _selectedPhotoPath;

  @override
  void dispose() {
    _descriptionController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  bool get _needsPhoto {
    return _selectedIssueType == IssueType.missingItem ||
        _selectedIssueType == IssueType.wrongItem ||
        _selectedIssueType == IssueType.damagedItem;
  }

  bool get _needsTransactionId {
    return _selectedIssueType == IssueType.paymentIssue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Report an Issue',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Issue type selection
              Text(
                'What\'s the issue?',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: IssueType.values.map((type) {
                  final isSelected = _selectedIssueType == type;
                  return ChoiceChip(
                    label: Text(type.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIssueType = selected ? type : null;
                        // Clear photo if not needed
                        if (!_needsPhoto) _selectedPhotoPath = null;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.h),

              // Photo upload (conditional)
              if (_needsPhoto) ...[
                Text(
                  'Upload photo (optional but recommended)',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedPhotoPath != null
                        ? Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 40.sp,
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedPhotoPath = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey.shade600,
                                size: 32.sp,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Tap to upload photo',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              // Transaction ID (conditional)
              if (_needsTransactionId) ...[
                Text(
                  'Transaction ID (optional)',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    hintText: 'Enter transaction ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              // Additional description
              Text(
                'Additional details (optional)',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe the issue...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Submit button
              Obx(() {
                final isSubmitting = _refundController.isSubmittingIssue;
                return SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _selectedIssueType == null || isSubmitting
                        ? null
                        : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Submit Issue',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedPhotoPath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedIssueType == null) return;

    // Upload photo if present
    String? photoUrl;
    if (_selectedPhotoPath != null) {
      photoUrl = await _refundController.uploadIssuePhoto(_selectedPhotoPath!);
    }

    final report = IssueReport(
      orderId: widget.order.orderId,
      issueType: _selectedIssueType!,
      customDescription: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      photoUrl: photoUrl,
      transactionId: _transactionIdController.text.trim().isEmpty
          ? null
          : _transactionIdController.text.trim(),
      createdAt: DateTime.now(),
    );

    final result = await _refundController.submitIssueReport(report: report);

    if (result != null) {
      Get.back(result: result); // Close and return result
    }
  }
}
