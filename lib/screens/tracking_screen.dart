import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import 'tracking_details_screen.dart';
import 'delivery_success_screen.dart';
import 'alerts_screen.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../services/geocoding_service.dart';
import '../services/routing_service.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TrackingScreen extends StatefulWidget {
  final OrderModel? order;
  const TrackingScreen({Key? key, this.order}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final int _selectedIndex = 2; // Pestaña actual: Seguimiento
  final MapController _mapController = MapController();
  bool _isDarkMode = true;
  OrderModel? _currentOrder;
  List<OrderModel> _activeOrders = [];
  bool _isLoading = true;
  bool _isLoadingMapLocation = false;
  LatLng _targetLocation = const LatLng(-12.0464, -77.0428);
  LatLng _originLocation = const LatLng(-12.085, -76.96);
  LatLng _currentTruckLocation = const LatLng(-12.085, -76.96);
  Timer? _positionTimer;
  final OrderService _orderService = OrderService();
  List<LatLng> _routePoints = [];
  int _currentSegmentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _currentOrder = widget.order;
      _isLoading = false;
      _resolveLocation(_currentOrder!.documentRef);
    } else {
      _fetchActiveOrders();
    }
    
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentOrder != null && (_currentOrder!.status == 'IN_TRANSIT' || _currentOrder!.status == 'DISPATCHED')) {
        setState(() {
          _updateTruckLocation();
        });
      }
    });
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchActiveOrders() async {
    try {
      final orders = await _orderService.getOrders();
      _activeOrders = orders.where((o) => o.status != 'COMPLETED').toList();
      _activeOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      if (_activeOrders.length == 1) {
        _currentOrder = _activeOrders.first;
        _resolveLocation(_currentOrder!.documentRef);
      }
    } catch (e) {
      debugPrint('Error fetching active orders: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resolveLocation(String rawAddress) async {
    setState(() => _isLoadingMapLocation = true);
    String addr = 'Planta Refinería Sur';
    if (rawAddress.contains(' | ')) {
      addr = rawAddress.split(' | ')[0];
    } else if (rawAddress.isNotEmpty) {
      addr = rawAddress;
    }
    final location = await GeocodingService.instance.getCoordinatesFromAddress(addr);
    final route = await RoutingService.instance.getRouteCoordinates(_originLocation, location);
    
    if (mounted) {
      setState(() {
        _targetLocation = location;
        _routePoints = route.isEmpty ? [_originLocation, _targetLocation] : route;
        _isLoadingMapLocation = false;
        _updateTruckLocation();
      });
      try {
        _mapController.move(_currentTruckLocation, 14.0);
      } catch (_) {}
    }
  }

  void _updateTruckLocation() {
    final order = _currentOrder;
    if (order == null) return;
    
    if (order.status == 'PENDING_APPROVAL' || order.status == 'APPROVED') {
      _currentTruckLocation = _originLocation;
    } else if (order.status == 'DELIVERED' || order.status == 'COMPLETED') {
      _currentTruckLocation = _targetLocation;
    } else if (order.status == 'IN_TRANSIT' || order.status == 'DISPATCHED') {
      if (order.dispatchedAt != null && order.etaMinutes != null && order.etaMinutes! > 0) {
        final dispatchedTime = DateTime.parse(order.dispatchedAt!).toLocal();
        final now = DateTime.now();
        final elapsedMinutes = now.difference(dispatchedTime).inSeconds / 60.0;
        double progress = elapsedMinutes / order.etaMinutes!;
        
        if (progress < 0) progress = 0;
        if (progress > 1) progress = 1;
        
        if (_routePoints.length > 1) {
          // Calculate total distance of the polyline
          final distance = const Distance();
          double totalDistance = 0.0;
          List<double> cumulativeDistances = [0.0];
          
          for (int i = 0; i < _routePoints.length - 1; i++) {
            double segDist = distance.as(LengthUnit.Meter, _routePoints[i], _routePoints[i+1]);
            totalDistance += segDist;
            cumulativeDistances.add(totalDistance);
          }
          
          double targetDistance = totalDistance * progress;
          
          // Find the segment containing the target distance
          for (int i = 0; i < _routePoints.length - 1; i++) {
            if (targetDistance <= cumulativeDistances[i+1]) {
              double segmentLength = cumulativeDistances[i+1] - cumulativeDistances[i];
              double segmentProgress = segmentLength > 0 ? (targetDistance - cumulativeDistances[i]) / segmentLength : 0.0;
              
              final lat = _routePoints[i].latitude + (_routePoints[i+1].latitude - _routePoints[i].latitude) * segmentProgress;
              final lng = _routePoints[i].longitude + (_routePoints[i+1].longitude - _routePoints[i].longitude) * segmentProgress;
              _currentTruckLocation = LatLng(lat, lng);
              _currentSegmentIndex = i;
              break;
            }
          }
        } else {
          final lat = _originLocation.latitude + (_targetLocation.latitude - _originLocation.latitude) * progress;
          final lng = _originLocation.longitude + (_targetLocation.longitude - _originLocation.longitude) * progress;
          _currentTruckLocation = LatLng(lat, lng);
          _currentSegmentIndex = 0;
        }
      } else {
        _currentTruckLocation = _originLocation;
        _currentSegmentIndex = 0;
      }
    }
  }

  List<LatLng> getRemainingRoute() {
    if (_routePoints.isEmpty) return [_currentTruckLocation, _targetLocation];
    if (_currentSegmentIndex >= _routePoints.length - 1) return [_currentTruckLocation, _targetLocation];
    
    return [
      _currentTruckLocation,
      ..._routePoints.sublist(_currentSegmentIndex + 1),
    ];
  }

  Future<void> _cancelOrder(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Pedido'),
        content: const Text('¿Estás seguro de que deseas cancelar este pedido?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _orderService.cancelOrder(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido cancelado correctamente')));
        setState(() {
          _currentOrder = null;
        });
        _fetchActiveOrders();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cancelar: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatStatus(String rawStatus) {
    switch(rawStatus.toUpperCase()) {
      case 'PENDING_APPROVAL': return 'Pendiente';
      case 'PENDING': return 'Pendiente';
      case 'APPROVED': return 'Aprobado';
      case 'DISPATCHED': return 'En ruta';
      case 'IN_TRANSIT': return 'En ruta';
      case 'DELIVERED': return 'Entregado';
      case 'COMPLETED': return 'Completado';
      default: return rawStatus;
    }
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return 'Desconocida';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9F9),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    // SI NO HAY ORDEN SELECCIONADA Y HAY VARIAS ACTIVAS: MOSTRAR SELECTOR
    if (_currentOrder == null && _activeOrders.isNotEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: (widget.order != null && canPop) ? IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ) : const SizedBox.shrink(),
          title: const Text('Seleccionar Pedido', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _activeOrders.length,
          itemBuilder: (context, index) {
            final o = _activeOrders[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentOrder = o;
                });
                _resolveLocation(o.documentRef);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_shipping, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.name.isNotEmpty ? o.name : 'Pedido #FT-2026-${o.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text('${_formatStatus(o.status)} • ${_formatDate(o.createdAt)}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textGrey),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // SI NO HAY PEDIDOS ACTIVOS
    if (_currentOrder == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: (widget.order != null && canPop) ? IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ) : null,
          title: const Text('Seguimiento', style: TextStyle(color: AppColors.textDark)),
        ),
        body: const Center(
          child: Text('No tienes pedidos activos en este momento.', style: TextStyle(color: AppColors.textGrey)),
        ),
      );
    }

    // MAPA Y DETALLE DE LA ORDEN SELECCIONADA
    final order = _currentOrder!;
    
    // LOGICA DE ESTADOS PARA TIMELINE
    final bool isConfirmed = order.status == 'APPROVED' || order.status == 'DISPATCHED' || order.status == 'IN_TRANSIT' || order.status == 'DELIVERED' || order.status == 'COMPLETED';
    final bool isInRoute = order.status == 'DISPATCHED' || order.status == 'IN_TRANSIT' || order.status == 'DELIVERED' || order.status == 'COMPLETED';
    final bool isDelivered = order.status == 'DELIVERED' || order.status == 'COMPLETED';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: (widget.order != null && canPop) ? IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 32,
                  height: 32,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FuelTrack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ],
        ),
        actions: [
          if (widget.order == null && _activeOrders.length > 1)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _currentOrder = null;
                });
              },
              icon: const Icon(Icons.swap_horiz, size: 18, color: AppColors.primary),
              label: const Text('Cambiar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlertsScreen()),
                  );
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_gas_station_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.name.isNotEmpty ? order.name : '#FT-2026-${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text(_formatStatus(order.status), style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('ETA', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    Text(order.etaMinutes != null ? '${order.etaMinutes} min' : 'Calculando...', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _targetLocation,
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: _isDarkMode 
                            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                            : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                        userAgentPackageName: 'com.example.fueltrack',
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
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, color: AppColors.error, size: 40),
                          ),
                          Marker(
                            point: _currentTruckLocation,
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
                ),
                if (_isLoadingMapLocation)
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Column(
                    children: [
                      _buildMapFloatingButton(Icons.my_location, onTap: () {
                        _mapController.move(_currentTruckLocation, 14.0);
                      }),
                      const SizedBox(height: 8),
                      _buildMapFloatingButton(Icons.layers_outlined, onTap: () {
                        setState(() {
                          _isDarkMode = !_isDarkMode;
                        });
                      }),
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.25,
                  minChildSize: 0.05,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                          ]
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: AppColors.borderLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const Text(
                            'PROGRESO DEL PEDIDO',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1),
                          ),
                          const SizedBox(height: 24),
                          _buildTimelineStep(isCompleted: true, isActive: false, icon: Icons.playlist_add_check, title: 'Pedido Creado', subtitle: 'Registrado en sistema', isLast: false),
                          _buildTimelineStep(isCompleted: isConfirmed, isActive: !isConfirmed, icon: Icons.check, title: 'Pedido Aceptado', subtitle: isConfirmed ? 'Proveedor asignado' : 'Esperando confirmación', isLast: false),
                          _buildTimelineStep(isCompleted: isInRoute || isDelivered, isActive: isInRoute && !isDelivered, icon: Icons.location_on_outlined, title: 'En Ruta', subtitle: isInRoute ? 'Cerca de tu ubicación' : 'Aún no sale', isLast: false),
                          _buildTimelineStep(isCompleted: isDelivered, isActive: false, icon: Icons.inventory_2_outlined, title: 'Entregado', subtitle: 'Destino final', isLast: true),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset('assets/images/logo.png', width: 48, height: 48, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Roberto G.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: const [
                                        Icon(Icons.star, color: AppColors.primary, size: 14),
                                        SizedBox(width: 4),
                                        Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        SizedBox(width: 4),
                                        Text('(1,240 entregas)', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFEFEFEF), borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('UNIDAD', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                    Icon(Icons.local_shipping_outlined, color: AppColors.primary),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text('VXB-402', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                const SizedBox(height: 12),
                                Stack(
                                  children: [
                                    Container(height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
                                    Container(width: 200, height: 4, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Capacidad Solicitada', style: TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w600)),
                                    Text('${order.quantityGallons} Galones', style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => TrackingDetailsScreen(order: order)),
                                    );
                                  },
                                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18, color: Colors.white),
                                  label: const Text('Detalles', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D3E),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Contactar Soporte'),
                                        content: const Text(
                                            'Comunícate con nuestro centro logístico al:\n\n'
                                            '📞 +51 906 260 638\n'
                                            '✉️ soporte@fueltrack.com\n\n'
                                            'Atención 24/7 para incidencias en ruta.'
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cerrar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.call_outlined, size: 18, color: Colors.white),
                                  label: const Text('Contactar', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D3E),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (order.status == 'DELIVERED')
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    await _orderService.markAsCompleted(order.id!);
                                    if (mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const DeliverySuccessScreen()),
                                      ).then((_) {
                                        _fetchActiveOrders();
                                      });
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                    }
                                  }
                                },
                                icon: const Icon(Icons.inventory_outlined, size: 18, color: AppColors.primary),
                                label: const Text('Confirmar Entrega', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE8F8F5),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          if (!isConfirmed) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _cancelOrder(order.id!),
                                icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error),
                                label: const Text('Cancelar Pedido', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFDE8E8),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  );
                },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapFloatingButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: AppColors.textDark, size: 20),
      ),
    );
  }

  Widget _buildTimelineStep({
    required bool isCompleted,
    required bool isActive,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    Color iconColor;
    Color bgColor;

    if (isCompleted) {
      iconColor = Colors.white;
      bgColor = const Color(0xFF006D3E);
    } else if (isActive) {
      iconColor = const Color(0xFF006D3E);
      bgColor = const Color(0xFF006D3E).withAlpha(51);
    } else {
      iconColor = AppColors.textGrey;
      bgColor = AppColors.borderLight;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: const Color(0xFF006D3E).withAlpha(128), width: 4) : null,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? const Color(0xFF006D3E) : AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive || isCompleted ? AppColors.textDark : AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? AppColors.primary : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
