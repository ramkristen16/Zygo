import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

// Styles de texte de l'application, basés sur la police Lexend.

class AppTextStyle {
  AppTextStyle._();

  static TextStyle _base({
    required double fontSize,
    required double lineHeight,
    required FontWeight fontWeight,
    Color color = AppColors.primaryNavyBlue,
  }) {
    return GoogleFonts.lexend(
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  //Titres (Headings - SemiBold)
  static TextStyle h1 = _base(
    fontSize: 26,
    lineHeight: 32,
    fontWeight: FontWeight.w700,
  );
  static TextStyle h2 = _base(
    fontSize: 20,
    lineHeight: 28,
    fontWeight: FontWeight.w600,
  );
  static TextStyle h3 = _base(
    fontSize: 18,
    lineHeight: 24,
    fontWeight: FontWeight.w600,
  );
  static TextStyle h4 = _base(
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w600,
  );

  //Corps de texte (Body - Regular)
  static TextStyle body1 = _base(
    fontSize: 15,
    lineHeight: 22,
    fontWeight: FontWeight.w400,
  ); // Texte principal
  static TextStyle body2 = _base(
    fontSize: 14,
    lineHeight: 20,
    fontWeight: FontWeight.w400,
  ); // Descriptions, labels
  static TextStyle body3 = _base(
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w400,
  ); // Petits textes

  //  Boutons / Liens (Regular, 3 tailles)
  static TextStyle buttonLinkLarge = _base(
    fontSize: 16,
    lineHeight: 20,
    fontWeight: FontWeight.w600,
  );
  static TextStyle buttonLinkMedium = _base(
    fontSize: 14,
    lineHeight: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle buttonLinkSmall = _base(
    fontSize: 12,
    lineHeight: 16,
    fontWeight: FontWeight.w600,
  );

  //  Champs de saisie & labels
  static TextStyle input = _base(
    fontSize: 14,
    lineHeight: 20,
    fontWeight: FontWeight.w400,
  );
  static TextStyle label = _base(
    fontSize: 13,
    lineHeight: 16,
    fontWeight: FontWeight.w600,
  );

  //  Titre Onboarding
  static TextStyle onboardingTitle = _base(
    fontSize: 30,
    lineHeight: 38,
    fontWeight: FontWeight.w700,
  );
}
