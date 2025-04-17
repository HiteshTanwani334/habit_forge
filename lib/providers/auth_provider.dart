import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;

  AuthProvider(this._prefs) {
    _loadAuthState();
  }

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;

  void _loadAuthState() {
    _isAuthenticated = _prefs.getBool('isAuthenticated') ?? false;
    _userId = _prefs.getString('userId');
    _userEmail = _prefs.getString('userEmail');
  }

  Future<bool> checkAuthState() async {
    _loadAuthState();
    return _isAuthenticated;
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement actual authentication logic
    // For now, we'll just simulate a successful login
    _isAuthenticated = true;
    _userId = 'demo_user_id';
    _userEmail = email;

    // Save auth state
    await _prefs.setBool('isAuthenticated', true);
    await _prefs.setString('userId', _userId!);
    await _prefs.setString('userEmail', _userEmail!);

    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    // TODO: Implement actual signup logic
    // For now, we'll just simulate a successful signup
    _isAuthenticated = true;
    _userId = 'demo_user_id';
    _userEmail = email;

    // Save auth state
    await _prefs.setBool('isAuthenticated', true);
    await _prefs.setString('userId', _userId!);
    await _prefs.setString('userEmail', _userEmail!);

    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;

    // Clear auth state
    await _prefs.remove('isAuthenticated');
    await _prefs.remove('userId');
    await _prefs.remove('userEmail');

    notifyListeners();
  }
} 