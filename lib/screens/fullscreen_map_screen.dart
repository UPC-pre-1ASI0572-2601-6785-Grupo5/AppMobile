import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';

import 'dart:async';
import '../models/order_model.dart';
import '../services/order_service.dart';

class FullscreenMapScreen extends StatefulWidget {
  final OrderModel order;
  final LatLng targetLocation;
  final LatLng initialTruckPosition;
  final List<LatLng>? initialRoutePoints;

  const FullscreenMapScreen({
    Key? key,
    required this.order,
    required this.targetLocation,
    required this.initialTruckPosition,
    this.initialRoutePoints,
  }) : super(key: key);

  @override
  State<FullscreenMapScreen> createState() => _FullscreenMapScreenState();
}

class _FullscreenMapScreenState extends State<FullscreenMapScreen> {
  final MapController _mapController = MapController();
  late OrderModel _currentOrder;
  late LatLng _truckPosition;
  late List<LatLng> _routePoints;
  int _currentSegmentIndex = 0;
  Timer? _positionTimer;
  Timer? _pollingTimer;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    _truckPosition = widget.initialTruckPosition;
    _routePoints = widget.initialRoutePoints ?? [];
    
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentOrder.status == 'IN_TRANSIT' || _currentOrder.status == 'DISPATCHED') {
        setState(() {
          _updateTruckLocation();
        });
      }
    });

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_currentOrder.status != 'COMPLETED') {
        try {
          final updated = await _orderService.getOrder(_currentOrder.id!);
          if (mounted) {
            setState(() {
              _currentOrder = updated;
              _updateTruckLocation();
            });
          }
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _updateTruckLocation() {
    final order = _currentOrder;
    final originLocation = const LatLng(-12.085, -76.96);
    if (order.status == 'PENDING_APPROVAL' || order.status == 'APPROVED') {
      _truckPosition = originLocation;
    } else if (order.status == 'DELIVERED' || order.status == 'COMPLETED') {
      _truckPosition = widget.targetLocation;
    } else if (order.status == 'IN_TRANSIT' || order.status == 'DISPATCHED') {
      if (_currentOrder.dispatchedAt != null && _currentOrder.etaMinutes != null) {
        double progress = 1.0;
        if (_currentOrder.etaMinutes! > 0) {
          final dispatchedTime = DateTime.parse(_currentOrder.dispatchedAt!).toLocal();
          final now = DateTime.now();
          final elapsedMinutes = now.difference(dispatchedTime).inSeconds / 60.0;
          progress = elapsedMinutes / _currentOrder.etaMinutes!;
        }
        
        if (progress < 0) progress = 0;
        if (progress > 1) progress = 1;
        
        if (_routePoints.length > 1) {
          final distance = const Distance();
          double totalDistance = 0.0;
          List<double> cumulativeDistances = [0.0];
          
          for (int i = 0; i < _routePoints.length - 1; i++) {
            double segDist = distance.as(LengthUnit.Meter, _routePoints[i], _routePoints[i+1]);
            totalDistance += segDist;
            cumulativeDistances.add(totalDistance);
          }
          
          double targetDistance = totalDistance * progress;
          
          for (int i = 0; i < _routePoints.length - 1; i++) {
            if (targetDistance <= cumulativeDistances[i+1]) {
              double segmentLength = cumulativeDistances[i+1] - cumulativeDistances[i];
              double segmentProgress = segmentLength > 0 ? (targetDistance - cumulativeDistances[i]) / segmentLength : 0.0;
              
              final lat = _routePoints[i].latitude + (_routePoints[i+1].latitude - _routePoints[i].latitude) * segmentProgress;
              final lng = _routePoints[i].longitude + (_routePoints[i+1].longitude - _routePoints[i].longitude) * segmentProgress;
              _truckPosition = LatLng(lat, lng);
              _currentSegmentIndex = i;
              break;
            }
          }
        } else {
          final lat = originLocation.latitude + (widget.targetLocation.latitude - originLocation.latitude) * progress;
          final lng = originLocation.longitude + (widget.targetLocation.longitude - originLocation.longitude) * progress;
          _truckPosition = LatLng(lat, lng);
          _currentSegmentIndex = 0;
        }
      } else {
        _truckPosition = originLocation;
        _currentSegmentIndex = 0;
      }
    }
  }

  List<LatLng> getRemainingRoute() {
    if (_routePoints.isEmpty) return [_truckPosition, widget.targetLocation];
    if (_currentSegmentIndex >= _routePoints.length - 1) return [_truckPosition, widget.targetLocation];
    
    return [
      _truckPosition,
      ..._routePoints.sublist(_currentSegmentIndex + 1),
    ];
  }

  void _centerMap() {
    try {
      _mapController.move(_truckPosition, 14.0);
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
          // Ruta trazada
          PolylineLayer(
            polylines: <Polyline<Object>>[
              Polyline<Object>(
                points: getRemainingRoute(),
                color: AppColors.primary,
                strokeWidth: 4,
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
                point: _truckPosition,
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