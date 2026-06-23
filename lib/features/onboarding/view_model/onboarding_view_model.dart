import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  late final PageController pageController;
  int currentPage;

  OnboardingViewModel({int initialPage = 0})
      : currentPage = initialPage,
        pageController = PageController(initialPage: initialPage);

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

 //marque onboarding comme déjà vu
  Future<void> markOnboardingDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}