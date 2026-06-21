import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    // Redirection vers l'écran du prénom
    context.go('/personal-name');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
              vertical:
                  8.0, // Réduit légèrement pour gagner de l'espace vertical
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. En-tête dynamique
                _buildHeader(),
                const SizedBox(height: 8),

                // 2. Zone d'affichage PageView (Images + Textes)
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildPage1(screenHeight),
                      _buildPage2(screenHeight),
                      _buildPage3(screenHeight),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Pied de page dynamique
                _buildFooter(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // En-tête variant selon la page
  Widget _buildHeader() {
    if (_currentPage == 0) {
      return Center(
        child: SvgPicture.asset(
          'assets/image/logo.svg',
          height: 32,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousPage,
            icon: const Icon(
              Icons.chevron_left_rounded,
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
      );
    }
  }

  // Écran 1
  Widget _buildPage1(double screenHeight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 86), // Espacement réduit
          Center(
            child: SvgPicture.asset(
              'assets/image/onboarding1.svg',
              height: screenHeight * 0.35,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 12,
          ), // Espacement resserré entre illustration et texte
          Text(
            'GAGNEZ DU TEMPS,\nSANS EFFORT',
            style: AppTextStyle.onboardingTitle.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNavyBlue,
              fontSize: 26, // Texte plus compact pour éviter l'encombrement
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Problèmes de transport?\nAvec Zygo, c\'est terminé.',
            style: AppTextStyle.body2.copyWith(
              color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Écran 2
  Widget _buildPage2(double screenHeight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 86), // Espacement réduit
          Center(
            child: SvgPicture.asset(
              'assets/image/onboarding2.svg',
              height: screenHeight * 0.32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16), // Espacement resserré
          Text(
            'LE MEILLEUR PRIX,\nPOUR VOUS',
            style: AppTextStyle.onboardingTitle.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primaryNavyBlue,
              fontSize: 24, // Texte plus compact
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: AppTextStyle.body2.copyWith(
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Fini les taxis chers. '),
                TextSpan(
                  text: 'Négociez',
                  style: AppTextStyle.body2.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' en toute transparence.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Écran 3 (Landing / Choix du rôle)
  Widget _buildPage3(double screenHeight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 86), // Espacement réduit
          Center(
            child: SvgPicture.asset(
              'assets/image/logo.svg',
              height: screenHeight * 0.22, // Hauteur ajustée
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 36), // Espacement resserré
          Text.rich(
            TextSpan(
              style: AppTextStyle.onboardingTitle.copyWith(
                color: AppColors.primaryNavyBlue,
                fontSize: 26, // Taille de titre plus mesurée
                height: 1.15,
              ),
              children: [
                TextSpan(
                  text: 'MÊME TRAJET,\n',
                  style: AppTextStyle.onboardingTitle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 26,
                  ),
                ),
                TextSpan(
                  text: 'UN VÉHICULE.',
                  style: AppTextStyle.onboardingTitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: AppTextStyle.body2.copyWith(
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'Partagez',
                  style: AppTextStyle.body2.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' votre trajet, où que vous soyez.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Barre de navigation du bas
  Widget _buildFooter() {
    if (_currentPage < 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton "Passer" (gauche, gris clair)
          ElevatedButton(
            onPressed: _finishOnboarding,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.4),
              foregroundColor: AppColors.primaryNavyBlue,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Passer',
              style: AppTextStyle.buttonLinkMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNavyBlue,
              ),
            ),
          ),
          // Bouton d'action (droite, jaune)
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnYellow,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentPage == 0 ? 'Et le prix alors ?' : 'C\'est parti',
                  style: AppTextStyle.buttonLinkMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnYellow,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.textOnYellow,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Boutons spécifiques empilés pour le dernier écran
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton Passager
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.go('/personal-name'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnYellow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.airline_seat_recline_normal_rounded,
                    size: 20,
                    color: AppColors.textOnYellow,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Passager',
                    style: AppTextStyle.buttonLinkMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnYellow,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.textOnYellow,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Bouton Conducteur
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => context.go('/personal-name'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_car_filled_outlined,
                    size: 20,
                    color: AppColors.yellowB40,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Conducteur',
                    style: AppTextStyle.buttonLinkMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.yellowB40,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.yellowB40,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Lien de connexion
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                'Se connecter',
                style: AppTextStyle.buttonLinkMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryNavyBlue,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
