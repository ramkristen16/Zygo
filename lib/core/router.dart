import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../devtools/seed_trips_screens.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/personal_name_screen.dart';
import '../features/auth/view/signup_screen.dart';
import '../features/driverProfile/view/DriverProfileScreen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/splash/view/splash_screen.dart';
import '../features/trips/views/trip_list_screen.dart';


//écrans à créer , c'est Home qui va etre la carte avec formulaire
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home — à créer')));
}



final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',


  redirect: (BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;
    final user = FirebaseAuth.instance.currentUser;

    final signupFlow = ['/signup', '/personal-name','/driver-profile','/seed'];

    // Routes publiques qui ne nécessitent pas de session
    final publicRoutes = [
      '/splash',
      '/onboarding',
      '/login',
      '/signup',
      '/personal-name',
      '/seed',
    ];

    final isPublic = publicRoutes.contains(location);

    // Ne pas rediriger si l'utilisateur est dans le flux d'inscription
    if (signupFlow.contains(location)) return null;


    if (user != null && isPublic && location != '/splash' && location != '/seed') {
      return '/trips';
    }
    if (user == null && !isPublic) {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboardingDone') ?? false;
      return onboardingDone ? '/login' : '/onboarding';
    }

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
    GoRoute(
      path: '/trips',
      builder: (context, state) => TripListScreen(
        searchParams: state.extra as Map<String, dynamic>?,

      ),
    ),

// TEMPORAIRE — à supprimer avant prod
    GoRoute(
      path: '/seed',
      builder: (context, state) => const SeedTripsScreen(),
    ),
  ],

);