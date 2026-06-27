import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_client.dart';
import 'session_manager.dart';

/// Service responsible for authentication operations against the backend.
class AuthService {
  final ApiClient _api = ApiClient.instance;
  final SessionManager _session = SessionManager.instance;

  /// Registers a new user via POST `/api/v1/authentication/sign-up`.
  ///
  /// [fullName] maps to the backend's `fullName` field.
  /// [role] should be the UI label (`'cliente'` or `'proveedor'`); it is
  /// automatically converted to the backend enum (`REQUESTER` / `PROVIDER`).
  Future<User?> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': User.uiRoleToBackend(role),
      };

      final json = await _api.post(ApiConfig.signUp, body: body);
      final user = User.fromJson(json as Map<String, dynamic>);
      _session.saveSession(token: user.token, user: user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Authenticates an existing user via POST `/api/v1/authentication/sign-in`.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
      };

      final json = await _api.post(ApiConfig.signIn, body: body);
      final user = User.fromJson(json as Map<String, dynamic>);
      _session.saveSession(token: user.token, user: user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Quick demo login — attempts to sign in with hardcoded demo credentials.
  ///
  /// If the demo account does not exist on the backend, it is created first
  /// via sign-up and then a sign-in is performed.
  Future<User?> demoLogin() async {
    const demoEmail = 'demo@fueltrack.com';
    const demoPassword = 'Demo1234!';
    const demoName = 'FuelTrack Demo';

    try {
      return await signIn(email: demoEmail, password: demoPassword);
    } catch (_) {
      // Account may not exist yet — try to register it first.
      try {
        return await signUp(
          fullName: demoName,
          email: demoEmail,
          password: demoPassword,
          role: 'cliente',
        );
      } catch (_) {
        // If sign-up also fails (e.g. already registered but wrong password),
        // rethrow the original sign-in error.
        rethrow;
      }
    }
  }

  /// Clears the local session.
  Future<void> logout() async {
    _session.clear();
  }

  /// Checks whether an email is already registered.
  ///
  /// Currently the backend does not expose a dedicated endpoint for this, so
  /// we always return `false` and rely on the sign-up error response.
  Future<bool> emailExists(String email) async {
    return false;
  }
}