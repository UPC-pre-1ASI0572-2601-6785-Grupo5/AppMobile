import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/fuel_order.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_bottom_navigation.dart';
import 'order_history_screen.dart';
import 'new_order_sheet.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedFilter = 0;
  int _bottomNavIndex = 1;

  static const _orders = [
    FuelOrder(
      id: '#FT-2023-45',
      productName: 'Diésel Premium B5',
      status: OrderStatus.enRuta,
      volumeLiters: '12,500 Litros',
      secondaryLabel: 'ETA Estimado',
      secondaryValue: 'Hoy, 14:30 PM',
      secondaryIcon: Icons.schedule,
      dateLabel: '24 Oct 2023',
    ),
    FuelOrder(
      id: '#FT-2023-42',
      productName: 'Gasolina 95 Octanos',
      status: OrderStatus.confirmado,
      volumeLiters: '5,000 Litros',
      secondaryLabel: 'Fecha Entrega',
      secondaryValue: '28 Oct 2023',
      secondaryIcon: Icons.calendar_today_outlined,
      dateLabel: '22 Oct 2023',
    ),
    FuelOrder(
      id: '#FT-2023-38',
      productName: 'Diésel Biodiesel B10',
      status: OrderStatus.pendiente,
      volumeLiters: '8,200 Litros',
      secondaryLabel: 'Validación',
      secondaryValue: 'En proceso',
      secondaryIcon: Icons.hourglass_top_outlined,
      dateLabel: '20 Oct 2023',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F4),
      appBar: const FuelTrackAppBar(backgroundColor: Color(0xFFF0F4F4)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Gestión de Pedidos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Monitorea y administra tus solicitudes de combustible en tiempo real.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildFilterChips(),
                const SizedBox(height: 20),
                ..._orders.map((order) => OrderCard(order: order)),
                const SizedBox(height: 8),
                _buildPromoBanner(),
                const SizedBox(height: 20),
                _buildMonthlySummary(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 88,
            child: _buildFab(context),
          ),
        ],
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: _bottomNavIndex,
        onTap: (index) => handleMainNavigation(context, index, _bottomNavIndex),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Buscar #FT-2023...',
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: AppColors.textLight, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      _FilterData(label: 'Fecha', icon: Icons.calendar_today_outlined),
      _FilterData(label: 'Estado', icon: Icons.swap_vert),
      _FilterData(label: 'Código', icon: Icons.tag, prefix: '# '),
    ];

    return Row(
      children: List.generate(filters.length, (index) {
        final isSelected = _selectedFilter == index;
        final filter = filters[index];
        return Padding(
          padding: EdgeInsets.only(right: index < filters.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.textGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${filter.prefix ?? ''}${filter.label}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D3D2E),
            Color(0xFF1A5C45),
            Color(0xFF0F4A38),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.hexagon_outlined,
              size: 120,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Optimiza tu Flota',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Programa tus pedidos automáticos y recibe descuentos exclusivos por volumen este mes.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Saber más',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary(BuildContext context) {
    return Material(
      color: const Color(0xFFE8EDEC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen Mensual',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Estado de tus últimos 30 días',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('45k', 'Litros Entregados', isPrimary: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('12', 'Pedidos Exitosos', isPrimary: false)),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isPrimary ? AppColors.primary : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  void _openNewOrder(BuildContext context) => showNewOrderSheet(context);

  Widget _buildFab(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => _openNewOrder(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'Nuevo Pedido',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          onPressed: () => _openNewOrder(context),
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}

class _FilterData {
  final String label;
  final IconData icon;
  final String? prefix;

  _FilterData({required this.label, required this.icon, this.prefix});
}
