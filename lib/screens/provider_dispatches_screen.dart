import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'resource_assignment_screen.dart';
import 'provider_tracking_screen.dart';
import 'iot_cistern_detail_screen.dart'; // <-- IMPORTANTE: Agregamos la pantalla de Detalle Cisterna
import 'new_order_screen.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'package:intl/intl.dart';
import 'provider_order_details_screen.dart';
import 'digital_receipt_screen.dart';

class ProviderDispatchesScreen extends StatefulWidget {
  const ProviderDispatchesScreen({Key? key}) : super(key: key);

  @override
  State<ProviderDispatchesScreen> createState() => _ProviderDispatchesScreenState();
}

class _ProviderDispatchesScreenState extends State<ProviderDispatchesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Todos';
  bool _isLoading = true;
  List<OrderModel> _orders = [];
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getOrders();
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return 'Desconocida';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Buscador (Opcional, lo mantenemos arriba de los tabs)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por ID, Cliente o Destino...',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: AppColors.textGrey, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        
        // 2. Tabs: Disponibles y Mis Pedidos
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF006D3E),
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: const Color(0xFF006D3E),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Disponibles'),
            Tab(text: 'Mis Pedidos'),
          ],
        ),
        
        // 3. Vistas de Tabs
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildAvailableOrdersView(),
                  _buildMyOrdersView(),
                ],
              ),
        ),
      ],
    );
  }

  Widget _buildAvailableOrdersView() {
    // Pedidos sin proveedor (providerId == null) y en estado PENDING_APPROVAL
    List<OrderModel> availableOrders = _orders.where((o) => o.providerId == null && (o.status == 'PENDING_APPROVAL' || o.status == 'PENDING')).toList();
    availableOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (availableOrders.isEmpty) {
      return const Center(child: Text('No hay pedidos disponibles por el momento.', style: TextStyle(color: AppColors.textGrey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(availableOrders[index], true);
      },
    );
  }

  Widget _buildMyOrdersView() {
    // Pedidos que fueron aceptados por mi (providerId != null)
    List<OrderModel> myOrders = _orders.where((o) => o.providerId != null).toList();

    // Filtros de Mis Pedidos
    List<OrderModel> filtered = myOrders.where((o) {
      if (_selectedFilter == 'Todos') return true;
      if (_selectedFilter == 'En Ruta' && (o.status == 'DISPATCHED' || o.status == 'IN_TRANSIT')) return true;
      if (_selectedFilter == 'Completados' && (o.status == 'COMPLETED' || o.status == 'DELIVERED')) return true;
      return false;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chips de filtros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos'),
                _buildFilterChip('En Ruta'),
                _buildFilterChip('Completados'),
              ],
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No tienes pedidos en esta categoría.', style: TextStyle(color: AppColors.textGrey)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(filtered[index], false);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isAvailableView) {

    Color statusBgColor;
    Color statusTextColor;
    String statusText;
    Widget actions;

    bool isCompleted = false;

    if (isAvailableView) {
      statusBgColor = const Color(0xFFFFEBEE);
      statusTextColor = AppColors.error;
      statusText = 'Disponible';
      actions = Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _orderService.approveOrder(order.id);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pedido aceptado correctamente'), backgroundColor: Color(0xFF2ECC71)),
                    );
                    _fetchOrders();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al aceptar pedido: $e'), backgroundColor: AppColors.error),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D3E),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Aceptar Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildOutlinedButton('Ver Detalles', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProviderOrderDetailsScreen(order: order)),
              );
            }),
          ),
        ],
      );
    } else {
      switch (order.status) {
        case 'APPROVED':
          statusBgColor = const Color(0xFFD4EFDF);
          statusTextColor = const Color(0xFF006D3E);
          statusText = 'Confirmado';
          actions = SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => ResourceAssignmentScreen(order: order)));
                _fetchOrders();
              },
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 16, color: Color(0xFF006D3E)),
              label: const Text('Asignar Conductor', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF006D3E)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          );
          break;
        case 'DISPATCHED':
        case 'IN_TRANSIT':
          statusBgColor = const Color(0xFF2ECC71);
          statusTextColor = Colors.white;
          statusText = 'En Ruta';
          actions = SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderTrackingScreen(order: order)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4EFDF),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Rastreo en Vivo', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          );
          break;
        case 'COMPLETED':
        case 'DELIVERED':
          statusBgColor = const Color(0xFFEAECEE);
          statusTextColor = AppColors.textGrey;
          statusText = 'Completado';
          isCompleted = true;
          actions = SizedBox(
            width: double.infinity,
            child: _buildSolidButton('Ver Comprobante', const Color(0xFFEAECEE), AppColors.textGrey, onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DigitalReceiptScreen(order: order, signaturePoints: const [])),
              );
            }),
          );
          break;
        default:
          statusBgColor = const Color(0xFFEAECEE);
          statusTextColor = AppColors.textGrey;
          statusText = order.status;
          actions = const SizedBox();
      }
    }

    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _buildDispatchCard(
          id: '#FT-${order.id}',
          status: statusText,
          statusBgColor: statusBgColor,
          statusTextColor: statusTextColor,
          client: order.documentRef.isEmpty ? 'Cliente Desconocido' : 'Documento: ${order.documentRef}',
          details: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (order.status == 'DISPATCHED' || order.status == 'IN_TRANSIT') ...[
                Stack(
                  children: [
                    Container(height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
                    Container(width: 150, height: 4, decoration: BoxDecoration(color: const Color(0xFF006D3E), borderRadius: BorderRadius.circular(2))),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              _buildDetailRow(Icons.water_drop_outlined, '${order.quantityGallons} Galones - ${order.productName}', AppColors.textDark),
              const SizedBox(height: 4),
              _buildDetailRow(
                isCompleted ? Icons.check_circle_outline : Icons.access_time,
                isCompleted ? 'Completado el ${_formatDate(order.updatedAt)}' : 'Fecha: ${_formatDate(order.createdAt)}',
                isCompleted ? const Color(0xFF006D3E) : AppColors.textDark,
                isBold: isCompleted,
              ),
            ],
          ),
          actions: actions,
        ),
      );
  }

  // ====== WIDGETS REUTILIZABLES DE ESTA PANTALLA ======

  Widget _buildFilterChip(String label) {
    bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2ECC71) : const Color(0xFFEAECEE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildDispatchCard({
    required String id,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required String client,
    required Widget details,
    required Widget actions,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(client, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          details,
          const SizedBox(height: 16),
          actions,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color textColor, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 11, color: textColor, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildSolidButton(String text, Color bgColor, Color textColor, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  // Modificado para aceptar navegación opcional (onPressed)
  Widget _buildOutlinedButton(String text, {VoidCallback? onPressed}) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}