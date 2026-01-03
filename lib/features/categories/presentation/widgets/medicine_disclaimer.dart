import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kMedicineDisclaimerPrefKey = 'medicine_disclaimer_shown_at';

/// A glassy disclaimer dialog for Medicine category.
class MedicineDisclaimerDialog extends StatefulWidget {
  const MedicineDisclaimerDialog({super.key});

  @override
  State<MedicineDisclaimerDialog> createState() =>
      _MedicineDisclaimerDialogState();
}

class _MedicineDisclaimerDialogState extends State<MedicineDisclaimerDialog> {
  bool _dontShowFor7Days = false;

  Future<void> _onGotIt() async {
    if (_dontShowFor7Days) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _kMedicineDisclaimerPrefKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.white.withValues(alpha: .6),
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.beakYellow,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Disclaimer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.beakYellow,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: const Text(
                                'Medicine',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.yellow[50]!.withOpacity(0.4),
                            Colors.amber[100]!.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.yellow[200]!.withOpacity(0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• Prescription may be required for certain medicines. Orders will be fulfilled only after pharmacy verification.',
                            style: TextStyle(fontSize: 13.sp, height: 1.5),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '• Quikle connects customers with licensed pharmacies. Medicines are dispensed by partner pharmacies as per applicable laws.',
                            style: TextStyle(fontSize: 13.sp, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Checkbox(
                      value: _dontShowFor7Days,
                      activeColor: AppColors.beakYellow,
                      onChanged: (v) =>
                          setState(() => _dontShowFor7Days = v ?? false),
                    ),
                    const Expanded(child: Text("Don't show this for 7 days")),
                  ],
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: _onGotIt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.beakYellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    elevation: 2,
                    side: BorderSide.none,
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper to check whether we should show the disclaimer.
Future<bool> shouldShowMedicineDisclaimer() async {
  final prefs = await SharedPreferences.getInstance();
  final shownAt = prefs.getInt(_kMedicineDisclaimerPrefKey);
  if (shownAt == null) return true;
  final shownDate = DateTime.fromMillisecondsSinceEpoch(shownAt);
  final diff = DateTime.now().difference(shownDate);
  return diff.inDays >= 7 ? true : false;
}
