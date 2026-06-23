import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;


  Future<String> createAccount({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential.user!.uid;
  }



  Future<UserModel> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required List<UserRole> roles,
  }) async {
    await _auth.currentUser?.updateDisplayName(name.trim());

    final user = UserModel(
      uid: uid,
      name: name.trim(),
      email: email.trim(),
      roles: roles,
    );

    await _firestore.collection('users').doc(uid).set(user.toMap());
    return user;
  }

 //s'inscrire avec un email
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final uid = credential.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return UserModel(
        uid: uid,
        name: credential.user!.displayName ?? '',
        email: email.trim(),
        roles: [UserRole.passenger],
      );
    }

    return UserModel.fromMap(uid, doc.data()!);
  }


//connnexion avec google
  Future<UserModel> signInWithGoogle({
    List<UserRole> roles = const [UserRole.passenger],
  }) async {
    final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('google-cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final uid = userCredential.user!.uid;
  //si google donc on entre plsu le profilName mais automatiquement ,il prend le nom de l'email géré par firestore
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(uid, doc.data()!);
    }

    // Nouveau compte Google , crée le profil
    await userCredential.user!.reload();
    final refreshedUser = _auth.currentUser;

    final user = UserModel(
      uid: uid,
      name: refreshedUser?.displayName ??
          googleUser.displayName ??
          googleUser.email.split('@')[0],
      email: refreshedUser?.email ?? googleUser.email,
      roles: roles,
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());
    return user;
  }


 //mot de passe oublié
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  //ajouter un role à chaque compte
  Future<UserModel> addRole(String uid, UserRole newRole) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final user = UserModel.fromMap(uid, doc.data()!);

    if (user.roles.contains(newRole)) return user; // déjà présent

    final updatedRoles = [...user.roles, newRole];
    await _firestore.collection('users').doc(uid).update({
      'roles': updatedRoles
          .map((r) => r == UserRole.driver ? 'driver' : 'passenger')
          .toList(),
    });

    return user.copyWith(roles: updatedRoles);
  }


 // Déconnexion
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  //session persistante
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(firebaseUser.uid, doc.data()!);
  }
}