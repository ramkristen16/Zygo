import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void finishOnboarding(BuildContext context) {
    context.go('/signup');
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
