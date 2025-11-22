import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralizes palette, typography and layout tokens for the Hi!Paws brand.
class HiPawsColors {
  static const Color primaryOrange = Color(0xFFFF9A2A);
  static const Color primaryNavy = Color(0xFF252659);
  static const Color accentMint = Color(0xFF22D0A2);
  static const Color textPrimary = primaryNavy;
  static const Color textSecondary = Color(0xFF777777);
  static const Color background = Colors.white;
  static const Color chipBackground = Color(0xFFFFF3E5);
  static const Color fieldBorder = Color(0xFFE0E0E0);
  static const Color ratingInactive = Color(0xFFFFE4BF);
  static const Color videoPlaceholder = Color(0xFFFFE4BF);
  static const Color bottomNavBackground = primaryNavy;
  static const Color iconInactive = Colors.white;
  static const Color iconActive = accentMint;
}

class HiPawsTextStyles {
  static TextStyle get logo => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: HiPawsColors.primaryNavy,
      );

  static TextStyle get screenTitle => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: HiPawsColors.primaryNavy,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HiPawsColors.primaryNavy,
      );

  static TextStyle get orangeSectionLabel => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: HiPawsColors.primaryOrange,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: HiPawsColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get buttonText => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get chip => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: HiPawsColors.primaryNavy,
      );

  static TextStyle get smallLink => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: HiPawsColors.primaryNavy,
      );
}

class HiPawsSpacing {
  static const double defaultHorizontal = 20;
  static const double defaultVertical = 16;
  static const double cardBorderRadius = 16;
  static const double textFieldBorderRadius = 12;
  static const double bottomNavHeight = 68;
}
