import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/view/login_screen.dart';
import '../features/auth/view/personal_name_screen.dart';
import '../features/auth/view/signup_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/splash/view/splash_screen.dart';


//écrans à créer mais ceci est juste pour la teste
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home — à créer')));
}

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Driver Profile — à créer')));
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',


  redirect: (BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;
    final user = FirebaseAuth.instance.currentUser;

    // Routes publiques qui ne nécessitent pas de session
    final publicRoutes = [
      '/splash',
      '/onboarding',
      '/login',
      '/signup',
      '/personal-name',
    ];

    final isPublic = publicRoutes.contains(location);


    if (user != null && isPublic && location != '/splash') {
      return '/home';
    }

    if (user == null && !isPublic) {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboardingDone') ?? false;
      return onboardingDone ? '/login' : '/onboarding';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        final initialPage = state.extra as int? ?? 0;
        return OnboardingScreen(initialPage: initialPage);
      },
    ),

    // Auth
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/personal-name',
      builder: (context, state) => const PersonalNameScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // App principale
    GoRoute(
      path: '/driver-profile',
      builder: (context, state) => const DriverProfileScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);