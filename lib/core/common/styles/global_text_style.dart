import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

TextStyle getTextStyle({
  required CustomFonts font,
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1,
  TextAlign textAlign = TextAlign.center,
  Color color = Colors.black,
}) {
  switch (font) {
    case CustomFonts.obviously:
      return TextStyle(
        fontFamily: 'Obviously',
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        height: lineHeight,
        color: color,
      );
    case CustomFonts.inter:
      return GoogleFonts.inter(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        height: lineHeight,
        color: color,
      );
    case CustomFonts.manrope:
      return GoogleFonts.manrope(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        height: lineHeight,
        color: color,
      );
    default:
      return TextStyle(
        fontFamily: 'Obviously',
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        height: lineHeight,
        color: color,
      );
  }
}
