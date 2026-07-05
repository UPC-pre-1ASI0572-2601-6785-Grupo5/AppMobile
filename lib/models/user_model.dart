
/// Maps the backend `AuthResponse` payload into a Dart model.
///
/// Backend JSON shape:
/// ```json
/// {
///   "token": "...",
///   "tokenType": "Bearer",
///   "id": 1,
///   "email": "user@example.com",
///   "name": "Company Name",
///   "role": "REQUESTER"
/// }
/// ```
class User {
  final int id;
  String email;
  String name;
  final String role; // "REQUESTER" or "PROVIDER"
  final String token;
  final String tokenType;

  // New profile fields
  String? companyName;
  String? taxId;
  String? phone;
  String? address;
  bool mfaEnabled;
  String? subscriptionPlan;
  String? profilePicture;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.token,
    required this.tokenType,
    this.companyName,
    this.taxId,
    this.phone,
    this.address,
    this.mfaEnabled = false,
    this.subscriptionPlan,
    this.profilePicture,
  });

  /// Creates a [User] from the backend `AuthResponse` JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      token: json['token'] as String? ?? '',
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      companyName: json['companyName'] as String?,
      taxId: json['taxId'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      mfaEnabled: json['mfaEnabled'] as bool? ?? false,
      subscriptionPlan: json['subscriptionPlan'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'token': token,
      'tokenType': tokenType,
      'companyName': companyName,
      'taxId': taxId,
      'phone': phone,
      'address': address,
      'mfaEnabled': mfaEnabled,
      'subscriptionPlan': subscriptionPlan,
      'profilePicture': profilePicture,
    };
  }

  // ── Role mapping helpers ──────────────────────────────────────────────

  /// Converts the Flutter UI role label into the backend enum value.
  ///
  /// `'cliente'`    → `'REQUESTER'`
  /// `'proveedor'`  → `'PROVIDER'`
  static String uiRoleToBackend(String uiRole) {
    switch (uiRole.toLowerCase()) {
      case 'cliente':
        return 'REQUESTER';
      case 'proveedor':
        return 'PROVIDER';
      default:
        return 'REQUESTER';
    }
  }

  /// Converts the backend role enum into the Flutter UI label.
  ///
  /// `'REQUESTER'`  → `'cliente'`
  /// `'PROVIDER'`   → `'proveedor'`
  static String backendRoleToUi(String backendRole) {
    switch (backendRole.toUpperCase()) {
      case 'REQUESTER':
        return 'cliente';
      case 'PROVIDER':
        return 'proveedor';
      default:
        return 'cliente';
    }
  }

  /// The UI-friendly role label for this user.
  String get uiRole => backendRoleToUi(role);

  /// Whether this user is a provider.
  bool get isProvider {
    final r = role.toUpperCase();
    return r == 'PROVIDER' || r == 'PROVEEDOR' || r == 'ROLE_PROVIDER';
  }

  /// Whether this user is a requester / client.
  bool get isRequester {
    final r = role.toUpperCase();
    return r == 'REQUESTER' || r == 'CLIENTE' || r == 'ROLE_REQUESTER';
  }
}
