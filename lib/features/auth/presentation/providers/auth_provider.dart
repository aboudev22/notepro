import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:notepro/features/auth/data/services/auth_service.dart';
import 'package:notepro/features/auth/domain/models/user.dart' as app_user;

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  firebase_auth.User? _user;
  bool _isAdmin = false;
  bool _isLoading = false;

  AuthProvider(this._authService) {
    _init();
  }

  firebase_auth.User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    // Écouter les changements d'état d'authentification
    _authService.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        _isAdmin = await _authService.isAdmin();
      } else {
        _isAdmin = false;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signUpWithEmailAndPassword(
        email,
        password,
        displayName,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
