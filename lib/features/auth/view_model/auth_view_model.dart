import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/models/user_model.dart';
import '../repository/auth_repository.dart';

enum AuthStatus { idle, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();



  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


  AuthStatus _status = AuthStatus.idle;
  AuthStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isLoading => _status == AuthStatus.loading;

  // UID temporaire stocké entre createAccount et saveUserProfile
  String? _pendingUid;

  // Rôles choisis sur l'Onboarding
  List<UserRole> _selectedRoles = [UserRole.passenger];
  List<UserRole> get selectedRoles => _selectedRoles;


 // select role
  Future<void> selectRole(BuildContext context, UserRole role) async {
    _selectedRoles = [role];
    notifyListeners();
    // Marque l'onboarding comme vu aprés le premier passage, ne sera plus affiché au prochain lancement
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', true);
    if (context.mounted) context.go('/signup');
  }

  //creer un compte sur firebase

  Future<void> createAccount(BuildContext context) async {

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _setError("Veuillez remplir tous les champs.");
      return;
    }

    if (password != confirm) {
      _setError("Les mots de passe ne correspondent pas.");
      return;
    }

    _setStatus(AuthStatus.loading);

    try {
      _pendingUid = await _repository.createAccount(
        email: email,
        password: password,
      );
      _setStatus(AuthStatus.idle);
      if (context.mounted) context.go('/personal-name');
    } catch (e) {
      _handleError(e);
    }
  }

  //sauvegarde le nom dans firestore

  Future<void> saveName(BuildContext context) async {
    if (nameController.text.trim().isEmpty) {
      _setError("Veuillez entrer votre nom.");
      return;
    }

    if (_pendingUid == null) {
      _setError("Session expirée. Veuillez recommencer.");
      return;
    }

    _setStatus(AuthStatus.loading);

    try {
      _currentUser = await _repository.saveUserProfile(
        uid: _pendingUid!,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        roles: _selectedRoles,
      );
      _pendingUid = null;
      _setStatus(AuthStatus.success);
      if (context.mounted) _navigateAfterAuth(context);
    } catch (e) {
      _handleError(e);
    }
  }

  //connexion email + password

  Future<void> login(BuildContext context) async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _setError("Veuillez remplir tous les champs.");
      return;
    }

    _setStatus(AuthStatus.loading);

    try {
      _currentUser = await _repository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _setStatus(AuthStatus.success);
      if (context.mounted) _navigateAfterAuth(context);
    } catch (e) {
      _handleError(e);
    }
  }

  //connexion google
  Future<void> loginWithGoogle(BuildContext context) async {
    _setStatus(AuthStatus.loading);

    try {
      _currentUser = await _repository.signInWithGoogle(
        roles: _selectedRoles,
      );
      _setStatus(AuthStatus.success);
      if (context.mounted) _navigateAfterAuth(context);
    } catch (e) {
      if (e.toString().contains('google-cancelled')) {
        _setStatus(AuthStatus.idle);
      } else {
        _handleError(e);
      }
    }
  }

  //mot de passe oublié

  Future<void> forgotPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _setError("Entrez votre email pour réinitialiser le mot de passe.");
      return;
    }

    _setStatus(AuthStatus.loading);

    try {
      await _repository.sendPasswordResetEmail(email);
      _setStatus(AuthStatus.idle);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email de réinitialisation envoyé à $email',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }

//ajouter un role passager et conducteur
  Future<void> addRole(UserRole role) async {
    if (_currentUser == null) return;
    _currentUser = await _repository.addRole(_currentUser!.uid, role);
    notifyListeners();
  }

  //redirection
  void _navigateAfterAuth(BuildContext context) {
    final user = _currentUser!;
    debugPrint('isDriver: ${user.isDriver}');
    debugPrint('driverProfileComplete: ${user.driverProfileComplete}');
    debugPrint('roles: ${user.roles}');

    if (user.isDriver && !user.driverProfileComplete) {
      context.go('/driver-profile');
    } else {
      context.go('/home');
    }
  }

  //Deconnexion
  Future<void> logout(BuildContext context) async {
    await _repository.signOut();
    _currentUser = null;
    _setStatus(AuthStatus.idle);
    if (context.mounted) context.go('/onboarding');
  }

 //getsion erreurs
  void _handleError(Object e) {
    if (e is FirebaseAuthException) {
      _setError(_mapFirebaseError(e.code));
    } else {
      final msg = e.toString();
      if (msg.contains('email-already-in-use')) {
        _setError(_mapFirebaseError('email-already-in-use'));
      } else if (msg.contains('account-exists-with-different-credential')) {
        _setError(_mapFirebaseError('account-exists-with-different-credential'));
      } else if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
        _setError(_mapFirebaseError('wrong-password'));
      } else if (msg.contains('user-not-found')) {
        _setError(_mapFirebaseError('user-not-found'));
      } else {
        _setError("Une erreur est survenue. Réessayez.");
      }
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Cet email est déjà utilisé. Connectez-vous ou réinitialisez votre mot de passe.";
      case 'account-exists-with-different-credential':
        return "Cet email est déjà lié à un compte Google. Connectez-vous avec Google.";
      case 'invalid-email':
        return "Adresse e-mail invalide.";
      case 'weak-password':
        return "Le mot de passe doit contenir au moins 6 caractères.";
      case 'user-not-found':
        return "Aucun compte trouvé pour cet e-mail.";
      case 'wrong-password':
      case 'invalid-credential':
      // Firebase ne distingue pas les deux pour des raisons de sécurité
        return "E-mail ou mot de passe incorrect.";
      case 'too-many-requests':
        return "Trop de tentatives. Réessayez plus tard.";
      case 'user-disabled':
        return "Ce compte a été désactivé.";
      case 'network-request-failed':
        return "Pas de connexion internet. Vérifiez votre réseau.";
      default:
        return "Erreur : $code";
    }
  }

  //helpers
  void _setStatus(AuthStatus status) {
    _status = status;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}