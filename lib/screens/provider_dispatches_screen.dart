import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'resource_assignment_screen.dart';
import 'provider_tracking_screen.dart';
import 'iot_cistern_detail_screen.dart'; // <-- IMPORTANTE: Agregamos la pantalla de Detalle Cisterna
import 'new_order_screen.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'package:intl/intl.dart';

class ProviderDispatchesScreen extends StatefulWidget {
  const ProviderDispatchesScreen({Key? key}) : super(key: key);

  @override
  State<ProviderDispatchesScreen> createState() => _ProviderDispatchesScreenState();
}

class _ProviderDispatchesScreenState extends State<ProviderDispatchesScreen> {
  String _selectedFilter = 'Todos';
  bool _isLoading = true;
  List<OrderModel> _orders = [];
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Buscador
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por ID, Cliente o Destino...',
                hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Botón Nuevo Despacho
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewOrderScreen()),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text('Nuevo Despacho', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D3E),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Filtros (Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos'),
                _buildFilterChip('Pendientes'),
                _buildFilterChip('En Ruta'),
                _buildFilterChip('Completados'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary)))
          else ..._buildDynamicOrdersList(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicOrdersList() {
    List<OrderModel> filtered = _orders.where((o) {
      if (_selectedFilter == 'Todos') return true;
      if (_selectedFilter == 'Pendientes' && (o.status == 'PENDING_APPROVAL' || o.status == 'PENDING')) return true;
      if (_selectedFilter == 'En Ruta' && (o.status == 'DISPATCHED' || o.status == 'IN_TRANSIT')) return true;
      if (_selectedFilter == 'Completados' && (o.status == 'COMPLETED' || o.status == 'DELIVERED')) return true;
      return false;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (filtered.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('No hay despachos que coincidan con tu búsqueda', style: TextStyle(color: AppColors.textGrey))),
        )
      ];
    }

    return filtered.map((order) {
      Color statusBgColor;
      Color statusTextColor;
      String statusText;
      Widget actions;

      bool isCompleted = false;

      switch (order.status) {
        case 'PENDING_APPROVAL':
        case 'PENDING':
          statusBgColor = const Color(0xFFFFEBEE);
          statusTextColor = AppColors.error;
          statusText = 'Pendiente';
          actions = Row(
            children: [
              Expanded(child: _buildSolidButton('Aprobar', const Color(0xFF006D3E), Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: _buildOutlinedButton('Ver Detalles')),
            ],
          );
          break;
        case 'APPROVED':
          statusBgColor = const Color(0xFFD4EFDF);
          statusTextColor = const Color(0xFF006D3E);
          statusText = 'Confirmado';
          actions = SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const ResourceAssignmentScreen()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProviderTrackingScreen()));
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
            child: _buildSolidButton('Ver Comprobante', const Color(0xFFEAECEE), AppColors.textGrey),
          );
          break;
        default:
          statusBgColor = const Color(0xFFEAECEE);
          statusTextColor = AppColors.textGrey;
          statusText = order.status;
          actions = const SizedBox();
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
    }).toList();
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

  Widget _buildSolidButton(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
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