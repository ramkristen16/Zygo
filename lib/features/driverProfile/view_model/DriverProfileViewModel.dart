import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../service/vehicle_vision_service.dart';


enum PhotoType { profile, front, back }

class DriverProfileViewModel extends ChangeNotifier {



  static const List<String> vehicleTypes = [
    'Moto',//1place
    'Voiture',//2à7
    'Camionnette',//2à9
    'Bus',//10à60
  ];


  static List<String> seatsFor(String? vehicleType) {
    switch (vehicleType) {
      case 'Moto':
        return ['1'];
      case 'Voiture':
        return ['2', '3', '4', '5', '6', '7'];
      case 'Camionnette':
        return ['2', '3', '4', '5', '6', '7', '8', '9'];
      case 'Bus':
        return List.generate(51, (i) => (i + 10).toString()); // 10 à 60
      default:
        return ['1'];
    }
  }


//Marque entré en texte libre par le conducteur
  final TextEditingController vehicleBrandController = TextEditingController();

  String? selectedVehicleType;
  int? selectedSeats;

  File? _profilePhotoFile;
  File? _vehicleFrontFile;
  File? _vehicleBackFile;

  String? profilePhotoPath;
  String? vehicleFrontPath;
  String? vehicleBackPath;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isVerifying = false;
  bool get isVerifying => _isVerifying;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final ImagePicker _picker = ImagePicker();



  void setVehicleType(String? value) {
    selectedVehicleType = value;
    if (value == 'Moto') {
      selectedSeats = 1;
    } else {
      selectedSeats = null; // l'utilisateur choisit
    }
    notifyListeners();
  }

  void setSeats(int? value) {
    selectedSeats = value;
    notifyListeners();
  }



  Future<void> pickPhoto(BuildContext context, PhotoType type) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1200,
    );

    if (picked == null) return;

    final file = File(picked.path);

    // Vérification Cloud Vision uniquement pour avant/arrière du véhicule
    if (type == PhotoType.front || type == PhotoType.back) {
      if (selectedVehicleType == null) {
        _setError("Sélectionnez d'abord le type de véhicule.");
        return;
      }

      _isVerifying = true;
      _errorMessage = null;
      notifyListeners();

      final result = await VehicleVisionService.verifyVehiclePhoto(
        imageFile: file,
        vehicleType: selectedVehicleType!,
      );

      _isVerifying = false;

      if (!result.isValid && !result.isWarningOnly) {
        _setError(result.reason ?? "Photo invalide.");
        return;
      }

      if (!result.isValid && result.isWarningOnly) {
        _errorMessage = result.reason;
      }
    }

    switch (type) {
      case PhotoType.profile:
        _profilePhotoFile = file;
        profilePhotoPath = picked.path;
        break;
      case PhotoType.front:
        _vehicleFrontFile = file;
        vehicleFrontPath = picked.path;
        break;
      case PhotoType.back:
        _vehicleBackFile = file;
        vehicleBackPath = picked.path;
        break;
    }

    notifyListeners();
  }

  Future<ImageSource?> _showSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Prendre une photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choisir depuis la galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  //  Validation et soumission

  Future<void> submit(BuildContext context) async {
    final brand = vehicleBrandController.text.trim();

    if (brand.isEmpty) {
      _setError("Veuillez indiquer la marque et le modèle du véhicule.");
      return;
    }
    if (selectedVehicleType == null) {
      _setError("Veuillez sélectionner le type de véhicule (Moto ou Voiture).");
      return;
    }
    if (selectedSeats == null) {
      _setError("Veuillez indiquer le nombre de places.");
      return;
    }
    if (_profilePhotoFile == null) {
      _setError("Veuillez ajouter votre photo de profil.");
      return;
    }
    if (_vehicleFrontFile == null || _vehicleBackFile == null) {
      _setError("Veuillez ajouter les photos avant et arrière du véhicule.");
      return;
    }

    _setLoading(true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final profileUrl = await _uploadPhoto(
          _profilePhotoFile!, 'users/$uid/profile.jpg');
      final frontUrl = await _uploadPhoto(
          _vehicleFrontFile!, 'users/$uid/vehicle_front.jpg');
      final backUrl = await _uploadPhoto(
          _vehicleBackFile!, 'users/$uid/vehicle_back.jpg');

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'vehicleBrand': brand,
        'vehicleType': selectedVehicleType,
        'seats': selectedSeats,
        'profilePhotoUrl': profileUrl,
        'vehicleFrontUrl': frontUrl,
        'vehicleBackUrl': backUrl,
        'driverProfileComplete': true,
        'driverStatus': 'en_attente', // en attente de validation admin
      });

      _setLoading(false);
      if (context.mounted) context.go('/home');
    } catch (e) {
      _setError("Une erreur est survenue. Réessayez.");
      _setLoading(false);
    }
  }

  Future<String> _uploadPhoto(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    vehicleBrandController.dispose();
    super.dispose();
  }
}