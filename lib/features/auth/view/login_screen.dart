import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.splashGradientStart,
              AppColors.splashGradientMid,
              AppColors.splashGradientEnd,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.go('/onboarding'),
                      icon: const Icon(
                        Iconsax.arrow_left_2,
                        size: 28,
                        color: AppColors.primaryNavyBlue,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/image/logo.svg',
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connectez-vous\nà Zygo',
                          style: GoogleFonts.lexend(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavyBlue,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Champ Email
                        _buildLabel('Email'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          hintText: '@gmail.com',
                          icon: Iconsax.sms,
                        ),
                        const SizedBox(height: 16),

                        // Champ Mot de passe
                        _buildLabel('Mot de passe'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          hintText: '*******',
                          icon: Iconsax.lock,
                          isPassword: true,
                        ),
                        const SizedBox(height: 24),

                        // Bouton principal Se connecter
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnYellow,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Se connecter',
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Divider "ou"
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.primaryNavyBlue.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                'ou',
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  color: AppColors.primaryNavyBlue.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.primaryNavyBlue.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Connexion Google
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryNavyBlue
                                  .withValues(alpha: 0.05),
                              foregroundColor: AppColors.primaryNavyBlue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/image/google.svg',
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Continuer avec google',
                                  style: GoogleFonts.lexend(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Pied de page
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/signup'),
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          color: AppColors.primaryNavyBlue,
                        ),
                        children: [
                          const TextSpan(text: 'Pas encore de compte ? '),
                          TextSpan(
                            text: 'Inscrivez-vous',
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.lexend(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryNavyBlue.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: GoogleFonts.lexend(fontSize: 14, color: AppColors.primaryNavyBlue),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.lexend(
          color: AppColors.primaryNavyBlue.withValues(alpha: 0.3),
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primaryNavyBlue.withValues(alpha: 0.4),
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.primaryNavyBlue.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
