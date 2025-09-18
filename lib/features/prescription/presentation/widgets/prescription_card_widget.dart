
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/vendor_response_card.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_header_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_status_widget.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final PrescriptionModel prescription;
  final PrescriptionController controller;
  final Function(GlobalKey, String)? onCartAnimation;

  const PrescriptionCardWidget({
    super.key,
    required this.prescription,
    required this.controller,
    this.onCartAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          PrescriptionHeaderWidget(
            prescription: prescription,
            onDelete: () => _showDeleteDialog(context),
            onViewDetails: () =>
                Get.toNamed('/prescription-details', arguments: prescription),
          ),

          
          if (prescription.notes?.isNotEmpty == true)
            PrescriptionStatusWidget(
              notes: prescription.notes!,
              status: prescription.status,
            ),

          
          if (prescription.vendorResponses.isNotEmpty) ...[
            Divider(color: Colors.grey.shade200, height: 1),
            ...prescription.vendorResponses.map((response) {
              if (response.status != VendorResponseStatus.approved &&
                  response.status != VendorResponseStatus.partiallyApproved) {
                return const SizedBox.shrink();
              }

              return VendorResponseCard(
                response: response,
                controller: controller,
                onCartAnimation: onCartAnimation,
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Prescription'),
        content: const Text(
          'Are you sure you want to delete this prescription? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePrescription(prescription.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
