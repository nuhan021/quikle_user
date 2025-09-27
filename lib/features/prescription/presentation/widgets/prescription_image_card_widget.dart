// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quikle_user/core/common/styles/global_text_style.dart';
// import 'package:quikle_user/core/utils/constants/colors.dart';
// import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
// import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

// class PrescriptionImageCardWidget extends StatelessWidget {
//   final PrescriptionModel prescription;

//   const PrescriptionImageCardWidget({super.key, required this.prescription});

//   bool _isRemote(String p) =>
//       p.startsWith('http://') || p.startsWith('https://');

//   bool _isLocal(String p) {
//     try {
//       final normalized = _normalizeLocalPath(p);
//       return File(normalized).existsSync();
//     } catch (e) {
//       return false;
//     }
//   }

//   String _normalizeLocalPath(String p) {
//     if (p.startsWith('file://')) return p.replaceFirst('file://', '');
//     return p;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Row(
//               children: [
//                 Icon(Icons.image, color: Colors.blue.shade600, size: 20.sp),
//                 SizedBox(width: 8.w),
//                 Text(
//                   'Prescription Image',
//                   style: getTextStyle(
//                     font: CustomFonts.inter,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 200.h,
//             margin: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(8.r),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8.r),
//               child: prescription.imagePath.isNotEmpty
//                   ? GestureDetector(
//                       onTap: () =>
//                           _showImagePreview(context, prescription.imagePath),
//                       child: _buildImageWidget(prescription.imagePath),
//                     )
//                   : _buildNoImageWidget(),
//             ),
//           ),
//           SizedBox(height: 16.h),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageWidget(String imagePath) {
//     if (_isRemote(imagePath)) {
//       return Image.network(
//         imagePath,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//         gaplessPlayback: true,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Container(
//             color: Colors.grey.shade100,
//             child: Center(
//               child: CircularProgressIndicator(
//                 value: loadingProgress.expectedTotalBytes != null
//                     ? loadingProgress.cumulativeBytesLoaded /
//                           loadingProgress.expectedTotalBytes!
//                     : null,
//               ),
//             ),
//           );
//         },
//         errorBuilder: (context, error, stackTrace) => _buildImageError(),
//       );
//     } else if (_isLocal(imagePath)) {
//       final path = _normalizeLocalPath(imagePath);
//       return Image.file(
//         File(path),
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//         errorBuilder: (context, error, stackTrace) => _buildImageError(),
//       );
//     } else {
//       return Image.asset(
//         imagePath,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//         errorBuilder: (context, error, stackTrace) => _buildImageError(),
//       );
//     }
//   }

//   Widget _buildNoImageWidget() {
//     return Container(
//       color: Colors.grey.shade50,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.image_not_supported_outlined,
//             size: 48.sp,
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'No prescription image',
//             style: getTextStyle(
//               font: CustomFonts.inter,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageError() {
//     return Container(
//       color: Colors.grey.shade50,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.broken_image_outlined,
//             size: 48.sp,
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'Image not available',
//             style: getTextStyle(
//               font: CustomFonts.inter,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             'Tap to retry',
//             style: getTextStyle(
//               font: CustomFonts.inter,
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w400,
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showImagePreview(BuildContext context, String imagePath) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.black,
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(child: _buildPreviewImage(imagePath)),
//             ),
//             Positioned(
//               top: 40.h,
//               right: 20.w,
//               child: IconButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPreviewImage(String imagePath) {
//     if (_isRemote(imagePath)) {
//       return Image.network(
//         imagePath,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => _buildPreviewError(),
//       );
//     } else if (_isLocal(imagePath)) {
//       final path = _normalizeLocalPath(imagePath);
//       return Image.file(
//         File(path),
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => _buildPreviewError(),
//       );
//     } else {
//       return Image.asset(
//         imagePath,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => _buildPreviewError(),
//       );
//     }
//   }

//   Widget _buildPreviewError() {
//     return Container(
//       padding: EdgeInsets.all(32.w),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
//           SizedBox(height: 16.h),
//           Text(
//             'Failed to load image',
//             style: getTextStyle(
//               font: CustomFonts.inter,
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class PrescriptionImageCardWidget extends StatelessWidget {
  final PrescriptionModel prescription;

  const PrescriptionImageCardWidget({super.key, required this.prescription});

  bool _isRemote(String pth) =>
      pth.startsWith('http://') || pth.startsWith('https://');

  bool _isPdf(String pth) => p.extension(pth).toLowerCase() == '.pdf';

  bool _isLocalExisting(String pth) {
    try {
      final normalized = _normalizeLocalPath(pth);
      return File(normalized).existsSync();
    } catch (_) {
      return false;
    }
  }

  String _normalizeLocalPath(String pth) {
    if (pth.startsWith('file://')) return pth.replaceFirst('file://', '');
    return pth;
  }

  void _openWithSystemViewer(String path) async {
    final normalized = _normalizeLocalPath(path);
    await OpenFilex.open(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = _isPdf(prescription.imagePath);
    final title = isPdf ? 'Prescription File (PDF)' : 'Prescription Image';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  isPdf ? Icons.picture_as_pdf : Icons.image,
                  color: isPdf ? Colors.red.shade600 : Colors.blue.shade600,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                // Small type-badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isPdf ? Colors.red.shade50 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isPdf ? Colors.red.shade200 : Colors.blue.shade200,
                    ),
                  ),
                  child: Text(
                    isPdf ? 'PDF' : 'Image',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isPdf ? Colors.red.shade700 : Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Container(
            width: double.infinity,
            height: 200.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: prescription.imagePath.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (isPdf) {
                          // Open with system viewer
                          _openWithSystemViewer(prescription.imagePath);
                        } else {
                          _showImagePreview(context, prescription.imagePath);
                        }
                      },
                      child: isPdf
                          ? _buildPdfCard(context, prescription)
                          : _buildImageWidget(prescription.imagePath),
                    )
                  : _buildNoFileWidget(isPdf),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // ---------- Image handling ----------
  Widget _buildImageWidget(String imagePath) {
    if (_isRemote(imagePath)) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade100,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildImageError(isPdf: false),
      );
    } else if (_isLocalExisting(imagePath)) {
      final path = _normalizeLocalPath(imagePath);
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            _buildImageError(isPdf: false),
      );
    } else {
      // Try asset as a last resort
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            _buildImageError(isPdf: false),
      );
    }
  }

  // ---------- PDF handling ----------
  Widget _buildPdfCard(BuildContext context, PrescriptionModel pModel) {
    final fileName = pModel.fileName.isNotEmpty
        ? pModel.fileName
        : p.basename(pModel.imagePath);
    final exists = _isLocalExisting(pModel.imagePath);

    return Container(
      padding: EdgeInsets.all(12.w),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: Colors.red.shade600,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  exists ? 'Tap to open' : 'Remote/invalid file path',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: exists ? Colors.grey.shade600 : Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new, color: Colors.grey.shade700, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildNoFileWidget(bool isPdf) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPdf ? Icons.picture_as_pdf : Icons.image_not_supported_outlined,
            size: 48.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 8.h),
          Text(
            isPdf ? 'No prescription file' : 'No prescription image',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError({required bool isPdf}) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPdf ? Icons.picture_as_pdf : Icons.broken_image_outlined,
            size: 48.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 8.h),
          Text(
            isPdf ? 'PDF not available' : 'Image not available',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          if (!isPdf) ...[
            SizedBox(height: 4.h),
            Text(
              'Tap to retry',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------- Image preview dialog ----------
  void _showImagePreview(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(child: _buildPreviewImage(imagePath)),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(String imagePath) {
    if (_isRemote(imagePath)) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPreviewError(),
      );
    } else if (_isLocalExisting(imagePath)) {
      final path = _normalizeLocalPath(imagePath);
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPreviewError(),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPreviewError(),
      );
    }
  }

  Widget _buildPreviewError() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'Failed to load image',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
