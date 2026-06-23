enum UserRole { passenger, driver }
class UserModel {
  final String uid;
  final String name;
  final String email;
  //1 utilisateur peut etre passager et conducteur
  final List<UserRole> roles;

  final String? phoneNumber;
  final String? vehicleType;
  final int? seats;
  final String? profilePhotoUrl;
  final String? vehicleFrontUrl;
  final String? vehicleBackUrl;
  final bool driverProfileComplete;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.roles,
    this.phoneNumber,
    this.vehicleType,
    this.seats,
    this.profilePhotoUrl,
    this.vehicleFrontUrl,
    this.vehicleBackUrl,
    this.driverProfileComplete = false,
  });

  bool get isDriver => roles.contains(UserRole.driver);
  bool get isPassenger => roles.contains(UserRole.passenger);

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

    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      roles: roles,
      phoneNumber: map['phoneNumber'] as String?,
      vehicleType: map['vehicleType'] as String?,
      seats: map['seats'] as int?,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      vehicleFrontUrl: map['vehicleFrontUrl'] as String?,
      vehicleBackUrl: map['vehicleBackUrl'] as String?,
      driverProfileComplete: map['driverProfileComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'roles': roles.map((r) => r == UserRole.driver ? 'driver' : 'passenger').toList(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (seats != null) 'seats': seats,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      if (vehicleFrontUrl != null) 'vehicleFrontUrl': vehicleFrontUrl,
      if (vehicleBackUrl != null) 'vehicleBackUrl': vehicleBackUrl,
      'driverProfileComplete': driverProfileComplete,
    };
  }

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    List<UserRole>? roles,
    String? vehicleType,
    int? seats,
    String? profilePhotoUrl,
    String? vehicleFrontUrl,
    String? vehicleBackUrl,
    bool? driverProfileComplete,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      roles: roles ?? this.roles,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      seats: seats ?? this.seats,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      vehicleFrontUrl: vehicleFrontUrl ?? this.vehicleFrontUrl,
      vehicleBackUrl: vehicleBackUrl ?? this.vehicleBackUrl,
      driverProfileComplete: driverProfileComplete ?? this.driverProfileComplete,
    );
  }
}