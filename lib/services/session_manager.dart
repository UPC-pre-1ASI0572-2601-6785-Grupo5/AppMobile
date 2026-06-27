import '../models/user_model.dart';

/// Simple in-memory session store.
///
/// After a successful sign-in or sign-up the JWT token and user profile are
/// kept here so that [ApiClient] can attach the `Authorization` header
/// automatically and screens can read the current user.
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

  // ── Mutations ─────────────────────────────────────────────────────────

  /// Stores [token] and [user] after a successful authentication.
  void saveSession({required String token, required User user}) {
    _token = token;
    _user = user;
  }

  /// Clears the current session (logout).
  void clear() {
    _token = null;
    _user = null;
  }
}
