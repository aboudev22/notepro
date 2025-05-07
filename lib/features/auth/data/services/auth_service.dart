import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepro/features/auth/domain/models/user.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Stream pour écouter les changements d'état d'authentification
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Récupérer l'utilisateur actuel
  firebase_auth.User? get currentUser => _auth.currentUser;

  // Vérifier si l'utilisateur est connecté
  bool get isAuthenticated => currentUser != null;

  // Vérifier si l'utilisateur est admin
  Future<bool> isAdmin() async {
    if (!isAuthenticated) return false;

    final userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();

    if (!userDoc.exists) return false;

    final userData = app_user.User.fromFirestore(userDoc);
    return userData.isAdmin;
  }

  // Connexion avec email et mot de passe
  Future<firebase_auth.User> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Erreur de connexion: utilisateur non créé');
      }

      // Mettre à jour la dernière connexion
      await _firestore.collection('users').doc(userCredential.user!.uid).update(
        {'lastLogin': FieldValue.serverTimestamp()},
      );

      // Sauvegarder le token
      final token = await userCredential.user!.getIdToken();
      if (token != null) {
        await _saveToken(token);
      }

      return userCredential.user!;
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Inscription avec email et mot de passe
  Future<firebase_auth.User> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Erreur d\'inscription: utilisateur non créé');
      }

      // Créer le document utilisateur dans Firestore
      final user = app_user.User(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        isAdmin: false,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      // Sauvegarder le token
      final token = await userCredential.user!.getIdToken();
      if (token != null) {
        await _saveToken(token);
      }

      return userCredential.user!;
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _clearToken();
    } catch (e) {
      throw Exception('Erreur de déconnexion: $e');
    }
  }

  // Sauvegarder le token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Récupérer le token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Supprimer le token
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Vérifier si le token est valide
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      await _auth.currentUser?.getIdToken(true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
