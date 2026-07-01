enum UserRole { passenger, driver }

enum DriverStatus {
  enAttente,   // profil soumis, pas encore vérifié
  approuve,    // profil validé , peut publier des trajets
  rejete,      // profil refusé , doit corriger et resoumettre
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<UserRole> roles;
  final String? phoneNumber;

  final String? vehicleBrand;          // ex: "Rexton", "Toyota Yaris" (texte libre)
  final String? vehicleType;           // "Moto" ou "Voiture" , camionnette, Bus
  final int? seats;
  final String? profilePhotoUrl;
  final String? vehicleFrontUrl;
  final String? vehicleBackUrl;
  final bool driverProfileComplete;
  final DriverStatus driverStatus;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.roles,
    this.phoneNumber,
    this.vehicleBrand,
    this.vehicleType,
    this.seats,
    this.profilePhotoUrl,
    this.vehicleFrontUrl,
    this.vehicleBackUrl,
    this.driverProfileComplete = false,
    this.driverStatus = DriverStatus.enAttente,
  });

  bool get isDriver => roles.contains(UserRole.driver);
  bool get isPassenger => roles.contains(UserRole.passenger);
  bool get isDriverApproved => driverStatus == DriverStatus.approuve;

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    List<UserRole> roles;
    if (map['roles'] != null) {
      roles = (map['roles'] as List<dynamic>)
          .map((r) => r == 'driver' ? UserRole.driver : UserRole.passenger)
          .toList();
    } else if (map['role'] != null) {
      roles = [map['role'] == 'driver' ? UserRole.driver : UserRole.passenger];
    } else {
      roles = [UserRole.passenger];
    }

    DriverStatus driverStatus;
    switch (map['driverStatus'] as String? ?? 'en_attente') {
      case 'approuve':
        driverStatus = DriverStatus.approuve;
        break;
      case 'rejete':
        driverStatus = DriverStatus.rejete;
        break;
      default:
        driverStatus = DriverStatus.enAttente;
    }

    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      roles: roles,
      phoneNumber: map['phoneNumber'] as String?,
      vehicleBrand: map['vehicleBrand'] as String?,
      vehicleType: map['vehicleType'] as String?,
      seats: map['seats'] as int?,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      vehicleFrontUrl: map['vehicleFrontUrl'] as String?,
      vehicleBackUrl: map['vehicleBackUrl'] as String?,
      driverProfileComplete: map['driverProfileComplete'] as bool? ?? false,
      driverStatus: driverStatus,
    );
  }

  Map<String, dynamic> toMap() {
    String driverStatusStr;
    switch (driverStatus) {
      case DriverStatus.approuve:
        driverStatusStr = 'approuve';
        break;
      case DriverStatus.rejete:
        driverStatusStr = 'rejete';
        break;
      default:
        driverStatusStr = 'en_attente';
    }

    return {
      'name': name,
      'email': email,
      'roles': roles.map((r) => r == UserRole.driver ? 'driver' : 'passenger').toList(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (vehicleBrand != null) 'vehicleBrand': vehicleBrand,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (seats != null) 'seats': seats,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      if (vehicleFrontUrl != null) 'vehicleFrontUrl': vehicleFrontUrl,
      if (vehicleBackUrl != null) 'vehicleBackUrl': vehicleBackUrl,
      'driverProfileComplete': driverProfileComplete,
      'driverStatus': driverStatusStr,
    };
  }

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    List<UserRole>? roles,
    String? vehicleBrand,
    String? vehicleType,
    int? seats,
    String? profilePhotoUrl,
    String? vehicleFrontUrl,
    String? vehicleBackUrl,
    bool? driverProfileComplete,
    DriverStatus? driverStatus,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      roles: roles ?? this.roles,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleType: vehicleType ?? this.vehicleType,
      seats: seats ?? this.seats,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      vehicleFrontUrl: vehicleFrontUrl ?? this.vehicleFrontUrl,
      vehicleBackUrl: vehicleBackUrl ?? this.vehicleBackUrl,
      driverProfileComplete: driverProfileComplete ?? this.driverProfileComplete,
      driverStatus: driverStatus ?? this.driverStatus,
    );
  }
}