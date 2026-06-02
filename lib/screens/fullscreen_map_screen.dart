import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';

class FullscreenMapScreen extends StatelessWidget {
  const FullscreenMapScreen({Key? key}) : super(key: key);

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
        options: const MapOptions(
          initialCenter: LatLng(-12.065, -76.98), // Centro de la vista ajustado
          initialZoom: 13.5,
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
                points: const [
                  LatLng(-12.082, -76.964),
                  LatLng(-12.082, -76.956),
                  LatLng(-12.088, -76.956),
                  LatLng(-12.088, -76.964),
                ],
                color: AppColors.primary.withAlpha(51),
                borderColor: AppColors.primary,
                borderStrokeWidth: 2,
              ),
            ],
          ),
          // Ruta trazada (Ahora simulando curvas por las calles)
          PolylineLayer(
            polylines: [
              Polyline(
                points: const [
                  LatLng(-12.0464, -77.0000), // Posición actual de la Cisterna
                  LatLng(-12.0485, -76.9960), // Curva calle 1
                  LatLng(-12.0520, -76.9930), // Ingreso a vía principal
                  LatLng(-12.0580, -76.9880), // Siguiendo la vía
                  LatLng(-12.0640, -76.9820), // Curva ligera
                  LatLng(-12.0720, -76.9740), // Tramo recto largo
                  LatLng(-12.0780, -76.9680), // Desvío hacia la planta
                  LatLng(-12.0810, -76.9620), // Acercándose a la puerta
                  LatLng(-12.0850, -76.9600), // Refinería (Destino final)
                ],
                color: AppColors.primary,
                strokeWidth: 4,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              // Marcador de la Geocerca
              Marker(
                point: const LatLng(-12.085, -76.96),
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
                point: const LatLng(-12.0464, -77.00),
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
        onPressed: () {
          // Lógica futura para centrar ubicación
        },
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}