import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import 'dashboard_screen.dart';
import 'fullscreen_map_screen.dart'; // Importación de la nueva pantalla
import '../models/order_model.dart';

import 'dart:math';
import '../services/geocoding_service.dart';
import '../services/routing_service.dart';
import '../services/order_service.dart';
import 'delivery_success_screen.dart';
import 'dart:async';

class TrackingDetailsScreen extends StatefulWidget {
  final OrderModel order;
  const TrackingDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<TrackingDetailsScreen> createState() => _TrackingDetailsScreenState();
}

class _TrackingDetailsScreenState extends State<TrackingDetailsScreen> with TickerProviderStateMixin {
  final int _selectedIndex = 2; // Seguimiento activo
  final MapController _mapController = MapController();
  late AnimationController _animController;
  late Animation<double> _anim;
  
  LatLng _truckPosition = const LatLng(-12.085, -76.96); // Refinería
  LatLng _targetLocation = const LatLng(-12.085, -76.96);
  String _destinationName = 'Planta Refinería Sur';
  bool _isLoadingMap = true;
  double _currentZoom = 15.0;
  Timer? _positionTimer;
  Timer? _pollingTimer;
  List<LatLng> _routePoints = [];
  int _currentSegmentIndex = 0;
  late OrderModel _currentOrder;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    _resolveDestination();
    
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

  Future<void> _resolveDestination() async {
    String rawRef = _currentOrder.documentRef;
    String addr = 'Planta Refinería Sur';
    if (rawRef.contains(' | ')) {
      addr = rawRef.split(' | ')[0];
    } else if (rawRef.isNotEmpty) {
      addr = rawRef;
    }
    
    final loc = await GeocodingService.instance.getCoordinatesFromAddress(addr);
    final originLoc = const LatLng(-12.085, -76.96);
    final route = await RoutingService.instance.getRouteCoordinates(originLoc, loc);

    if (mounted) {
      setState(() {
        _targetLocation = loc;
        _destinationName = addr;
        _routePoints = route.isEmpty ? [originLoc, _targetLocation] : route;
        
        if (_currentOrder.status == 'DELIVERED' || _currentOrder.status == 'COMPLETED') {
          _truckPosition = _targetLocation;
        } else {
          _updateTruckLocation();
        }
        _isLoadingMap = false;
      });
      try {
        _mapController.move(_targetLocation, 13.0);
      } catch (_) {}
    }
  }

  void _updateTruckLocation() {
    final order = _currentOrder;
    final originLocation = const LatLng(-12.085, -76.96);
    if (order.status == 'PENDING_APPROVAL' || order.status == 'APPROVED') {
      _truckPosition = originLocation;
    } else if (order.status == 'DELIVERED' || order.status == 'COMPLETED') {
      _truckPosition = _targetLocation;
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
          final lat = originLocation.latitude + (_targetLocation.latitude - originLocation.latitude) * progress;
          final lng = originLocation.longitude + (_targetLocation.longitude - originLocation.longitude) * progress;
          _truckPosition = LatLng(lat, lng);
          _currentSegmentIndex = 0;
        }
      } else {
        _truckPosition = const LatLng(-12.085, -76.96);
        _currentSegmentIndex = 0;
      }
    }
  }

  List<LatLng> getRemainingRoute() {
    if (_routePoints.isEmpty) return [_truckPosition, _targetLocation];
    if (_currentSegmentIndex >= _routePoints.length - 1) return [_truckPosition, _targetLocation];
    
    return [
      _truckPosition,
      ..._routePoints.sublist(_currentSegmentIndex + 1),
    ];
  }

  String _getRemainingTime() {
    final order = widget.order;
    if (order.status == 'DELIVERED' || order.status == 'COMPLETED') return '0 min';
    if (order.status != 'IN_TRANSIT' && order.status != 'DISPATCHED') {
      return order.etaMinutes != null ? '${order.etaMinutes} min' : 'Calculando...';
    }
    if (order.dispatchedAt != null && order.etaMinutes != null) {
      final dispatchedTime = DateTime.parse(order.dispatchedAt!).toLocal();
      final elapsedMinutes = DateTime.now().difference(dispatchedTime).inSeconds / 60.0;
      double remaining = order.etaMinutes! - elapsedMinutes;
      if (remaining < 0) remaining = 0;
      return '${remaining.ceil()} min';
    }
    return 'Calculando...';
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    double dLat = (p2.latitude - p1.latitude) * pi / 180.0;
    double dLng = (p2.longitude - p1.longitude) * pi / 180.0;
    double a = sin(dLat/2) * sin(dLat/2) +
               cos(p1.latitude * pi / 180.0) * cos(p2.latitude * pi / 180.0) *
               sin(dLng/2) * sin(dLng/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    return 6371 * c;
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      double current = _mapController.camera.zoom;
      current = (current + 1).clamp(1.0, 18.0);
      _mapController.move(_mapController.camera.center, current);
    });
  }

  void _zoomOut() {
    setState(() {
      double current = _mapController.camera.zoom;
      current = (current - 1).clamp(1.0, 18.0);
      _mapController.move(_mapController.camera.center, current);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles del', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.2)),
            Text('Despacho', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.2)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjeta 1: Detalles de la Unidad
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del camión
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?q=80&w=800&auto=format&fit=crop', // Imagen placeholder de camión
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('ACTIVO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.order.assignedTruckId != null ? 'Unidad Cisterna ${widget.order.assignedTruckId}' : 'Unidad No Asignada', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 4),
                                  const Text('Modelo: Pendiente\nPremium Logistics', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(38),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('ID:\n#${widget.order.id}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Grid de Capacidades
                        Row(
                          children: [
                            Expanded(child: _buildInfoBox('Capacidad\nSolicitada', '${widget.order.quantityGallons} Gal')),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInfoBox('Estado', _formatStatus(widget.order.status), valueColor: _getStatusColor(widget.order.status))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(flex: 1, child: _buildInfoBox('Consumo', '2.4 km/L')),
                            const SizedBox(width: 12),
                            const Expanded(flex: 1, child: SizedBox()), // Espaciador
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Sensores de Telemetría
                        const Text('Sensores de Telemetría Activos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSensorPill(Icons.thermostat_outlined, 'Temp: 24°C'),
                            _buildSensorPill(Icons.compress_outlined, 'Presión: 115 PSI'),
                            _buildSensorPill(Icons.speed_outlined, 'Vel: 88 km/h'),
                            _buildSensorPill(Icons.water_drop_outlined, 'Viscosidad: OK'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjeta 2: Notificaciones Recientes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Notificaciones Recientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Icon(Icons.history, color: AppColors.textGrey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildNotificationItem(
                    icon: Icons.factory_outlined,
                    iconColor: AppColors.primary,
                    title: 'Cisterna salió de planta',
                    time: 'Hace 45 min',
                    desc: 'Despacho verificado en Terminal Norte. Rumbo a destino principal.',
                  ),
                  _buildNotificationItem(
                    icon: Icons.traffic_outlined,
                    iconColor: AppColors.error,
                    title: 'Entrando a zona de tráfico pesado',
                    time: 'Hace 12 min',
                    desc: 'Retraso estimado de 8 minutos detectado en Autopista Central.',
                  ),
                  _buildNotificationItem(
                    icon: Icons.access_time_outlined,
                    iconColor: AppColors.primary,
                    title: 'ETA actualizado a 15 min',
                    time: 'Justo ahora',
                    desc: 'La unidad se aproxima a la geocerca de destino. Personal de descarga notificado.',
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjeta 3: Geocerca y Mapa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GEOCERCA DE DESTINO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(_destinationName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 16),

                  // Mapa Interactivo Real embebido en la tarjeta
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                                initialCenter: _targetLocation,
                                initialZoom: 14.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                                  userAgentPackageName: 'com.example.fueltrack',
                                ),
                                PolygonLayer(
                                  polygons: [
                                    Polygon(
                                      points: [
                                        LatLng(_targetLocation.latitude + 0.003, _targetLocation.longitude - 0.004),
                                        LatLng(_targetLocation.latitude + 0.003, _targetLocation.longitude + 0.004),
                                        LatLng(_targetLocation.latitude - 0.003, _targetLocation.longitude + 0.004),
                                        LatLng(_targetLocation.latitude - 0.003, _targetLocation.longitude - 0.004),
                                      ],
                                      color: AppColors.primary.withAlpha(51),
                                      borderColor: AppColors.primary,
                                      borderStrokeWidth: 2,
                                    ),
                                  ],
                                ),
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: getRemainingRoute(),
                                      color: AppColors.primary,
                                      strokeWidth: 4.0,
                                    ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: _targetLocation,
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
                                    Marker(
                                      point: _truckPosition,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.local_shipping, color: AppColors.primary, size: 36),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (_isLoadingMap)
                            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                          // Controles de zoom
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: _zoomIn,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                                    child: const Icon(Icons.add, size: 16, color: AppColors.textDark),
                                  ),
                                ),
                                Container(height: 1, width: 24, color: AppColors.borderLight),
                                GestureDetector(
                                  onTap: _zoomOut,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                                    child: const Icon(Icons.remove, size: 16, color: AppColors.textDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Distancia restante:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      Text('${_calculateDistance(_truckPosition, _targetLocation).toStringAsFixed(1)} km', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tiempo restante:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      Text(_getRemainingTime(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado de Geocerca:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      Row(
                        children: const [
                          Icon(Icons.check_circle_outline, size: 14, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text('Monitoreando', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullscreenMapScreen(
                            order: _currentOrder,
                            targetLocation: _targetLocation, 
                            initialTruckPosition: _truckPosition,
                            initialRoutePoints: getRemainingRoute(),
                          )),
                        );
                      },
                      icon: const Icon(Icons.fullscreen, size: 18),
                      label: const Text('Ver Mapa en Pantalla Completa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006D3E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  if (widget.order.status == 'DELIVERED') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await OrderService().markAsCompleted(widget.order.id!);
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DeliverySuccessScreen()),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          }
                        },
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Confirmar Recepción'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildInfoBox(String label, String value, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.primary)),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'PENDING_APPROVAL': return 'PENDIENTE';
      case 'APPROVED': return 'APROBADO';
      case 'IN_TRANSIT': return 'EN RUTA';
      case 'DELIVERED': return 'ENTREGADO';
      case 'REJECTED': return 'RECHAZADO';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING_APPROVAL': return Colors.orange;
      case 'APPROVED': return AppColors.success;
      case 'IN_TRANSIT': return AppColors.primary;
      case 'DELIVERED': return Colors.teal;
      case 'REJECTED': return AppColors.error;
      default: return AppColors.textDark;
    }
  }

  Widget _buildSensorPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String desc,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.borderLight,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                  Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(initialIndex: index)),
          (route) => false,
        );
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Pedidos'),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.local_shipping_outlined, color: Colors.white),
          ),
          label: 'Seguimiento',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Analítica'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ],
    );
  }
}