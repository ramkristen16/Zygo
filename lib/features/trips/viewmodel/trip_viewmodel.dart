import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../../shared/models/trip_model.dart';
import '../repository/trip_repository.dart';

enum TripFilter { all, sameDestination, nearDestination }

class TripListViewModel extends ChangeNotifier {
  final TripRepository _repository;

  TripListViewModel({TripRepository? repository})
      : _repository = repository ?? TripRepository();


  GeoFirePoint? userPosition; // position actuelle du passager
  GeoFirePoint? searchDestination; // destination recherchée
  String? searchDestinationAddress;
  int requiredSeats = 1;

  // Rayon de recherche pour "Proche de destination", en km.
  static const double defaultRadiusKm = 5.0;

  //  État

  TripFilter _currentFilter = TripFilter.all;
  TripFilter get currentFilter => _currentFilter;

  List<TripModel> _trips = [];
  List<TripModel> get trips => _trips;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //  Initialisation des paramètres de recherche

  void setSearchParams({
    required GeoFirePoint userPos,
    GeoFirePoint? destination,
    String? destinationAddress,
    int seats = 1,
  }) {
    userPosition = userPos;
    searchDestination = destination;
    searchDestinationAddress = destinationAddress;
    requiredSeats = seats;
  }

//relance automatique la recherche
  Future<void> applyFilter(TripFilter filter) async {
    _currentFilter = filter;
    notifyListeners();
    await search();
  }


  //  Recherche selon le filtre actif

  Future<void> search() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      switch (_currentFilter) {
        case TripFilter.all:
          _trips = await _repository.getAllActiveTrips(
            minSeats: requiredSeats,
          );
          break;

        case TripFilter.sameDestination:
          if (searchDestinationAddress == null) {
            _errorMessage = "Veuillez indiquer une destination.";
            _trips = [];
            break;
          }
          _trips = await _repository.getTripsBySameDestination(
            destinationAddress: searchDestinationAddress!,
            minSeats: requiredSeats,
          );
          break;

        case TripFilter.nearDestination:
          if (searchDestination == null) {
            _errorMessage = "Veuillez indiquer une destination.";
            _trips = [];
            break;
          }
          _trips = await _repository.getTripsNearDestination(
            searchPoint: searchDestination!,
            radiusInKm: defaultRadiusKm,
            minSeats: requiredSeats,
          );
          break;
      }
    } catch (e) {
      _errorMessage = "Impossible de charger les trajets. Réessayez.";
      _trips = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}