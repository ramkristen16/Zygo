import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthViewModel _viewModel = AuthViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Content de vous\nrevoir !',
                style: AppTextStyle.h1.copyWith(height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Connectez-vous pour commencer à voyager.',
                style: AppTextStyle.body2,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _viewModel.emailController,
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  prefixIcon: const Icon(Icons.mail_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _viewModel.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _viewModel.login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Se connecter',
                    style: AppTextStyle.buttonLinkMedium.copyWith(
                      color: AppColors.textOnYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nouveau sur Zygo ? '),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: Text(
                      'Créer un compte',
                      style: AppTextStyle.body2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
