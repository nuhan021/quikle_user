import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1,
  TextAlign textAlign = TextAlign.center,
  Color color = Colors.black,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight,
    color: color,
  );
}
