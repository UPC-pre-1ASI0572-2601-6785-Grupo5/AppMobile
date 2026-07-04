import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import '../services/order_service.dart';
import '../services/profile_service.dart';
import '../services/session_manager.dart';
import '../services/geocoding_service.dart';
import 'order_confirmation_screen.dart';
import 'order_failed_screen.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final OrderService _orderService = OrderService();
  final ProfileService _profileService = ProfileService();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  String _selectedFuel = 'Diésel';
  String? _selectedAddress;
  List<Map<String, dynamic>> _userSites = [];
  bool _isLoading = false;
  bool _isLoadingSites = true;
  bool _isLoadingMap = false;
  LatLng _targetLocation = const LatLng(-12.0464, -77.0428);
  String _calculatedEta = "24 - 48 Horas";
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    final user = SessionManager.instance.user;
    if (user != null) {
      try {
        final sites = await _profileService.getSites(user.id);
        if (mounted) {
          setState(() {
            _userSites = sites;
            if (sites.isNotEmpty) {
              _selectedAddress = sites.first['address'];
              _resolveLocation(_selectedAddress!);
            }
            _isLoadingSites = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoadingSites = false);
        }
      }
    } else {
      if (mounted) setState(() => _isLoadingSites = false);
    }
  }

  Future<void> _resolveLocation(String address) async {
    setState(() => _isLoadingMap = true);
    final location = await GeocodingService.instance.getCoordinatesFromAddress(address);
    if (mounted) {
      setState(() {
        _targetLocation = location;
        _isLoadingMap = false;
      });
      _calculateEta(location);
      try {
        _mapController.move(_targetLocation, 14.0);
      } catch (_) {}
    }
  }

  void _calculateEta(LatLng target) {
    const double originLat = -12.0464;
    const double originLng = -77.0428;
    
    double dLat = (target.latitude - originLat) * pi / 180.0;
    double dLng = (target.longitude - originLng) * pi / 180.0;
    
    double a = sin(dLat/2) * sin(dLat/2) +
               cos(originLat * pi / 180.0) * cos(target.latitude * pi / 180.0) *
               sin(dLng/2) * sin(dLng/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double distanceKm = 6371 * c;
    
    double hours = distanceKm / 40.0;
    if (hours < 0.5) hours = 0.5; // Mínimo 30 min
    
    int totalMinutes = (hours * 60).round();
    
    setState(() {
      if (totalMinutes < 60) {
        _calculatedEta = "$totalMinutes min";
      } else {
        int h = totalMinutes ~/ 60;
        int m = totalMinutes % 60;
        _calculatedEta = m > 0 ? "${h}h ${m}m" : "${h}h";
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese la cantidad en litros')),
      );
      return;
    }

    final double qty = double.tryParse(_qtyController.text) ?? 0.0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad debe ser mayor a 0')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final createdOrder = await _orderService.createOrder(
        productName: _selectedFuel,
        name: _nameController.text.trim(),
        quantityGallons: qty,
        documentRef: '${_selectedAddress ?? "Sin Sede"} | ${_dateController.text}',
      );
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderConfirmationScreen(order: createdOrder, eta: _calculatedEta)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderFailedScreen()),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _dateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nuevo Pedido',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB2EBF2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.memory, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recomendación IoT', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Basado en tus niveles actuales, te sugerimos 5000L (Precisión 95%)', style: TextStyle(fontSize: 12, color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Nombre del Pedido (Opcional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ej. Pedido Mensual Norte',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Cantidad (litros)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ej. 5000',
                suffixText: 'Lts',
                suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Tipo de Combustible', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildFuelTypeOption('Diésel', Icons.local_gas_station)),
                const SizedBox(width: 12),
                Expanded(child: _buildFuelTypeOption('Premium', Icons.ev_station)),
                const SizedBox(width: 12),
                Expanded(child: _buildFuelTypeOption('Regular', Icons.water_drop_outlined)),
              ],
            ),
            const SizedBox(height: 24),

            const Text('Dirección de Entrega', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.map_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _isLoadingSites
                        ? const Center(child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          ))
                        : _userSites.isEmpty
                            ? const Text('No tienes sedes registradas. Añade una en tu Perfil.', style: TextStyle(color: Colors.red, fontSize: 12))
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedAddress,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                                  items: _userSites.map((site) {
                                    return DropdownMenuItem<String>(
                                      value: site['address'] as String,
                                      child: Text(site['name'] + ' - ' + site['address'], style: const TextStyle(fontSize: 14, color: AppColors.textDark), overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedAddress = val);
                                      _resolveLocation(val);
                                    }
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Fecha Programada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: 'dd/mm/yyyy',
                prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
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
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                          userAgentPackageName: 'com.example.fueltrack',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _targetLocation,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: AppColors.primary, size: 36),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_isLoadingMap)
                      const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text('Ubicación confirmada', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 const Text('Tiempo estimado de entrega', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                 Text(_calculatedEta, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
               ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 24, width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Confirmar Pedido >', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelTypeOption(String name, IconData icon) {
    bool isSelected = _selectedFuel == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFuel = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textGrey, size: 28),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}