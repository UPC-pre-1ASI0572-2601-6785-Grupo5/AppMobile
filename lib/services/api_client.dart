import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'session_manager.dart';

/// Lightweight HTTP client that wraps the `http` package.
///
/// Automatically injects the JWT `Authorization` header when a session exists,
/// sets JSON content-type headers, and translates non-2xx responses into
/// descriptive exceptions.
class ApiClient {
  ApiClient._();
  static final ApiClient _instance = ApiClient._();

  /// Singleton accessor.
  static ApiClient get instance => _instance;

  final http.Client _client = http.Client();

  // ── Public helpers ────────────────────────────────────────────────────

  /// Sends a GET request to [path] (relative to [ApiConfig.baseUrl]).
  Future<dynamic> get(String path) async {
    final uri = _buildUri(path);
    final response = await _client
        .get(uri, headers: _headers())
        .timeout(Duration(seconds: ApiConfig.receiveTimeoutSeconds));
    return _handleResponse(response);
  }

  /// Sends a POST request with a JSON [body].
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(path);
    final response = await _client
        .post(uri, headers: _headers(), body: body != null ? jsonEncode(body) : null)
        .timeout(Duration(seconds: ApiConfig.receiveTimeoutSeconds));
    return _handleResponse(response);
  }

  /// Sends a PATCH request with a JSON [body].
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(path);
    final response = await _client
        .patch(uri, headers: _headers(), body: body != null ? jsonEncode(body) : null)
        .timeout(Duration(seconds: ApiConfig.receiveTimeoutSeconds));
    return _handleResponse(response);
  }

  /// Sends a PUT request with a JSON [body].
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(path);
    final response = await _client
        .put(uri, headers: _headers(), body: body != null ? jsonEncode(body) : null)
        .timeout(Duration(seconds: ApiConfig.receiveTimeoutSeconds));
    return _handleResponse(response);
  }

  /// Sends a DELETE request.
  Future<dynamic> delete(String path) async {
    final uri = _buildUri(path);
    final response = await _client
        .delete(uri, headers: _headers())
        .timeout(Duration(seconds: ApiConfig.receiveTimeoutSeconds));
    return _handleResponse(response);
  }

  // ── Internals ─────────────────────────────────────────────────────────

  Uri _buildUri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = SessionManager.instance.token;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    // Try to extract a meaningful message from the backend error body.
    String message;
    if (body is Map<String, dynamic>) {
      message = body['message'] as String? ??
          body['error'] as String? ??
          'Error del servidor ($statusCode)';
    } else {
      message = 'Error del servidor ($statusCode)';
    }

    switch (statusCode) {
      case 400:
        throw ApiException('Solicitud inválida: $message', statusCode);
      case 401:
        // Clear stale session on unauthorized.
        SessionManager.instance.clear();
        throw ApiException('Credenciales inválidas', statusCode);
      case 403:
        throw ApiException('Acceso denegado', statusCode);
      case 404:
        throw ApiException('Recurso no encontrado', statusCode);
      case 409:
        throw ApiException(message, statusCode);
      default:
        throw ApiException(message, statusCode);
    }
  }
}

/// Exception thrown when an API call returns a non-2xx status code.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
