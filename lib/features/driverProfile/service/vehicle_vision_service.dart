import 'dart:io';
import 'package:flutter/foundation.dart';

class VehicleVisionService {
  static const String _apiKey = String.fromEnvironment('VISION_API_KEY');

  static const String _endpoint =
      'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey';

  static Future<VisionResult> verifyVehiclePhoto({
    required File imageFile,
    required String vehicleType,
  }) async {

    //  MODE MOCK — retourne toujours valide
    //  À remplacer par le bloc HTTP ci-dessous une fois le compte
    //  de facturation Google Cloud configuré.
    debugPrint('VehicleVisionService: vérification désactivée (mode mock)');
    return VisionResult(isValid: true);

    //  MODE RÉEL — décommenter quand la clé API est prête
    // try {
    //   final bytes = await imageFile.readAsBytes();
    //   final base64Image = base64Encode(bytes);
    //
    //   final response = await http.post(
    //     Uri.parse(_endpoint),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       'requests': [
    //         {
    //           'image': {'content': base64Image},
    //           'features': [
    //             {'type': 'LABEL_DETECTION', 'maxResults': 15},
    //           ],
    //         },
    //       ],
    //     }),
    //   );
    //
    //   debugPrint('Vision API ${response.statusCode}: ${response.body}');
    //
    //   if (response.statusCode != 200) {
    //     return VisionResult(
    //       isValid: false,
    //       reason: 'Erreur de connexion au service de vérification.',
    //     );
    //   }
    //
    //   final data = jsonDecode(response.body);
    //   final annotations = data['responses']?[0]?['labelAnnotations'] as List?;
    //
    //   if (annotations == null || annotations.isEmpty) {
    //     return VisionResult(isValid: false, reason: 'Aucun objet détecté.');
    //   }
    //
    //   final detectedLabels = annotations
    //       .map((a) => (a['description'] as String).toLowerCase())
    //       .toList();
    //
    //   const vehicleWords = ['car','vehicle','motorcycle','van','truck','bus'];
    //   final hasVehicle = detectedLabels
    //       .any((l) => vehicleWords.any((kw) => l.contains(kw)));
    //
    //   if (!hasVehicle) {
    //     return VisionResult(
    //       isValid: false,
    //       reason: 'Cette photo ne semble pas contenir de véhicule.',
    //     );
    //   }
    //
    //   return VisionResult(isValid: true);
    // } catch (e) {
    //   return VisionResult(isValid: false, reason: 'Impossible de vérifier.');
    // }
  }
}

class VisionResult {
  final bool isValid;
  final String? reason;
  final bool isWarningOnly;

  VisionResult({
    required this.isValid,
    this.reason,
    this.isWarningOnly = false,
  });
}