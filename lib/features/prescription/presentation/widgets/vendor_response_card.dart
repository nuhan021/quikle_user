import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class VendorResponseCard extends StatefulWidget {
  final PrescriptionResponseModel response;
  final PrescriptionController controller;
  final Function(GlobalKey, String)? onCartAnimation;

  const VendorResponseCard({
    super.key,
    required this.response,
    required this.controller,
    this.onCartAnimation,
  });

  @override
  State<VendorResponseCard> createState() => _VendorResponseCardState();
}

class _VendorResponseCardState extends State<VendorResponseCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  TextStyle _labelStyle({
    required double size,
    required FontWeight weight,
    required Color color,
  }) => getTextStyle(
    font: CustomFonts.inter,
    fontSize: size,
    fontWeight: weight,
    color: color,
  );

  Widget _modernChip(String text, {Color? bg, Color? fg, IconData? icon}) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg ?? Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: (bg ?? Colors.grey.shade50).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: fg ?? Colors.grey.shade700),
            SizedBox(width: 4.w),
          ],
          Text(
            text,
            style: _labelStyle(
              size: 11.sp,
              weight: FontWeight.w600,
              color: fg ?? Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addAllKey = GlobalKey();
    final meds = widget.response.medicines;
    final availableMeds = meds.where((m) => m.isMedicineAvailable).length;

    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.local_pharmacy_rounded,
                        color: Colors.blue.shade700,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.response.vendorName,
                            style: _labelStyle(
                              size: 16.sp,
                              weight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Icons.verified,
                                size: 14.sp,
                                color: Colors.green.shade600,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Verified Pharmacy',
                                style: _labelStyle(
                                  size: 11.sp,
                                  weight: FontWeight.w500,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      key: addAllKey,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.onCartAnimation != null) {
                            widget.onCartAnimation!(
                              addAllKey,
                              ImagePath.medicineIcon,
                            );
                          }
                          widget.controller.acceptVendorResponse(
                            widget.response,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ImagePath.cartIcon,
                              width: 16.w,
                              height: 16.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Add All',
                              style: _labelStyle(
                                size: 12.sp,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.response.totalAmount > 0) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '\$${widget.response.totalAmount.toStringAsFixed(2)}',
                              style: _labelStyle(
                                size: 18.sp,
                                weight: FontWeight.w700,
                                color: Colors.green.shade700,
                              ),
                            ),
                            Text(
                              'Total Amount',
                              style: _labelStyle(
                                size: 10.sp,
                                weight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 30.h,
                          color: Colors.grey.shade300,
                        ),
                        Column(
                          children: [
                            Text(
                              '$availableMeds/${meds.length}',
                              style: _labelStyle(
                                size: 18.sp,
                                weight: FontWeight.w700,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            Text(
                              'Available',
                              style: _labelStyle(
                                size: 10.sp,
                                weight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => _isExpanded = !_isExpanded);
                    if (_isExpanded) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medical_services_rounded,
                          color: Colors.blue.shade600,
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'Medicines (${meds.length} items)',
                            style: _labelStyle(
                              size: 14.sp,
                              weight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.blue.shade600,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      ...meds.asMap().entries.map((entry) {
                        final index = entry.key;
                        final medicine = entry.value;
                        final medicineKey = GlobalKey();

                        return Container(
                          key: medicineKey,
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: medicine.isMedicineAvailable
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: medicine.isMedicineAvailable
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: medicine.isMedicineAvailable
                                        ? Icon(
                                            Icons.medication_liquid_rounded,
                                            color: Colors.green.shade600,
                                            size: 20.sp,
                                          )
                                        : Icon(
                                            Icons.close_rounded,
                                            color: Colors.red.shade600,
                                            size: 20.sp,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medicine.medicineName,
                                        style: _labelStyle(
                                          size: 14.sp,
                                          weight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 6.h),
                                      Wrap(
                                        spacing: 6.w,
                                        runSpacing: 4.h,
                                        children: [
                                          if (medicine.dosage.isNotEmpty)
                                            _modernChip(
                                              medicine.dosage,
                                              bg: Colors.orange.shade50,
                                              fg: Colors.orange.shade700,
                                              icon: Icons.schedule_rounded,
                                            ),
                                          _modernChip(
                                            'Qty: ${medicine.prescriptionQuantity}',
                                            bg: Colors.blue.shade50,
                                            fg: Colors.blue.shade700,
                                            icon: Icons.numbers_rounded,
                                          ),
                                          if (medicine.medicinePrice > 0)
                                            _modernChip(
                                              '\$${medicine.medicinePrice.toStringAsFixed(2)}',
                                              bg: Colors.green.shade50,
                                              fg: Colors.green.shade700,
                                              icon: Icons.attach_money_rounded,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                if (medicine.isMedicineAvailable)
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (widget.onCartAnimation != null) {
                                          widget.onCartAnimation!(
                                            medicineKey,
                                            medicine.imagePath,
                                          );
                                        }
                                        widget.controller
                                            .addPrescriptionMedicineToCartWithQuantity(
                                              medicine.copyWithPrescriptionData(
                                                quantity: medicine
                                                    .prescriptionQuantity,
                                              ),
                                              medicine.prescriptionQuantity,
                                            );
                                      },
                                      style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor:
                                                Colors.transparent,
                                            elevation: 0,
                                            padding: EdgeInsets.all(8.w),
                                            minimumSize: Size(40.w, 40.w),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ).copyWith(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                            side: MaterialStateProperty.all(
                                              BorderSide.none,
                                            ),
                                          ),
                                      child: Image.asset(
                                        ImagePath.cartIcon,
                                        width: 24.w,
                                        height: 24.w,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      'Out of Stock',
                                      style: _labelStyle(
                                        size: 10.sp,
                                        weight: FontWeight.w600,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
