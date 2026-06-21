import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart'; // Import d'Iconsax

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class PersonalNameScreen extends StatefulWidget {
  const PersonalNameScreen({super.key});

  @override
  State<PersonalNameScreen> createState() => _PersonalNameScreenState();
}

class _PersonalNameScreenState extends State<PersonalNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                // En-tête avec flèche retour Iconsax
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_isSubmitted) {
                          setState(() => _isSubmitted = false);
                        } else {
                          context.go('/onboarding');
                        }
                      },
                      icon: const Icon(
                        Iconsax.arrow_left_2, // Utilisation d'Iconsax
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
                        // Titre dynamique (Etape 1 ou Etape 2)
                        Text(
                          _isSubmitted
                              ? 'Bienvenue\n${_nameController.text}'
                              : 'Comment vous\nappelez-vous ?',
                          style: GoogleFonts.lexend(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavyBlue,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Vous pouvez utiliser un pseudo.',
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryNavyBlue.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Formulaire ou Vue d'avatar selon l'état
                        if (!_isSubmitted)
                          TextField(
                            controller: _nameController,
                            autofocus: true,
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                setState(() => _isSubmitted = true);
                              }
                            },
                            style: GoogleFonts.lexend(
                              fontSize: 15,
                              color: AppColors.primaryNavyBlue,
                            ),
                            decoration: InputDecoration(
                              hintText: 'ex : Alex',
                              hintStyle: GoogleFonts.lexend(
                                color: AppColors.primaryNavyBlue.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors.primaryNavyBlue.withValues(
                                alpha: 0.05,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              // Avatar rond jaune
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AppColors.yellowL70,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text[0].toUpperCase()
                                      : 'Z',
                                  style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.yellowB40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Champ de texte contenant le nom
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryNavyBlue.withValues(
                                      alpha: 0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _nameController.text,
                                    style: GoogleFonts.lexend(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryNavyBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Bouton dynamique de validation (Apparaît à la saisie)
                if (_isSubmitted || _nameController.text.trim().isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_isSubmitted) {
                          setState(() => _isSubmitted = true);
                        } else {
                          context.go('/signup');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnYellow,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continuer',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnYellow,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Iconsax.arrow_right_3, // Utilisation d'Iconsax
                            size: 18,
                            color: AppColors.textOnYellow,
                          ),
                        ],
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
}
