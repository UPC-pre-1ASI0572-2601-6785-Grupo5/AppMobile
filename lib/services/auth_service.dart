import '../models/user_model.dart';

class AuthService {
  Future<User?> signUp({
    required String companyName,
    required String email,
    required String password,
    required String role,
    required bool acceptedTerms,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (companyName.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Todos los campos son requeridos');
      }

      if (role.isEmpty) {
        throw Exception('Debes seleccionar un rol');
      }

      if (!acceptedTerms) {
        throw Exception('Debes aceptar los términos y condiciones');
      }

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        companyName: companyName,
        email: email,
        role: role,
        createdAt: DateTime.now(),
        acceptedTerms: acceptedTerms,
      );

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> demoLogin() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final user = User(
        id: 'demo_user_001',
        companyName: 'FuelTrack Demo',
        email: 'demo@fueltrack.com',
        role: 'cliente',
        createdAt: DateTime.now(),
        acceptedTerms: true,
      );

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return false;
    } catch (e) {
      rethrow;
    }
  }
}