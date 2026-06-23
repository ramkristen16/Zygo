import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.go('/onboarding', extra: 2),
                      icon: const Icon(Iconsax.arrow_left_2, size: 28,
                          color: AppColors.primaryNavyBlue),
                    ),
                    SvgPicture.asset('assets/image/logo.svg', height: 32),
                  ],
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connectez-vous\nà Zygo',
                          style: AppTextStyle.h1.copyWith(fontSize: 32, height: 1.15),
                        ),
                        const SizedBox(height: 28),

                        _buildLabel('Email'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: vm.emailController,
                          hintText: '@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Mot de passe'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: vm.passwordController,
                          hintText: '*******',
                          isPassword: true,
                          visible: _passwordVisible,
                          onToggleVisibility: () => setState(
                                  () => _passwordVisible = !_passwordVisible),
                        ),

                        // Mot de passe oublié
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: vm.isLoading
                                ? null
                                : () => vm.forgotPassword(context),
                            child: Text(
                              'Mot de passe oublié ?',
                              style: AppTextStyle.label.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        if (vm.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              vm.errorMessage!,
                              style: AppTextStyle.label.copyWith(color: Colors.redAccent),
                            ),
                          ),
                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: vm.isLoading ? null : () => vm.login(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnYellow,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: vm.isLoading
                                ? const SizedBox(height: 20, width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppColors.textOnYellow))
                                : Text('Se connecter',
                                style: AppTextStyle.buttonLinkMedium.copyWith(
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDivider(),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: vm.isLoading
                                ? null
                                : () => vm.loginWithGoogle(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryNavyBlue.withValues(alpha: 0.05),
                              foregroundColor: AppColors.primaryNavyBlue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/image/google.svg',
                                    height: 20, width: 20),
                                const SizedBox(width: 8),
                                Text('Continuer avec Google',
                                    style: AppTextStyle.buttonLinkMedium.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: TextButton(
                    onPressed: () => context.go('/signup'),
                    child: Text.rich(TextSpan(
                      style: AppTextStyle.body2.copyWith(color: AppColors.primaryNavyBlue),
                      children: [
                        const TextSpan(text: 'Pas encore de compte ? '),
                        TextSpan(
                          text: 'Inscrivez-vous',
                          style: AppTextStyle.body2.copyWith(
                              fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: AppTextStyle.label.copyWith(
          color: AppColors.primaryNavyBlue.withValues(alpha: 0.8)));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool visible = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !visible,
      keyboardType: keyboardType,
      style: AppTextStyle.input,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.input.copyWith(color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: AppColors.primaryNavyBlue.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        suffixIcon: isPassword
            ? IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(visible ? Iconsax.eye : Iconsax.eye_slash,
                size: 20,
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.4)))
            : null,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(children: [
      Expanded(child: Divider(color: AppColors.primaryNavyBlue.withValues(alpha: 0.1))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('ou',
            style: AppTextStyle.body3.copyWith(
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.4))),
      ),
      Expanded(child: Divider(color: AppColors.primaryNavyBlue.withValues(alpha: 0.1))),
    ]);
  }
}