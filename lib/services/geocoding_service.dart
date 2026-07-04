import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  GeocodingService._();
  static final GeocodingService instance = GeocodingService._();

  // Default coordinate (Lima, Peru)
  final LatLng defaultLocation = const LatLng(-12.0464, -77.0428);

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    if (address.isEmpty) {
      return defaultLocation;
    }

    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1');
      
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'com.example.fueltrack', // Nominatim requires a User-Agent
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat'].toString());
          final lon = double.tryParse(data[0]['lon'].toString());
          if (lat != null && lon != null) {
            return LatLng(lat, lon);
          }
        }
      }
    } catch (e) {
      // Return default location if any error occurs (network error, timeout, etc.)
    }

    return defaultLocation;
  }
}
