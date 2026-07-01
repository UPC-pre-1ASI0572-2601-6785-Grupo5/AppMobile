import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Session store with local persistence.
class SessionManager {
  SessionManager._();
  static final SessionManager _instance = SessionManager._();

  /// Singleton accessor.
  static SessionManager get instance => _instance;

  String? _token;
  User? _user;

  // ── Accessors ─────────────────────────────────────────────────────────

  /// The current JWT token, or `null` when not logged in.
  String? get token => _token;

  /// The authenticated user profile, or `null` when not logged in.
  User? get user => _user;

  /// Whether a session is currently active.
  bool get isLoggedIn => _token != null;

  // ── Initialization ──────────────────────────────────────────────────────

  /// Loads the session from local storage on app start.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('session_token');
    
    final userJson = prefs.getString('session_user');
    if (userJson != null) {
      try {
        _user = User.fromJson(jsonDecode(userJson));
      } catch (e) {
        // Ignorar si hay un error de parseo (version vieja, etc)
        _user = null;
        _token = null; 
      }
    }
  }

  // ── Mutations ─────────────────────────────────────────────────────────

  /// Stores [token] and [user] after a successful authentication.
  Future<void> saveSession({required String token, required User user}) async {
    _token = token;
    _user = user;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', token);
    await prefs.setString('session_user', jsonEncode(user.toJson()));
  }

  /// Clears the current session (logout).
  Future<void> clear() async {
    _token = null;
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    await prefs.remove('session_user');
  }
}
