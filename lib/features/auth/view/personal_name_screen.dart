import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

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
                // En-tête avec flèche retour Iconsax et logo
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
                const SizedBox(height: 32), // Espace après l'en-tête

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre dynamique
                        Text(
                          _isSubmitted
                              ? 'Bienvenue\n${_nameController.text}'
                              : 'Comment vous\nappelez-vous ?',
                          style: AppTextStyle.h1.copyWith(
                            fontSize:
                                32, // Utilisation de H1 mais taille spécifique pour ce titre
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Vous pouvez utiliser un pseudo.',
                          style: AppTextStyle.body1.copyWith(
                            color: AppColors.primaryNavyBlue.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ), // Espace avant l'input/avatar
                        // Input ou Vue avatar/prénom
                        if (!_isSubmitted)
                          TextField(
                            controller: _nameController,
                            autofocus: true,
                            style: AppTextStyle.input,
                            decoration: InputDecoration(
                              hintText: 'ex : Alex',
                              hintStyle: AppTextStyle.input.copyWith(
                                color: const Color(
                                  0xFF94A3B8,
                                ), // Couleur de hint conforme au modèle
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
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                setState(() => _isSubmitted = true);
                              }
                            },
                          )
                        else
                          Row(
                            children: [
                              // Avatar circulaire jaune avec initiale
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
                                  style: AppTextStyle.h3.copyWith(
                                    color: AppColors.yellowB20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Champ affichant le nom saisi
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryNavyBlue.withValues(
                                      alpha: 0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _nameController.text,
                                    style: AppTextStyle.input.copyWith(
                                      fontWeight: FontWeight.w500,
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

                // Bouton Continuer aligné en bas à droite
                if (_isSubmitted || _nameController.text.trim().isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_isSubmitted) {
                          setState(() => _isSubmitted = true);
                        } else {
                          context.go(
                            '/signup',
                          ); // Redirige vers signup après validation du nom
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
                            style: AppTextStyle.buttonLinkMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnYellow,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons
                                .chevron_right_rounded, // Utilisation de l'icône Flutter standard
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
