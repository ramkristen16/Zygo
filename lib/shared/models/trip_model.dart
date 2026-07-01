import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class TripModel {
  final String tripId;
  final String driverId;
  final String driverName;
  final String? driverPhotoUrl;

  final String vehicleBrand;    // marque : Rexton, Toyota
  final String vehicleType;     // "Moto" ou "Voiture" , Camionnette , Bus

  final GeoFirePoint origin;
  final String originAddress;
  final GeoFirePoint destination;
  final String destinationAddress;

  final DateTime departureTime;
  final int totalSeats;
  final int availableSeats;
  final double pricePerSeat;

  // "actif" , "termine" ,"annule"
  final String status;

  const TripModel({
    required this.tripId,
    required this.driverId,
    required this.driverName,
    this.driverPhotoUrl,
    required this.vehicleBrand,
    required this.vehicleType,
    required this.origin,
    required this.originAddress,
    required this.destination,
    required this.destinationAddress,
    required this.departureTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.pricePerSeat,
    this.status = 'actif',
  });

  bool get isFull => availableSeats <= 0;
  bool get isMoto => vehicleType == 'Moto';
  bool get isVoiture => vehicleType == 'Voiture';

  factory TripModel.fromMap(String tripId, Map<String, dynamic> map) {
    return TripModel(
      tripId: tripId,
      driverId: map['driverId'] as String,
      driverName: map['driverName'] as String? ?? '',
      driverPhotoUrl: map['driverPhotoUrl'] as String?,
      vehicleBrand: map['vehicleBrand'] as String? ?? '',
      vehicleType: map['vehicleType'] as String? ?? 'Voiture',
      origin: GeoFirePoint(
        GeoPoint(
          (map['origin']['geopoint'] as GeoPoint).latitude,
          (map['origin']['geopoint'] as GeoPoint).longitude,
        ),
      ),
      originAddress: map['originAddress'] as String? ?? '',
      destination: GeoFirePoint(
        GeoPoint(
          (map['destination']['geopoint'] as GeoPoint).latitude,
          (map['destination']['geopoint'] as GeoPoint).longitude,
        ),
      ),
      destinationAddress: map['destinationAddress'] as String? ?? '',
      departureTime: (map['departureTime'] as Timestamp).toDate(),
      totalSeats: map['totalSeats'] as int? ?? 1,
      availableSeats: map['availableSeats'] as int? ?? 0,
      pricePerSeat: (map['pricePerSeat'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'actif',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      if (driverPhotoUrl != null) 'driverPhotoUrl': driverPhotoUrl,
      'vehicleBrand': vehicleBrand,
      'vehicleType': vehicleType,
      'origin': origin.data,
      'originAddress': originAddress,
      'destination': destination.data,
      'destinationAddress': destinationAddress,
      'departureTime': Timestamp.fromDate(departureTime),
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'pricePerSeat': pricePerSeat,
      'status': status,
    };
  }
}