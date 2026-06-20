import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'appColors.dart';


/// Styles de texte de l'application, basés sur la police Lexend.

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
  static TextStyle h1 = _base(fontSize: 28, lineHeight: 36, fontWeight: FontWeight.w600); // H_1_SB28
  static TextStyle h2 = _base(fontSize: 20, lineHeight: 28, fontWeight: FontWeight.w600); // H_2_SB20
  static TextStyle h3 = _base(fontSize: 18, lineHeight: 24, fontWeight: FontWeight.w600); // H_3_SB18
  static TextStyle h4 = _base(fontSize: 16, lineHeight: 20, fontWeight: FontWeight.w600); // H_4_SB16

  //Corps de texte (Body - Regular)
  static TextStyle body1 = _base(fontSize: 16, lineHeight: 24, fontWeight: FontWeight.w400); // B_1_R16
  static TextStyle body2 = _base(fontSize: 14, lineHeight: 20, fontWeight: FontWeight.w400); // B_2_R14
  static TextStyle body3 = _base(fontSize: 12, lineHeight: 16, fontWeight: FontWeight.w400); // B_3_R12

  //  Boutons / Liens (Regular, 3 tailles)
  static TextStyle buttonLinkLarge = _base(fontSize: 18, lineHeight: 24, fontWeight: FontWeight.w400); // BL_N_R18
  static TextStyle buttonLinkMedium = _base(fontSize: 16, lineHeight: 20, fontWeight: FontWeight.w400); // BL_M_R16
  static TextStyle buttonLinkSmall = _base(fontSize: 14, lineHeight: 16, fontWeight: FontWeight.w400); // BL_S_R14

  //  Champs de saisie & labels
  static TextStyle input = _base(fontSize: 16, lineHeight: 24, fontWeight: FontWeight.w400); // Input_R16
  static TextStyle label = _base(fontSize: 12, lineHeight: 16, fontWeight: FontWeight.w400); // Label_R12

  //  Titre Onboarding

  static TextStyle onboardingTitle = _base(fontSize: 32, lineHeight: 40, fontWeight: FontWeight.w700);
}