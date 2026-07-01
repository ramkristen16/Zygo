import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../view_model/DriverProfileViewModel.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverProfileViewModel(),
      child: const _DriverProfileBody(),
    );
  }
}

class _DriverProfileBody extends StatelessWidget {
  const _DriverProfileBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),

                    // Titre
                    Text.rich(
                      TextSpan(
                        style: AppTextStyle.h2.copyWith(
                          color: AppColors.primaryNavyBlue,
                          height: 1.3,
                        ),
                        children: [
                          const TextSpan(text: 'Passer en mode '),
                          TextSpan(
                            text: 'conducteur',
                            style: AppTextStyle.h2.copyWith(
                                color: AppColors.primary),
                          ),
                          const TextSpan(text: '\nà tout moment'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Carte formulaire
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Détails de votre véhicule',
                            style: AppTextStyle.body2.copyWith(
                              color: AppColors.primaryNavyBlue
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('Marque et modèle'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: vm.vehicleBrandController,
                            style: AppTextStyle.input,
                            decoration: InputDecoration(
                              hintText:
                              'ex : Rexton, Toyota Yaris, Honda CB500',
                              hintStyle: AppTextStyle.input.copyWith(
                                  color: const Color(0xFF94A3B8)),
                              filled: true,
                              fillColor: AppColors.background,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Type de véhicule — Moto ou Voiture uniquement
                          _buildLabel('Type de véhicule'),
                          const SizedBox(height: 6),
                          _buildTypeSelector(context, vm),
                          const SizedBox(height: 12),

                          // Nombre de places — masqué si Moto (auto = 1)
                          if (vm.selectedVehicleType == 'Voiture' || vm.selectedVehicleType == 'Camionnette' || vm.selectedVehicleType == 'Bus') ...[
                            _buildLabel('Nombre de places'),
                            const SizedBox(height: 6),
                            _buildDropdown(
                              icon: Iconsax.people,
                              hint: 'Nombre de places',
                              value: vm.selectedSeats?.toString(),
                              items: DriverProfileViewModel.seatsFor(
                                  vm.selectedVehicleType),
                              onChanged: (val) => vm.setSeats(
                                  val != null ? int.parse(val) : null),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Moto , info 1 place fixe
                          if (vm.selectedVehicleType == 'Moto') ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.yellowL95,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Iconsax.info_circle,
                                      size: 16, color: AppColors.yellowB30),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Moto : 1 place passager uniquement',
                                    style: AppTextStyle.label.copyWith(
                                        color: AppColors.yellowB30),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          const SizedBox(height: 8),

                          // Upload photos
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPhotoUpload(
                                label: 'Votre photo\nde profil',
                                imagePath: vm.profilePhotoPath,
                                isVerifying: false,
                                onTap: () => vm.pickPhoto(
                                    context, PhotoType.profile),
                              ),
                              _buildPhotoUpload(
                                label: 'Avant du\nvéhicule',
                                imagePath: vm.vehicleFrontPath,
                                isVerifying: vm.isVerifying,
                                onTap: () => vm.pickPhoto(
                                    context, PhotoType.front),
                              ),
                              _buildPhotoUpload(
                                label: 'Arrière du\nvéhicule',
                                imagePath: vm.vehicleBackPath,
                                isVerifying: vm.isVerifying,
                                onTap: () => vm.pickPhoto(
                                    context, PhotoType.back),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Erreur
                          if (vm.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                vm.errorMessage!,
                                style: AppTextStyle.label.copyWith(
                                    color: Colors.redAccent),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          // Bouton Valider
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: vm.isLoading
                                  ? null
                                  : () => vm.submit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textOnYellow,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: vm.isLoading
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textOnYellow,
                                ),
                              )
                                  : Text(
                                'Valider',
                                style: AppTextStyle.buttonLinkMedium
                                    .copyWith(
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Conditions
                          Center(
                            child: Text.rich(
                              TextSpan(
                                style: AppTextStyle.label.copyWith(
                                  color: AppColors.primaryNavyBlue
                                      .withValues(alpha: 0.6),
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                    'En validant cet inscription vous acceptez\nles ',
                                  ),
                                  TextSpan(
                                    text: 'conditions d\'utilisation',
                                    style: AppTextStyle.label.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.chevron_left_rounded,
                size: 28, color: AppColors.primaryNavyBlue),
          ),
          SvgPicture.asset('assets/image/logo.svg', height: 32),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.map,
                size: 24, color: AppColors.primaryNavyBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.label.copyWith(
          color: AppColors.primaryNavyBlue.withValues(alpha: 0.8),
          fontWeight: FontWeight.w600),
    );
  }

  /// Sélecteur visuel — 4 types compréhensibles par tous
  Widget _buildTypeSelector(
      BuildContext context, DriverProfileViewModel vm) {
    return Column(
      children: [
        Row(
          children: [
            _buildTypeOption(vm: vm, type: 'Moto',
                icon: Icons.two_wheeler_rounded),
            const SizedBox(width: 12),
            _buildTypeOption(vm: vm, type: 'Voiture',
                icon: Icons.directions_car_rounded),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTypeOption(vm: vm, type: 'Camionnette',
                icon: Icons.airport_shuttle_rounded),
            const SizedBox(width: 12),
            _buildTypeOption(vm: vm, type: 'Bus',
                icon: Icons.directions_bus_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required DriverProfileViewModel vm,
    required String type,
    required IconData icon,
  }) {
    final isSelected = vm.selectedVehicleType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.setVehicleType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected
                    ? AppColors.textOnYellow
                    : AppColors.primaryNavyBlue.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 6),
              Text(
                type,
                style: AppTextStyle.body3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.textOnYellow
                      : AppColors.primaryNavyBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon,
                  size: 18,
                  color:
                  AppColors.primaryNavyBlue.withValues(alpha: 0.5)),
              const SizedBox(width: 10),
              Text(hint,
                  style: AppTextStyle.input.copyWith(
                      color: AppColors.primaryNavyBlue
                          .withValues(alpha: 0.5))),
            ],
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryNavyBlue),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(icon,
                      size: 18,
                      color: AppColors.primaryNavyBlue
                          .withValues(alpha: 0.7)),
                  const SizedBox(width: 10),
                  Text(item, style: AppTextStyle.input),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPhotoUpload({
    required String label,
    required String? imagePath,
    required VoidCallback onTap,
    bool isVerifying = false,
  }) {
    return GestureDetector(
      onTap: isVerifying ? null : onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: imagePath != null
                    ? AppColors.primary
                    : AppColors.primaryNavyBlue.withValues(alpha: 0.2),
                width: imagePath != null ? 2 : 1,
              ),
              image: imagePath != null
                  ? DecorationImage(
                image: imagePath.startsWith('http')
                    ? NetworkImage(imagePath) as ImageProvider
                    : FileImage(File(imagePath)),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: isVerifying
                ? const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryNavyBlue,
                ),
              ),
            )
                : imagePath == null
                ? const Icon(Icons.download_rounded,
                size: 28, color: AppColors.primaryNavyBlue)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.label.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}