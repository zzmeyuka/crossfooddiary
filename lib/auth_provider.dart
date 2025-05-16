import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isGuest = false;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null && !_isGuest;
  bool get isGuest => _isGuest;

  Future<void> login(String email, String password) async {
    _isGuest = false;
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password, BuildContext context) async {
    _isGuest = false;
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    _isGuest = false;
    await _auth.signOut();
  }

  void loginAsGuest() {
    _user = null;
    _isGuest = true;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  signInWithEmail(String trim, String trim2) {}
}
