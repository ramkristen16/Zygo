import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    // Utilisateur déjà connecté ,  Home directement
    if (user != null) {
      context.go('/home');
      return;
    }

    // Vérifie si l'onboarding a déjà été vu
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboardingDone') ?? false;

    if (!mounted) return;

    if (onboardingDone) {
      // A déjà utilisé l'app , Login directement
      context.go('/login');
    } else {
      // Première ouverture , Onboarding depuis la page 1
      context.go('/onboarding');
    }
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/image/logo.svg',
                  width: 230,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    style: AppTextStyle.h3.copyWith(
                      color: AppColors.primaryNavyBlue,
                    ),
                    children: [
                      const TextSpan(text: 'Même trajet, '),
                      TextSpan(
                        text: 'facilement.',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}