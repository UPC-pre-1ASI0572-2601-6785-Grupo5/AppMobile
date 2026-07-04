import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'session_manager.dart';
import '../config/api_config.dart';

class ProfileService {
  // Use the central API config
  final String _baseUrl = '${ApiConfig.baseUrl}/api/v1';

  Future<Map<String, String>> _getHeaders() async {
    final token = SessionManager.instance.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // UPDATE PROFILE
  Future<User> updateProfile(int userId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$userId/profile'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final updatedUser = User.fromJson(json);
      await _updateLocalUser(updatedUser);
      return updatedUser;
    } else {
      throw Exception('Error al actualizar el perfil: ${response.body}');
    }
  }

  // CHANGE PASSWORD
  Future<void> changePassword(int userId, String currentPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$userId/password'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cambiar contraseña: ${response.body}');
    }
  }

  // TOGGLE MFA
  Future<User> toggleMfa(int userId, bool enableMfa) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$userId/mfa'),
      headers: await _getHeaders(),
      body: jsonEncode({'enableMfa': enableMfa}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final updatedUser = User.fromJson(json);
      await _updateLocalUser(updatedUser);
      return updatedUser;
    } else {
      throw Exception('Error al actualizar MFA: ${response.body}');
    }
  }

  // CHANGE SUBSCRIPTION PLAN
  Future<void> changeSubscriptionPlan(int userId, String planName) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/billing/users/$userId/plan'),
      headers: await _getHeaders(),
      body: jsonEncode({'plan': planName}),
    );

    if (response.statusCode == 200) {
      // Re-fetch user to get updated plan
      await fetchUserProfile(userId);
    } else {
      throw Exception('Error al cambiar el plan: ${response.body}');
    }
  }

  // FETCH FULL PROFILE
  Future<User> fetchUserProfile(int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final updatedUser = User.fromJson(json);
      await _updateLocalUser(updatedUser);
      return updatedUser;
    } else {
      throw Exception('Error al obtener perfil: ${response.body}');
    }
  }

  // SITES (SEDES)
  Future<List<Map<String, dynamic>>> getSites(int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sites/user/$userId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    return [];
  }

  Future<void> addSite(int userId, String name, String address) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sites'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'userId': userId,
        'name': name,
        'address': address,
        'active': true
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al añadir sede');
    }
  }

  Future<void> deleteSite(int siteId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/sites/$siteId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar sede');
    }
  }

  Future<void> _updateLocalUser(User user) async {
    final token = SessionManager.instance.token ?? '';
    user = User(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      token: token,
      tokenType: 'Bearer',
      companyName: user.companyName,
      taxId: user.taxId,
      phone: user.phone,
      address: user.address,
      mfaEnabled: user.mfaEnabled,
      subscriptionPlan: user.subscriptionPlan,
    );
    await SessionManager.instance.saveSession(token: token, user: user);
  }
}
