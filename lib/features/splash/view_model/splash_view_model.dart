import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashViewModel {
  void initSplash(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        context.go('/onboarding');
      }
    });
  }
}
