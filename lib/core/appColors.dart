import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //  Couleur primaire : Jaune
  static const Color primary = Color(0xFFFFDB19); // Y_L_10

  // Nuances claires de jaune
  static const Color yellowL10 = Color(0xFFFFDB19);
  static const Color yellowL20 = Color(0xFFFFDF33);
  static const Color yellowL30 = Color(0xFFFFE34C);
  static const Color yellowL60 = Color(0xFFFFEF99);
  static const Color yellowL70 = Color(0xFFFFF3B2);
  static const Color yellowL90 = Color(0xFFFFFBE5);
  static const Color yellowL95 = Color(0xFFFFFDF2);

  // Nuances foncées de jaune
  static const Color yellowB10 = Color(0xFFE5C100);
  static const Color yellowB20 = Color(0xFFCCAC00);
  static const Color yellowB30 = Color(0xFFB39700);
  static const Color yellowB40 = Color(0xFF998100);
  static const Color yellowB50 = Color(0xFF806C00);
  static const Color yellowB60 = Color(0xFF665600);
  static const Color yellowB80 = Color(0xFF332B00);

  // Fonds & textes jaunes
  static const Color bgYellow = Color(0xFFFFFEF7);
  static const Color textOnYellow = Color(0xFF1A1600); // "Black Y"
  static const Color inputBoxYellow = Color(0xFFFFF9D9);

  //  Bleu (secondaire / accents)
  static const Color blueGrey = Color(0xFF99BBE1); // nommé "grey" dans Figma
  static const Color textOnBlue = Color(0xFF002248); // "BLACK BLEU"
  static const Color lightBlue = Color(0xFFEDF3FA);
  static const Color blueL80 = Color(0xFFD9E6F4);
  static const Color inputContourBlue = Color(0xFFB2CCE8);
  static final Color headerOverlay = Colors.white.withOpacity(0.5);

  //  Neutres
  static const Color primaryNavyBlue = Color(0xFF1E293B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // Dégradé pastel du Splash Screen , Onboarding

  static const Color splashGradientStart = Color(0xFFF7E6F2); // rose/lavande pâle
  static const Color splashGradientMid = Color(0xFFFFF6DE); // jaune très pâle
  static const Color splashGradientEnd = Color(0xFFFFFEF7); // crème (bgYellow)
}