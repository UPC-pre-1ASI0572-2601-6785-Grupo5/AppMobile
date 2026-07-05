import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  static final RoutingService instance = RoutingService._internal();

  RoutingService._internal();

  /// Fetches a route from OSRM and returns a list of LatLng points
  /// representing the actual road geometry.
  Future<List<LatLng>> getRouteCoordinates(LatLng origin, LatLng destination) async {
    try {
      final String url = 
          'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}'
          '?geometries=geojson&overview=full';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final List coordinates = data['routes'][0]['geometry']['coordinates'];
          
          List<LatLng> points = [];
          for (var coord in coordinates) {
            // GeoJSON format is [longitude, latitude]
            points.add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
          }
          return points;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching route from OSRM: $e');
      return [];
    }
  }
}
