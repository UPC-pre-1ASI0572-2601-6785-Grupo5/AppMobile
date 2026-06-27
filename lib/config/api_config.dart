/// Centralized API configuration for the FuelTrack backend.
class ApiConfig {
  ApiConfig._();

  /// Base URL of the deployed backend on Render.
  static const String baseUrl = 'https://backend-npu7.onrender.com';

  /// Connection timeout in seconds (Render free tier may cold-start).
  static const int connectTimeoutSeconds = 15;

  /// Receive timeout in seconds.
  static const int receiveTimeoutSeconds = 30;

  // ── Authentication endpoints ──────────────────────────────────────────
  static const String signUp = '/api/v1/authentication/sign-up';
  static const String signIn = '/api/v1/authentication/sign-in';

  // ── Order endpoints ───────────────────────────────────────────────────
  static const String orders = '/api/v1/orders';

  // ── Inventory endpoints ───────────────────────────────────────────────
  static const String inventoryStocks = '/api/v1/inventory/stocks';
  static const String inventoryRefill = '/api/v1/inventory/refill';
  static const String inventoryDischarge = '/api/v1/inventory/discharge';

  // ── Vehicle / Telemetry endpoints ─────────────────────────────────────
  static const String vehicles = '/api/v1/vehicles';

  // ── Fulfillment endpoints ─────────────────────────────────────────────
  static const String fulfillment = '/api/v1/fulfillment';

  // ── Reporting endpoints ───────────────────────────────────────────────
  static const String reports = '/api/v1/reports';
}
