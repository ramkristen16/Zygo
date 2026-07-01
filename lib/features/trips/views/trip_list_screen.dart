import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../shared/models/trip_model.dart';
import '../viewmodel/trip_viewmodel.dart';

class TripListScreen extends StatelessWidget {
  final Map<String, dynamic>? searchParams;

  const TripListScreen({super.key, this.searchParams});

  @override
  Widget build(BuildContext context) {
    final double lat = searchParams?['startLatitude'] ?? -18.8792;
    final double lng = searchParams?['startLongitude'] ?? 47.5079;
    final int requestedSeats = searchParams?['seats'] ?? 1;

    return ChangeNotifierProvider(
      create: (_) => TripListViewModel()
        ..setSearchParams(
          userPos: GeoFirePoint(GeoPoint(lat, lng)),
          seats: requestedSeats,
        )
        ..applyFilter(TripFilter.all),
      child: _TripListBody(searchParams: searchParams), // Transmis au corps pour l'affichage des textes
    );
  }
}

class _TripListBody extends StatelessWidget {
  final Map<String, dynamic>? searchParams;

  const _TripListBody({this.searchParams});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TripListViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildTitle(),
            const SizedBox(height: 20),
            _buildFilterChips(context, vm),
            const SizedBox(height: 16),
            _buildLocationFields(),
            const SizedBox(height: 16),
            Expanded(child: _buildTripList(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Iconsax.map, size: 24, color: AppColors.primaryNavyBlue),
          SvgPicture.asset('assets/image/logo.svg', height: 28),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text.rich(
      TextSpan(
        style: AppTextStyle.h2.copyWith(
          color: AppColors.primaryNavyBlue,
          height: 1.3,
        ),
        children: [
          const TextSpan(text: 'Véhicules disponibles\nsur votre '),
          TextSpan(
            text: 'itinéraire',
            style: AppTextStyle.h2.copyWith(color: AppColors.primary),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFilterChips(BuildContext context, TripListViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'Tout',
            isActive: vm.currentFilter == TripFilter.all,
            onTap: () => vm.applyFilter(TripFilter.all),
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            label: 'Même destination',
            isActive: vm.currentFilter == TripFilter.sameDestination,
            onTap: () => vm.applyFilter(TripFilter.sameDestination),
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            label: 'Proche de destination',
            isActive: vm.currentFilter == TripFilter.nearDestination,
            onTap: () => vm.applyFilter(TripFilter.nearDestination),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
      BuildContext context, {
        required String label,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.body3.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive
                ? AppColors.textOnYellow
                : AppColors.primaryNavyBlue.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationFields() {
    final startLabel = searchParams?['startName'] ?? 'Votre position';
    final endLabel = searchParams?['endName'] ?? 'Destination';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildLocationField(
            icon: Iconsax.gps,
            label: startLabel,
          ),
          const SizedBox(height: 10),
          _buildLocationField(
            icon: Iconsax.location,
            label: endLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({required IconData icon, required String label}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryNavyBlue.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.body2.copyWith(
                color: AppColors.primaryNavyBlue.withValues(alpha: 0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList(TripListViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Text(
          vm.errorMessage!,
          style: AppTextStyle.body2.copyWith(color: Colors.redAccent),
        ),
      );
    }

    if (vm.trips.isEmpty) {
      return Center(
        child: Text(
          "Aucun trajet disponible pour le moment.",
          style: AppTextStyle.body2.copyWith(
            color: AppColors.primaryNavyBlue.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: vm.trips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildTripCard(vm.trips[index]),
    );
  }

  Widget _buildTripCard(TripModel trip) {
    final hour = trip.departureTime.hour.toString().padLeft(2, '0');
    final minute = trip.departureTime.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: trip.driverPhotoUrl != null
                ? Image.network(
              trip.driverPhotoUrl!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            )
                : Container(
              width: 56,
              height: 56,
              color: AppColors.background,
              child: const Icon(Iconsax.car, color: AppColors.primaryNavyBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.vehicleBrand,
                    style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w700)),
                Text(trip.vehicleType,
                    style: AppTextStyle.body3.copyWith(
                        color: AppColors.primaryNavyBlue.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Text(
                  'Départ à $hour:$minute • ${trip.availableSeats}/${trip.totalSeats} places',
                  style: AppTextStyle.body3.copyWith(
                    color: trip.availableSeats == 0 ? Colors.redAccent : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${trip.pricePerSeat.toInt()} Ar",
            style: AppTextStyle.body1.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primaryNavyBlue,
            ),
          ),
        ],
      ),
    );
  }
}
