import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _checkCurrentSession();
  }

  // Revisa si ya había una sesión guardada al abrir la app
  Future<void> _checkCurrentSession() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      _user = await _authService.getUserData(currentUser.uid);
    }
    _isInitializing = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    return _runAuthAction(() async {
      _user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
    });
  }

  Future<bool> registerWithEmail(
    String name,
    String email,
    String password,
  ) async {
    return _runAuthAction(() async {
      _user = await _authService.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  Future<bool> signInWithGoogle() async {
    return _runAuthAction(() async {
      _user = await _authService.signInWithGoogle();
    });
  }

  Future<bool> activateSellerMode(String storeName) async {
    if (_user == null) return false;
    return _runAuthAction(() async {
      await _authService.activateSellerMode(
        uid: _user!.uid,
        storeName: storeName,
      );
      _user = await _authService.getUserData(_user!.uid);
    });
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      return _user != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'invalid-email':
        return 'El formato del correo no es válido.';
      default:
        return 'Error de autenticación ($code).';
    }
  }
}
