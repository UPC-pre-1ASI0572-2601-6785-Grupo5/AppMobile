import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'tracking_screen.dart';
import 'orders_screen.dart';
import 'analytics_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DashboardScreen extends StatefulWidget {
  final int? initialIndex;
  final OrderModel? trackingOrder;
  const DashboardScreen({Key? key, this.initialIndex, this.trackingOrder}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'Todos';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
    _initializeIndex();
    _fetchDashboardData();
  }

  Future<void> _initializeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (widget.initialIndex != null) {
      prefs.setInt('dashboard_index', widget.initialIndex!);
    } else {
      final savedIndex = prefs.getInt('dashboard_index');
      if (savedIndex != null && mounted) {
        setState(() {
          _selectedIndex = savedIndex;
        });
      }
    }
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('dashboard_index', index);
  }
  List<Widget> get _pages => [
    _buildDashboardView(),
    const OrdersScreen(),
    TrackingScreen(order: widget.trackingOrder),
    const AnalyticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? AppColors.primary.withAlpha(26) : Colors.transparent,
                  shape: BoxShape.circle
              ),
              child: Icon(Icons.dashboard_customize, color: _selectedIndex == 0 ? AppColors.primary : AppColors.textGrey),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined),
              label: 'Pedidos'
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedIndex == 2 ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.local_shipping_outlined, color: _selectedIndex == 2 ? Colors.white : AppColors.textGrey),
            ),
            label: 'Seguimiento',
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3 ? Icons.bar_chart : Icons.bar_chart_outlined),
              label: 'Analítica'
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 4 ? Icons.person : Icons.person_outline),
              label: 'Perfil'
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(content, style: const TextStyle(color: AppColors.textDark, height: 1.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    // Calculos dinamicos
    final totalGallons = _orders.fold(0.0, (sum, order) => sum + order.quantityGallons);
    final burnRate = (totalGallons / 15000.0).clamp(0.0, 1.0); // Asume cuota 15000
    
    String abastecimientoStatus = 'Óptimo';
    Color abastecimientoColor = AppColors.success;
    String abastecimientoMsg = 'Niveles adecuados';
    
    if (burnRate > 0.8) {
      abastecimientoStatus = 'Riesgo';
      abastecimientoColor = AppColors.error;
      abastecimientoMsg = 'Revisión requerida';
    } else if (burnRate > 0.5) {
      abastecimientoStatus = 'Estable';
      abastecimientoColor = Colors.orange;
      abastecimientoMsg = 'Consumo moderado';
    }

    final List<double> weekly = List.filled(7, 0.0);
    for (var order in _orders) {
      final date = DateTime.tryParse(order.createdAt)?.toLocal();
      if (date != null) {
        // weekday 1 = Lunes, 7 = Domingo
        weekly[date.weekday - 1] += 1;
      }
    }
    final maxOrders = weekly.reduce((a, b) => a > b ? a : b);
    final List<double> weeklyNorm = maxOrders > 0 
        ? weekly.map((g) => g > 0 ? ((g / maxOrders) * 100).clamp(8.0, 100.0) : 0.0).toList() 
        : List.filled(7, 0.0);

    return RefreshIndicator(
      onRefresh: _fetchDashboardData,
      child: Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(12),
                border: const Border(left: BorderSide(color: AppColors.error, width: 4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.error.withAlpha(51), shape: BoxShape.circle),
                    child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alerta Crítica', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Riesgo de desabastecimiento en Sede Norte', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildMetricCard(
                  title: 'Activos', 
                  value: _orders.where((o) => o.status != 'COMPLETED' && o.status != 'CANCELLED').length.toString(), 
                  subtitle: 'Pedidos', 
                  subtitleColor: AppColors.primary, 
                  icon: Icons.autorenew)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard(
                  title: 'Mensual', 
                  value: '${(_orders.fold(0.0, (sum, o) => sum + o.quantityGallons) / 1000).toStringAsFixed(1)}k', 
                  subtitle: 'Galones', 
                  subtitleColor: AppColors.textGrey, 
                  icon: Icons.calendar_today_outlined)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: const [Icon(Icons.local_fire_department_outlined, size: 14, color: AppColors.textGrey), SizedBox(width: 4), Text('Burn Rate', style: TextStyle(fontSize: 12, color: AppColors.textGrey))]),
                            GestureDetector(
                              onTap: () => _showInfoDialog('Burn Rate', 'El "Burn Rate" indica la velocidad con la que estás consumiendo tu cuota mensual estimada de combustible. Un porcentaje alto significa que podrías requerir un nuevo pedido pronto.'),
                              child: const Icon(Icons.help_outline, size: 16, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${(burnRate * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: burnRate, backgroundColor: AppColors.borderLight, color: burnRate > 0.8 ? AppColors.error : AppColors.primary, minHeight: 4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: const [Icon(Icons.ev_station_outlined, size: 14, color: AppColors.textGrey), SizedBox(width: 4), Text('Abastecimiento', style: TextStyle(fontSize: 12, color: AppColors.textGrey))]),
                            GestureDetector(
                              onTap: () => _showInfoDialog('Estado de Abastecimiento', 'Muestra la salud actual de tu inventario basado en el Burn Rate. Te alerta si estás en riesgo de quedarte sin combustible antes de tu próximo ciclo de compra.'),
                              child: const Icon(Icons.help_outline, size: 16, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(abastecimientoStatus, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: abastecimientoColor)),
                        const SizedBox(height: 4),
                        Text(abastecimientoMsg, style: TextStyle(fontSize: 10, color: abastecimientoColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tendencia de Consumo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      GestureDetector(
                        onTap: () => _showInfoDialog('Tendencia de Consumo', 'Este gráfico de barras muestra la cantidad de pedidos realizados según el día de la semana, basado en tu historial de solicitudes.'),
                        child: const Icon(Icons.help_outline, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar('Lun', weeklyNorm[0], weeklyNorm[0] > 0 ? AppColors.primary : AppColors.borderLight),
                      _buildChartBar('Mar', weeklyNorm[1], weeklyNorm[1] > 0 ? AppColors.primary.withAlpha(200) : AppColors.borderLight),
                      _buildChartBar('Mie', weeklyNorm[2], weeklyNorm[2] > 0 ? AppColors.primary.withAlpha(200) : AppColors.borderLight),
                      _buildChartBar('Jue', weeklyNorm[3], weeklyNorm[3] > 0 ? AppColors.primary.withAlpha(200) : AppColors.borderLight),
                      _buildChartBar('Vie', weeklyNorm[4], weeklyNorm[4] > 0 ? AppColors.primary : AppColors.borderLight),
                      _buildChartBar('Sab', weeklyNorm[5], weeklyNorm[5] > 0 ? AppColors.primary.withAlpha(150) : AppColors.borderLight),
                      _buildChartBar('Dom', weeklyNorm[6], weeklyNorm[6] > 0 ? AppColors.primary.withAlpha(100) : AppColors.borderLight),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos'),
                  _buildFilterChip('Pendientes', apiStatus: 'PENDING'),
                  _buildFilterChip('Aprobados', apiStatus: 'APPROVED'),
                  _buildFilterChip('En ruta', apiStatus: 'DISPATCHED'),
                  _buildFilterChip('Completados', apiStatus: 'COMPLETED'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pedidos Recientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: const Text('Ver todos', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildDynamicOrdersList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    ));
  }

  Widget _buildMetricCard({required String title, required String value, required String subtitle, required Color subtitleColor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 14, color: AppColors.textGrey), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGrey))]),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double height, Color color) {
    return Column(
      children: [
        Container(width: 32, height: height, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      ],
    );
  }

  Widget _buildFilterChip(String label, {String? apiStatus}) {
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

  List<Widget> _buildDynamicOrdersList() {
    List<OrderModel> filtered = _orders.where((o) {
      if (_selectedFilter == 'Todos') return true;
      if (_selectedFilter == 'Pendientes' && o.status == 'PENDING_APPROVAL') return true;
      if (_selectedFilter == 'Aprobados' && o.status == 'APPROVED') return true;
      if (_selectedFilter == 'En ruta' && (o.status == 'DISPATCHED' || o.status == 'IN_TRANSIT')) return true;
      if (_selectedFilter == 'Completados' && (o.status == 'COMPLETED' || o.status == 'DELIVERED')) return true;
      return false;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (filtered.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('No hay pedidos que coincidan con tu búsqueda', style: TextStyle(color: AppColors.textGrey))),
        )
      ];
    }

    return filtered.take(5).map((order) {
      Color statusColor;
      String statusText;
      switch (order.status) {
        case 'PENDING_APPROVAL':
        case 'PENDING':
          statusColor = const Color(0xFFE67E22);
          statusText = 'Pendiente';
          break;
        case 'APPROVED':
          statusColor = const Color(0xFF1976D2);
          statusText = 'Aprobado';
          break;
        case 'DISPATCHED':
        case 'IN_TRANSIT':
          statusColor = AppColors.primary;
          statusText = 'En ruta';
          break;
        case 'COMPLETED':
        case 'DELIVERED':
          statusColor = AppColors.textGrey;
          statusText = 'Completado';
          break;
        default:
          statusColor = AppColors.textGrey;
          statusText = order.status;
      }

      String dateStr = '';
      try {
        DateTime dt = DateTime.parse(order.createdAt);
        dateStr = DateFormat('dd MMM').format(dt);
      } catch (e) {
        dateStr = order.createdAt;
      }

      return _buildOrderItem('#FT-${order.id}', '${order.quantityGallons} Galones', dateStr, null, statusText, statusColor, order.isCapped);
    }).toList();
  }

  Widget _buildOrderItem(String id, String amount, String date, String? eta, String status, Color statusColor, [bool isCapped = false]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  if (isCapped) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.shade200)),
                      child: const Text('Topado a 1000', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  if (eta != null) ...[
                    const SizedBox(width: 12),
                    const Icon(Icons.timer_outlined, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(eta, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withAlpha(51), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(fontSize: 12, color: statusColor == AppColors.textGrey ? AppColors.textDark : statusColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
