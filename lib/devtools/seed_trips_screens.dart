import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:go_router/go_router.dart';

import '../features/trips/repository/trip_repository.dart';
import '../shared/models/trip_model.dart';

//Ecran de test
class SeedTripsScreen extends StatelessWidget {
  const SeedTripsScreen({super.key});

  Future<void> _seed(BuildContext context) async {
    final repo = TripRepository();

    // Coordonnées réelles d'Antananarivo, pour rester cohérent avec ta maquette
    final trips = [
      TripModel(
        tripId: '', // ignoré, Firestore génère l'ID
        driverId: 'mock_driver_1',
        driverName: 'Andry Rakoto',
        driverPhotoUrl: null,
        vehicleBrand: 'Mercedes-Benz',
        vehicleType: 'voiture',
        origin: GeoFirePoint(const GeoPoint(-18.8792, 47.5079)), // Antananarivo centre
        originAddress: 'Andohalo, Antananarivo',
        destination: GeoFirePoint(const GeoPoint(-18.9100, 47.5255)), // Ankadikely
        destinationAddress: 'Ankadikely Ilafy',
        departureTime: DateTime.now().add(const Duration(hours: 1)),
        totalSeats: 7,
        availableSeats: 7,
        pricePerSeat: 5000,
      ),
      TripModel(
        tripId: '',
        driverId: 'mock_driver_2',
        driverName: 'Voahangy Rasoa',
        driverPhotoUrl: null,
        vehicleBrand: 'Mani',
        vehicleType: 'moto',
        origin: GeoFirePoint(const GeoPoint(-18.8800, 47.5100)),
        originAddress: 'Analakely, Antananarivo',
        destination: GeoFirePoint(const GeoPoint(-18.9050, 47.5200)),
        destinationAddress: 'Ambatobe',
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        totalSeats: 4,
        availableSeats: 2,
        pricePerSeat: 3000,
      ),
      TripModel(
        tripId: '',
        driverId: 'mock_driver_3',
        driverName: 'Hery Andria',
        driverPhotoUrl: null,
        vehicleBrand: 'Sprinter',
        vehicleType: 'Bus',
        origin: GeoFirePoint(const GeoPoint(-18.8750, 47.5000)),
        originAddress: 'Ivandry, Antananarivo',
        destination: GeoFirePoint(const GeoPoint(-18.9150, 47.5300)),
        destinationAddress: 'Ankadikely Ilafy',
        departureTime: DateTime.now().add(const Duration(hours: 3)),
        totalSeats: 6,
        availableSeats: 0, // pour tester le badge "Complet"
        pricePerSeat: 4000,
      ),
    ];

    for (final trip in trips) {
      await repo.createTrip(trip);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('3 trajets de test ajoutés à Firestore !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seed Trips (TEMP)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premier bouton : Injection des données
            ElevatedButton(
              onPressed: () => _seed(context),
              child: const Text('1. Injecter 3 trajets de test'),
            ),

            const SizedBox(height: 24),

            // Deuxième bouton : Redirection vers l'écran de liste
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final simulatedQueryParams = {
                  'startLatitude': -18.8792,
                  'startLongitude': 47.5079,
                  'startName': 'Andohalo (Centre)',

                  // Ajout des points clés d'Ankadikely Ilafy pour rassasier les filtres
                  'endLatitude': -18.9100,
                  'endLongitude': 47.5255,
                  'endName': 'Ankadikely Ilafy',

                  'seats': 1,
                };

                context.go('/trips', extra: simulatedQueryParams);
              },
              child: const Text('2. Voir la liste des véhicules disponibles'),
            ),
          ],
        ),
      ),
    );
  }
}
