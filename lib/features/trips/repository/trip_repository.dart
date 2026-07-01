import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../../shared/models/trip_model.dart';

class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tripsCollection =>
      _firestore.collection('trips');


  Future<List<TripModel>> getAllActiveTrips({required int minSeats}) async {
    final snapshot = await _tripsCollection
        .where('status', isEqualTo: 'actif')
        .where('availableSeats', isGreaterThanOrEqualTo: minSeats)
        .get();

    return snapshot.docs
        .map((doc) => TripModel.fromMap(doc.id, doc.data()))
        .toList();
  }



  Future<List<TripModel>> getTripsBySameDestination({
    required String destinationAddress,
    required int minSeats,
  }) async {
    final snapshot = await _tripsCollection
        .where('status', isEqualTo: 'actif')
        .where('destinationAddress', isEqualTo: destinationAddress)
        .where('availableSeats', isGreaterThanOrEqualTo: minSeats)
        .get();

    return snapshot.docs
        .map((doc) => TripModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  //  Filtre 3 : "Proche de destination" — recherche géospatiale GPS
  //  GeoFlutterFire calcule la distance réelle en km entre deux points.

  Future<List<TripModel>> getTripsNearDestination({
    required GeoFirePoint searchPoint,
    required double radiusInKm,
    required int minSeats,
  }) async {
    final stream = GeoCollectionReference<Map<String, dynamic>>(
      _tripsCollection,
    ).subscribeWithin(
      center: searchPoint,
      radiusInKm: radiusInKm,
      field: 'destination',
      geopointFrom: (data) =>
      (data['destination']['geopoint'] as GeoPoint),
      queryBuilder: (query) => query
          .where('status', isEqualTo: 'actif')
          .where('availableSeats', isGreaterThanOrEqualTo: minSeats),
    );

    // On prend le premier résultat du stream (snapshot unique)
    final docs = await stream.first;

    return docs
        .map((doc) => TripModel.fromMap(doc.id, doc.data()!))
        .toList();
  }

  //  Création d'un trajet (côté conducteur)

  Future<String> createTrip(TripModel trip) async {
    final docRef = await _tripsCollection.add(trip.toMap());
    return docRef.id;
  }

  //  Décrémenter les places disponibles après réservation

  Future<void> decrementAvailableSeats(String tripId) async {
    await _tripsCollection.doc(tripId).update({
      'availableSeats': FieldValue.increment(-1),
    });
  }
}