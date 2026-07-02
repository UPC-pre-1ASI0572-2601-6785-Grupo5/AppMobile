import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'tracking_screen.dart';
import 'new_order_screen.dart';
import 'alerts_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  String _activeSort = 'Fecha'; // Can be 'Fecha', 'Estado', 'Codigo'
  bool _sortAscending = false;
  
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final orders = await _orderService.getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
      _applySort();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSortSelected(String sortType) {
    setState(() {
      if (_activeSort == sortType) {
        _sortAscending = !_sortAscending;
      } else {
        _activeSort = sortType;
        _sortAscending = false;
      }
    });
    _applySort();
  }

  int _getStatusWeight(String status) {
    if (status.startsWith('PENDING')) return 1;
    if (status == 'APPROVED') return 2;
    if (status == 'DISPATCHED' || status == 'IN_TRANSIT') return 3;
    if (status == 'COMPLETED' || status == 'DELIVERED') return 4;
    return 5;
  }

  void _applySort() {
    setState(() {
      _orders.sort((a, b) {
        int comparison = 0;
        if (_activeSort == 'Fecha') {
          comparison = a.createdAt.compareTo(b.createdAt);
        } else if (_activeSort == 'Estado') {
          comparison = _getStatusWeight(a.status).compareTo(_getStatusWeight(b.status));
        } else if (_activeSort == 'Codigo') {
          comparison = a.id.compareTo(b.id);
        }
        
        return _sortAscending ? comparison : -comparison;
      });
    });
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
  
  String _formatTime(String isoString) {
    if (isoString.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return isoString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING_APPROVAL': return const Color(0xFFE67E22);
      case 'PENDING': return const Color(0xFFE67E22);
      case 'APPROVED': return const Color(0xFF1976D2);
      case 'DISPATCHED': return const Color(0xFF006D3E);
      case 'COMPLETED': return AppColors.primary;
      default: return AppColors.textGrey;
    }
  }

  String _getStatusTranslation(String status) {
    switch (status) {
      case 'PENDING_APPROVAL': return 'Pendiente';
      case 'PENDING': return 'Pendiente';
      case 'APPROVED': return 'Aprobado';
      case 'DISPATCHED': return 'En ruta';
      case 'IN_TRANSIT': return 'En ruta';
      case 'COMPLETED': return 'Completado';
      case 'DELIVERED': return 'Entregado';
      default: return status;
    }
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles del Pedido #FT-${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              _buildDetailRow('Combustible', order.productName),
              _buildDetailRow('Cantidad', '${order.quantityGallons} Galones'),
              _buildDetailRow('Estado', _getStatusTranslation(order.status)),
              _buildDetailRow('Fecha', _formatDate(order.createdAt)),
              if (order.documentRef.isNotEmpty) _buildDetailRow('Ref. / Dirección', order.documentRef),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cerrar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textDark))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStateFilterChip('Todos'),
                    _buildStateFilterChip('Pendientes', apiStatus: 'PENDING_APPROVAL'),
                    _buildStateFilterChip('Aprobados', apiStatus: 'APPROVED'),
                    _buildStateFilterChip('En ruta', apiStatus: 'DISPATCHED'),
                    _buildStateFilterChip('Completados', apiStatus: 'COMPLETED'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _onSortSelected('Fecha'),
                    child: _buildFilterChip(Icons.calendar_today_outlined, 'Fecha', _activeSort == 'Fecha', _sortAscending),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _onSortSelected('Estado'),
                    child: _buildFilterChip(Icons.swap_vert, 'Estado', _activeSort == 'Estado', _sortAscending),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _onSortSelected('Codigo'),
                    child: _buildFilterChip(Icons.tag, '# Código', _activeSort == 'Codigo', _sortAscending),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                        const SizedBox(height: 16),
                        Text(_errorMessage, style: const TextStyle(color: AppColors.error), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _fetchOrders, child: const Text('Reintentar')),
                      ],
                    ),
                  ),
                )
              else if (_orders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No hay pedidos registrados', style: TextStyle(color: AppColors.textGrey)),
                  ),
                )
              else Builder(
                builder: (context) {
                  final filteredOrders = _orders.where((o) {
                    if (_selectedFilter == 'Todos') return true;
                    if (_selectedFilter == 'Pendientes' && o.status == 'PENDING_APPROVAL') return true;
                    if (_selectedFilter == 'Aprobados' && o.status == 'APPROVED') return true;
                    if (_selectedFilter == 'En ruta' && (o.status == 'DISPATCHED' || o.status == 'IN_TRANSIT')) return true;
                    if (_selectedFilter == 'Completados' && (o.status == 'COMPLETED' || o.status == 'DELIVERED')) return true;
                    return false;
                  }).toList();

                  if (filteredOrders.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('No hay pedidos que coincidan', style: TextStyle(color: AppColors.textGrey)),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(
                        context,
                        order: order,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
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
                      children: const [
                        Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Resumen Mensual', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Estado de tus últimos 30 días', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(_orders.fold(0.0, (sum, o) => sum + o.quantityGallons) / 1000).toStringAsFixed(1)}k', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              const Text('Galones\nEntregados', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.2)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 40, color: AppColors.borderLight),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_orders.where((o) => o.status == 'COMPLETED').length}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const Text('Pedidos\nExitosos', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewOrderScreen(),
              fullscreenDialog: true,
            ),
          );
          if (result == true) {
            _fetchOrders();
          }
        },
        backgroundColor: const Color(0xFF006D3E),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label, bool isSelected, bool isAscending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? AppColors.primary : AppColors.textGrey),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textGrey)),
          if (isSelected) ...[
            const SizedBox(width: 4),
            Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: AppColors.primary),
          ]
        ],
      ),
    );
  }

  Widget _buildStateFilterChip(String label, {String? apiStatus}) {
    bool isSelected = _selectedFilter == label;
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
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : AppColors.textDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, {required OrderModel order}) {
    final statusColor = _getStatusColor(order.status);
    final statusText = _getStatusTranslation(order.status);
    final isDispatched = order.status == 'DISPATCHED' || order.status == 'En ruta';

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
              Text('#FT-${order.createdAt.substring(0, 4)}-${order.id}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.local_shipping, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.water_drop_outlined, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Volumen', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  Row(
                    children: [
                      Text('${order.quantityGallons} Galones', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      if (order.isCapped) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.shade200)),
                          child: const Text('Topado', style: TextStyle(fontSize: 9, color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actualizado', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  Text('${_formatDate(order.updatedAt)} ${_formatTime(order.updatedAt)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDate(order.createdAt), style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              if (isDispatched)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrackingScreen(order: order)),
                    );
                  },
                  child: const Text('Rastrear >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                )
              else
                GestureDetector(
                  onTap: () => _showOrderDetails(order),
                  child: const Text('Ver más', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
