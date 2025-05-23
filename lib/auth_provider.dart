import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  bool _isGuest = false;

  ThemeMode _themeMode = ThemeMode.light;
  String _languageCode = 'en';
  String _userName = '';
  int _kcalGoal = 2000;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null && !_isGuest;
  bool get isGuest => _isGuest;
  ThemeMode get themeMode => _themeMode;
  String get languageCode => _languageCode;
  String get userName => _userName;
  int get kcalGoal => _kcalGoal;

  Future<void> login(String email, String password) async {
    _isGuest = false;
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithEmail(String email, String password) async {
    _isGuest = false;
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password, String name, int kcalGoal) async {
    _isGuest = false;
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    _user = result.user;
    final box = Hive.box('local_data');
    box.put('wasAuthenticated', true);       // метка, что вход был
    box.put('pin_code', '1234');             // выбери свой PIN


    await _db.collection('users').doc(_user!.uid).set({
      'email': email,
      'name': name,
      'kcalGoal': kcalGoal,
      'theme': 'light',
      'language': 'en',
    });

    _userName = name;
    _kcalGoal = kcalGoal;
    notifyListeners();
  }

  Future<void> logout() async {
    _isGuest = false;
    await _auth.signOut();
    notifyListeners();
  }

  void loginAsGuest() {
    _user = null;
    _isGuest = true;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) async {
    _user = user;
    if (_user != null && !_isGuest) {
      await loadPreferences();
    }
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await savePreferences();
  }

  Future<void> setLanguage(String langCode) async {
    _languageCode = langCode;
    notifyListeners();
    await savePreferences();
  }

  Future<void> savePreferences() async {
    if (_user != null && !_isGuest) {
      await _db.collection('users').doc(_user!.uid).set({
        'theme': _themeMode == ThemeMode.dark ? 'dark' : 'light',
        'language': _languageCode,
        'name': _userName,
        'kcalGoal': _kcalGoal,
      }, SetOptions(merge: true));
    }
  }

  Future<void> loadPreferences() async {
    if (_user == null) return;

    try {
      final doc = await _db.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          _themeMode = data['theme'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
          _languageCode = data['language'] ?? 'en';
          _userName = data['name'] ?? '';
          _kcalGoal = data['kcalGoal'] ?? 2000;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Failed to load preferences: $e');
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    savePreferences();
    notifyListeners();
  }

  void setLanguageCode(String code) {
    _languageCode = code;
    savePreferences();
    notifyListeners();
  }

  Future<void> updateProfile(String name, int kcalGoal) async {
    if (_user == null || _isGuest) return;

    _userName = name;
    _kcalGoal = kcalGoal;
    notifyListeners();

    try {
      await _db.collection('users').doc(_user!.uid).update({
        'name': name,
        'kcalGoal': kcalGoal,
      });
    } catch (e) {
      debugPrint("Failed to update profile: $e");
    }
  }


}
