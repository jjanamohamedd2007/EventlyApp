import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  // small text
  static final TextStyle textSmall = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1C1C1C),
  );

  // medium text
  static final TextStyle textMedium = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF5669FF), // primary
  );

  // appbar text
  static final TextStyle appBarText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF101127),
  );

  // textfield
  static final TextStyle textField = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF7B7B7B),
  );

  // large text
  static final TextStyle largeText = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF666666),
  );

  // link text
  static final TextStyle linkText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1C1C1C),
  );

  // italic text
  static final TextStyle italicText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: const Color(0xFF5669FF), // primary
  );
}
