import 'package:go_router/go_router.dart';
import '../features/splash/view/splash_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/signup_screen.dart';
import '../features/auth/view/personal_name_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/personal-name',
      builder: (context, state) => const PersonalNameScreen(),
    ),
  ],
);
