import 'package:flutter/material.dart';

import '../../core/appColors.dart';
import '../../core/appTextStyles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    // Une fois la route de connexion créée :
    // context.go('/login');
    debugPrint('Navigation vers le Login !');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _buildPageContent(
                      title: _titlePage1(),
                      description: _descriptionPage1(),
                    ),
                    _buildPageContent(
                      title: _titlePage2(),
                      description: _descriptionPage2(),
                    ),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _currentPage == 0
            ? [
          Text('Zygo', style: AppTextStyle.h2),
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              'skip and log in',
              style: AppTextStyle.body3.copyWith(
                color: AppColors.primaryNavyBlue.withOpacity(0.6),
              ),
            ),
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavyBlue),
            onPressed: _goToPreviousPage,
          ),
          Text('Zygo', style: AppTextStyle.h2),
        ],
      ),
    );
  }

  List<TextSpan> _titlePage1() => [
    TextSpan(text: 'End', style: _titleStyle(bold: true)),
    TextSpan(text: ' time waste\n', style: _titleStyle(bold: false)),
    TextSpan(text: 'effortlessly', style: _titleStyle(bold: true)),
  ];

  List<TextSpan> _titlePage2() => [
    TextSpan(text: 'Best price', style: _titleStyle(bold: true)),
    TextSpan(text: ' for\n', style: _titleStyle(bold: false)),
    TextSpan(text: 'you', style: _titleStyle(bold: false)),
  ];

  TextStyle _titleStyle({required bool bold}) {
    return AppTextStyle.onboardingTitle.copyWith(
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
  }

  List<TextSpan> _descriptionPage1() => [
    const TextSpan(
      text: 'Because of the buses or traffic? End all of that with Zygo.',
    ),
  ];

  List<TextSpan> _descriptionPage2() => [
    const TextSpan(text: 'No more expensive taxi. Our '),
    TextSpan(text: 'intelligent', style: _descriptionBoldStyle()),
    const TextSpan(text: ' application '),
    TextSpan(text: 'calculates', style: _descriptionBoldStyle()),
    const TextSpan(text: " the best price for everyone's needs."),
  ];

  TextStyle _descriptionBoldStyle() {
    return AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600);
  }

  Widget _buildPageContent({
    required List<TextSpan> title,
    required List<TextSpan> description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: AppTextStyle.onboardingTitle.copyWith(color: AppColors.primaryNavyBlue),
              children: title,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: AppTextStyle.body1.copyWith(
                color: AppColors.primaryNavyBlue.withOpacity(0.75),
              ),
              children: description,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      child: _currentPage == 0
          ? Align(
        alignment: Alignment.centerRight,
        child: _buildPillButton(
          label: 'How about price !',
          onPressed: _goToNextPage,
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              'Skip',
              style: AppTextStyle.buttonLinkMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          _buildPillButton(
            label: "Let's start",
            onPressed: _finishOnboarding,
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton({required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.buttonLinkMedium.copyWith(
              color: AppColors.textOnYellow,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 18, color: AppColors.textOnYellow),
        ],
      ),
    );
  }
}