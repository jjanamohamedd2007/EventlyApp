import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class DarkTheme {
  // small text
  static final TextStyle textSmall = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // medium text
  static final TextStyle textMedium = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // appbar text
  static final TextStyle appBarText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  // textfield
  static final TextStyle textField = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // large text
  static final TextStyle largeText = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0xFF666666),
  );

  // link text
  static final TextStyle linkText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // italic text
  static final TextStyle italicText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: AppColors.primary,
  );
}
