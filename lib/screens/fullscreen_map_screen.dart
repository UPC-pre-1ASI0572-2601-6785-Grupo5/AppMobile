import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';

class FullscreenMapScreen extends StatefulWidget {
  final LatLng targetLocation;
  final LatLng truckPosition;

  const FullscreenMapScreen({
    Key? key,
    required this.targetLocation,
    required this.truckPosition,
  }) : super(key: key);

  @override
  State<FullscreenMapScreen> createState() => _FullscreenMapScreenState();
}

class _FullscreenMapScreenState extends State<FullscreenMapScreen> {
  final MapController _mapController = MapController();

  void _centerMap() {
    try {
      _mapController.move(widget.truckPosition, 14.0);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mapa en Pantalla Completa',
          style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: widget.targetLocation,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            // Capa clara para el mapa de detalles
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            userAgentPackageName: 'com.example.fueltrack',
          ),
          // Geocerca (Polígono de la Refinería)
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  LatLng(widget.targetLocation.latitude + 0.003, widget.targetLocation.longitude - 0.004),
                  LatLng(widget.targetLocation.latitude + 0.003, widget.targetLocation.longitude + 0.004),
                  LatLng(widget.targetLocation.latitude - 0.003, widget.targetLocation.longitude + 0.004),
                  LatLng(widget.targetLocation.latitude - 0.003, widget.targetLocation.longitude - 0.004),
                ],
                color: AppColors.primary.withAlpha(51),
                borderColor: AppColors.primary,
                borderStrokeWidth: 2,
              ),
            ],
          ),
          // Ruta trazada (Línea directa entre origen y destino para visualización rápida)
          PolylineLayer(
            polylines: <Polyline<Object>>[
              Polyline<Object>(
                points: [
                  const LatLng(-12.085, -76.96), // Origen
                  widget.targetLocation, // Destino
                ],
                color: AppColors.primary.withAlpha(128),
                strokeWidth: 4,
                pattern: const StrokePattern.dashed(segments: [10, 10]),
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              // Marcador de la Geocerca
              Marker(
                point: widget.targetLocation,
                width: 120,
                height: 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Center(
                    child: Text('ZONA DE ENTREGA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ),
              ),
              // Marcador del Camión
              Marker(
                point: widget.truckPosition,
                width: 60,
                height: 60,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withAlpha(128), blurRadius: 10, spreadRadius: 5),
                          ]
                      ),
                      child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _centerMap,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}