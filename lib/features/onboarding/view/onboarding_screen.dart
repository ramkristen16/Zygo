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
    context.go('/signup');
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
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. En-tête dynamique
                _buildHeader(),
                const SizedBox(height: 12),

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
                const SizedBox(height: 12),

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
          const SizedBox(height: 20),
          Center(
            child: SvgPicture.asset(
              'assets/image/onboarding1.svg',
              height: screenHeight * 0.25,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Gagnez du temps,\nsans effort',
            style: GoogleFonts.lexend(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNavyBlue,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'À cause des bus ou des embouteillages ?\nAvec Zygo, c\'est terminé.',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
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
          const SizedBox(height: 20),
          Center(
            child: SvgPicture.asset(
              'assets/image/onboarding2.svg',
              height: screenHeight * 0.25,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'LE MEILLEUR PRIX,\nPOUR VOUS',
            style: GoogleFonts.lexend(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryNavyBlue,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'Fini les taxis chers. Notre application ',
                ),
                TextSpan(
                  text: 'intelligente calcule',
                  style: GoogleFonts.lexend(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' le meilleur prix pour chacun.'),
              ],
            ),
          ),
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
          const SizedBox(height: 20),
          Center(
            child: SvgPicture.asset(
              'assets/image/onboarding3.svg',
              height: screenHeight * 0.22,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              style: GoogleFonts.lexend(
                fontSize: 26,
                color: AppColors.primaryNavyBlue,
                height: 1.2,
              ),
              children: [
                const TextSpan(
                  text: 'Même trajet,\n',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                TextSpan(
                  text: 'une voiture.',
                  style: GoogleFonts.lexend(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'Trouvez',
                  style: GoogleFonts.lexend(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      ' des personnes partageant votre trajet, où que vous soyez.',
                ),
              ],
            ),
          ),
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
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNavyBlue,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnYellow,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentPage == 0 ? 'Et le prix alors ?' : 'C\'est parti',
                  style: GoogleFonts.lexend(
                    fontSize: 14,
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
      // Boutons spécifiques empilés pour le dernier écran (Hauteur ajustée à 48)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton Passager
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.go('/signup'),
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
                    style: GoogleFonts.lexend(
                      fontSize: 14,
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
              onPressed: () => context.go('/signup'),
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
                    style: GoogleFonts.lexend(
                      fontSize: 14,
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
                style: GoogleFonts.lexend(
                  fontSize: 14,
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
