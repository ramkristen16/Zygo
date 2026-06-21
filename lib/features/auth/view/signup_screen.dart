import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                // En-tête
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.go(
                        '/personal-name',
                      ), // Retourne à l'écran du nom
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
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Créez-vous\nun compte',
                          style: AppTextStyle.h1.copyWith(
                            fontSize: 32, // Taille spécifique pour ce titre
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 28), // Espace après le titre
                        // Email
                        _buildLabel('Email'),
                        const SizedBox(height: 6),
                        _buildTextField(hintText: '@gmail.com'),
                        const SizedBox(height: 16),

                        // Mot de passe
                        _buildLabel('Mot de passe'),
                        const SizedBox(height: 6),
                        _buildTextField(hintText: '*******', isPassword: true),
                        const SizedBox(height: 16),

                        // Confirmation Mot de passe
                        _buildLabel('Confirmez le mot de passe'),
                        const SizedBox(height: 6),
                        _buildTextField(hintText: '*******', isPassword: true),
                        const SizedBox(height: 28),

                        // Bouton principal S'inscrire
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnYellow,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'S\'inscrire',
                              style: AppTextStyle.buttonLinkMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Séparateur
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
                                style: AppTextStyle.body3.copyWith(
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

                        // Bouton Google
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
                                  style: AppTextStyle.buttonLinkMedium.copyWith(
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

                // Bas de page (Lien)
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyle.body2.copyWith(
                          color: AppColors.primaryNavyBlue,
                        ),
                        children: [
                          const TextSpan(text: 'Déjà un compte ? '),
                          TextSpan(
                            text: 'Connectez-vous',
                            style: AppTextStyle.body2.copyWith(
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
      style: AppTextStyle.label.copyWith(
        color: AppColors.primaryNavyBlue.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildTextField({required String hintText, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: AppTextStyle.input,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.input.copyWith(color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: AppColors.primaryNavyBlue.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
