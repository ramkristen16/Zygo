import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../view_model/auth_view_model.dart';

class PersonalNameScreen extends StatefulWidget {
  const PersonalNameScreen({super.key});

  @override
  State<PersonalNameScreen> createState() => _PersonalNameScreenState();
}

class _PersonalNameScreenState extends State<PersonalNameScreen> {
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
                'Comment vous\nappelez-vous ?',
                style: AppTextStyle.h1.copyWith(height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Entrez votre prénom pour que la communauté puisse vous identifier.',
                style: AppTextStyle.body2,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _viewModel.nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: const Icon(Icons.person_outline),
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
                  onPressed: () => _viewModel.submitSignup(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Valider',
                    style: AppTextStyle.buttonLinkMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
