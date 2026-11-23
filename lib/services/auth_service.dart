import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isGoogleSignInInitialized = false;

  // Escucha en tiempo real si hay una sesión activa
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual de Firebase Auth
  User? get currentUser => _auth.currentUser;

  // Inicializa GoogleSignIn una sola vez (requerido en v7.x)
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await GoogleSignIn.instance.initialize();
      _isGoogleSignInInitialized = true;
    }
  }

  // 1. Registro con Correo y Contraseña
  Future<UserModel?> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

    final User? user = credential.user;
    if (user == null) return null;

    await user.updateDisplayName(name.trim());

    final newUser = UserModel(
      uid: user.uid,
      name: name.trim(),
      email: email.trim(),
      photoUrl: user.photoURL,
      isSeller: false,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
    return newUser;
  }

  // 2. Inicio de Sesión con Correo y Contraseña
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final User? user = credential.user;
    if (user == null) return null;

    return await getUserData(user.uid);
  }

  // 3. Inicio de Sesión con Google (Web + Móvil, compatible con v7.x)
  Future<UserModel?> signInWithGoogle() async {
    UserCredential credential;

    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      credential = await _auth.signInWithPopup(googleProvider);
    } else {
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount googleUser;
      try {
        googleUser = await GoogleSignIn.instance.authenticate();
      } on GoogleSignInException catch (e) {
        // Si el usuario cierra la ventana sin elegir cuenta
        if (e.code == GoogleSignInExceptionCode.canceled) {
          return null;
        }
        rethrow;
      }

      // En v7.x authentication es síncrono y Firebase solo necesita el idToken
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential oauthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      credential = await _auth.signInWithCredential(oauthCredential);
    }

    final User? user = credential.user;
    if (user == null) return null;

    // Verificar si ya existe en Firestore; si es nuevo, guardarlo
    final docRef = _firestore.collection('users').doc(user.uid);
    final docSnap = await docRef.get();

    if (docSnap.exists && docSnap.data() != null) {
      return UserModel.fromMap(docSnap.data()!);
    } else {
      final newUser = UserModel(
        uid: user.uid,
        name: user.displayName ?? 'Usuario',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        isSeller: false,
        createdAt: DateTime.now(),
      );
      await docRef.set(newUser.toMap());
      return newUser;
    }
  }

  // 4. Obtener datos completos del usuario desde Firestore
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // 5. Activar modo vendedor (Multi-Vendedor)
  Future<void> activateSellerMode({
    required String uid,
    required String storeName,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'isSeller': true,
      'storeName': storeName.trim(),
    });
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    String? photoUrl,
    String? phone,
    String? bio,
    String? address,
    String? storeName,
  }) async {
    final Map<String, dynamic> updates = {
      'name': name.trim(),
      'phone': phone?.trim().isEmpty == true ? null : phone?.trim(),
      'bio': bio?.trim().isEmpty == true ? null : bio?.trim(),
      'address': address?.trim().isEmpty == true ? null : address?.trim(),
    };

    if (photoUrl != null) {
      updates['photoUrl'] = photoUrl;
    }

    if (storeName != null && storeName.trim().isNotEmpty) {
      updates['storeName'] = storeName.trim();
    }

    await _firestore.collection('users').doc(uid).update(updates);

    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name.trim());
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
    }
  }

  // 6. Cerrar Sesión
  Future<void> signOut() async {
    if (!kIsWeb) {
      await _ensureGoogleSignInInitialized();
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
  }
}
