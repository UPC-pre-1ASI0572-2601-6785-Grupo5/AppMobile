import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../config/api_config.dart';
import '../services/session_manager.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<dynamic> _allOrders = [];
  List<dynamic> _filteredOrders = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchOrders();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredOrders = _allOrders.where((order) {
        final id = '#${order['id'] ?? ''}'.toLowerCase();
        final name = (order['name']?.toString() ?? '').toLowerCase();
        return id.contains(_searchQuery) || name.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = SessionManager.instance.token;
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allOrders = data;
          _filteredOrders = data;
          _onSearchChanged(); // Apply current search if any
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true, // Se habilita el boton de atras
        iconTheme: const IconThemeData(color: AppColors.textDark),
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
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchOrders,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titulo y Descripcion
              const Text('Historial de Pedidos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Consulta y descarga registros de suministros\nfinalizados.', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por código o nombre...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 24),

              if (_isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
              else if (_error != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                        const SizedBox(height: 16),
                        Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error)),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _fetchOrders, child: const Text('Reintentar'))
                      ],
                    ),
                  ),
                )
              else if (_allOrders.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No hay pedidos registrados', style: TextStyle(color: AppColors.textGrey)),
                    ),
                  )
              else if (_filteredOrders.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No se encontraron resultados', style: TextStyle(color: AppColors.textGrey)),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredOrders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _buildHistoryCard(
                        id: '#${order['id'] ?? ''}',
                        name: order['name']?.toString() ?? '',
                        date: order['createdAt'] != null ? order['createdAt'].substring(0, 10) : 'N/A',
                        time: order['createdAt'] != null && order['createdAt'].length > 16 ? order['createdAt'].substring(11, 16) : 'N/A',
                        fuel: order['fuelType']?.toString() ?? 'Desconocido',
                        qty: '${order['gallons']} Gal.',
                        status: order['status']?.toString() ?? 'PENDIENTE',
                      );
                    },
                  ),

              const SizedBox(height: 24),
              if (!_isLoading && _filteredOrders.isNotEmpty)
                Center(child: Text('Mostrando ${_filteredOrders.length} resultados', style: const TextStyle(fontSize: 11, color: AppColors.textGrey))),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({required String id, required String name, required String date, required String time, required String fuel, required String qty, required String status}) {
    Color statusColor = AppColors.primary;
    if (status == 'PENDING') statusColor = Colors.orange;
    if (status == 'CANCELLED') statusColor = AppColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFE8F8F5), shape: BoxShape.circle),
                    child: const Icon(Icons.local_shipping, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ID:', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                      Text(id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      if (name.isNotEmpty)
                        Text(name, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(status == 'PENDING' ? Icons.hourglass_empty : Icons.check_circle_outline, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('COMBUSTIBLE', style: TextStyle(fontSize: 9, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(fuel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CANTIDAD', style: TextStyle(fontSize: 9, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(qty, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
