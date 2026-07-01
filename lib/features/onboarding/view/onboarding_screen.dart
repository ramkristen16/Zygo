import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../shared/models/user_model.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../view_model/onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  final int initialPage;
  const OnboardingScreen({super.key, this.initialPage = 0});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(initialPage: initialPage),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  @override
  Widget build(BuildContext context) {
    final ovm = context.watch<OnboardingViewModel>();
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ovm),
                const SizedBox(height: 8),
                Expanded(
                  child: PageView(
                    controller: ovm.pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: ovm.onPageChanged,
                    children: [
                      _buildPage1(screenHeight),
                      _buildPage2(screenHeight),
                      _buildPage3(screenHeight),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildFooter(context, ovm),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingViewModel ovm) {
    if (ovm.currentPage == 0) {
      return Center(
        child: SvgPicture.asset('assets/image/logo.svg', height: 32),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: ovm.previousPage,
          icon: const Icon(Icons.chevron_left_rounded,
              size: 28, color: AppColors.primaryNavyBlue),
        ),
        SvgPicture.asset('assets/image/logo.svg', height: 32),
      ],
    );
  }

  Widget _buildPage1(double screenHeight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 86),
          Center(
            child: SvgPicture.asset('assets/image/onboarding1.svg',
                height: screenHeight * 0.35, fit: BoxFit.contain),
          ),
          const SizedBox(height: 12),
          Text('GAGNEZ DU TEMPS,\nSANS EFFORT',
              style: AppTextStyle.onboardingTitle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNavyBlue,
                  fontSize: 26,
                  height: 1.15)),
          const SizedBox(height: 8),
          Text('Problèmes de transport?\nAvec Zygo, c\'est terminé.',
              style: AppTextStyle.body2.copyWith(
                  color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                  height: 1.4)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPage2(double screenHeight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 86),
          Center(
            child: SvgPicture.asset('assets/image/onboarding2.svg',
                height: screenHeight * 0.32, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          Text('LE MEILLEUR PRIX,\nPOUR VOUS',
              style: AppTextStyle.onboardingTitle.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryNavyBlue,
                  fontSize: 24,
                  letterSpacing: -0.5,
                  height: 1.15)),
          const SizedBox(height: 8),
          Text.rich(TextSpan(
            style: AppTextStyle.body2.copyWith(
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                height: 1.4),
            children: [
              const TextSpan(text: 'Fini les taxis chers. '),
              TextSpan(text: 'Négociez',
                  style: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w700)),
              const TextSpan(text: ' en toute transparence.'),
            ],
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPage3(double screenHeight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 86),
          Center(
            child: SvgPicture.asset('assets/image/logo.svg',
                height: screenHeight * 0.22, fit: BoxFit.contain),
          ),
          const SizedBox(height: 36),
          Text.rich(TextSpan(
            style: AppTextStyle.onboardingTitle.copyWith(
                color: AppColors.primaryNavyBlue, fontSize: 26, height: 1.15),
            children: [
              TextSpan(text: 'MÊME TRAJET,\n',
                  style: AppTextStyle.onboardingTitle.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 26)),
              TextSpan(text: 'UN VÉHICULE.',
                  style: AppTextStyle.onboardingTitle.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 26)),
            ],
          )),
          const SizedBox(height: 8),
          Text.rich(TextSpan(
            style: AppTextStyle.body2.copyWith(
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.6),
                height: 1.4),
            children: [
              TextSpan(text: 'Partagez',
                  style: AppTextStyle.body2.copyWith(fontWeight: FontWeight.w700)),
              const TextSpan(text: ' votre trajet, où que vous soyez.'),
            ],
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, OnboardingViewModel ovm) {
    //  On récupère AuthViewModel pour selectRole
    final authVm = context.read<AuthViewModel>();

    if (ovm.currentPage < 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => context.go('/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.4),
              foregroundColor: AppColors.primaryNavyBlue,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Passer',
                style: AppTextStyle.buttonLinkMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryNavyBlue)),
          ),
          ElevatedButton(
            onPressed: ovm.nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnYellow,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ovm.currentPage == 0 ? 'Et le prix alors ?' : 'C\'est parti',
                  style: AppTextStyle.buttonLinkMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnYellow),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.textOnYellow),
              ],
            ),
          ),
        ],
      );
    }
//Conducteur ou passager
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => authVm.selectRole(context, UserRole.passenger),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnYellow,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.airline_seat_recline_normal_rounded,
                    size: 20, color: AppColors.textOnYellow),
                const SizedBox(width: 8),
                Text('Passager',
                    style: AppTextStyle.buttonLinkMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnYellow)),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.textOnYellow),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => authVm.selectRole(context, UserRole.driver),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white.withValues(alpha: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_car_filled_outlined,
                    size: 20, color: AppColors.yellowB40),
                const SizedBox(width: 8),
                Text('Conducteur',
                    style: AppTextStyle.buttonLinkMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.yellowB40)),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.yellowB40),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        Center(
          child: TextButton(
            onPressed: () => context.go('/login'),
            child: Text('Se connecter',
                style: AppTextStyle.buttonLinkMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryNavyBlue)),
          ),
        ),
      ],
    );
  }
}