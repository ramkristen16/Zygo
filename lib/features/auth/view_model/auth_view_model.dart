import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void navigateToName(BuildContext context) {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      context.go('/personal-name');
    }
  }

  void submitSignup(BuildContext context) {
    if (nameController.text.isNotEmpty) {
      context.go('/login');
    }
  }

  void login(BuildContext context) {
    // Logique de login
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connexion validée !')));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
