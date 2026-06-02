import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/consumption_bar_chart.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';
import '../widgets/recent_order_card.dart';
import 'orders_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _bottomNavIndex = 0;
  int _selectedFilter = 0;

  static const _recentOrders = [
    RecentOrderItem(
      id: '#FT-2023-01',
      volume: '5000 Litros',
      date: '12 Oct',
      status: RecentOrderStatus.enRuta,
      eta: '15 min',
    ),
    RecentOrderItem(
      id: '#FT-2023-04',
      volume: '12000 Litros',
      date: '11 Oct',
      status: RecentOrderStatus.confirmado,
    ),
    RecentOrderItem(
      id: '#FT-2022-98',
      volume: '8500 Litros',
      date: '10 Oct',
      status: RecentOrderStatus.entregado,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      appBar: const FuelTrackAppBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlertBanner(),
            const SizedBox(height: 16),
            _buildKpiGrid(),
            const SizedBox(height: 16),
            _buildConsumptionChart(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 20),
            _buildRecentOrdersHeader(context),
            const SizedBox(height: 12),
            ..._recentOrders.map((o) => RecentOrderCard(order: o)),
          ],
        ),
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: _bottomNavIndex,
        activeStyle: BottomNavActiveStyle.tinted,
        onTap: (index) => handleMainNavigation(context, index, _bottomNavIndex),
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.alertBannerDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.riskRed,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alerta Crítica',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Riesgo de desabastecimiento en Sede Norte',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid() {
    const gap = 16.0;
    const cardHeight = 124.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - gap) / 2;

        return SizedBox(
          height: cardHeight * 2 + gap,
          child: Column(
            children: [
              Row(
                children: [
                  _kpiCell(
                    width: cardWidth,
                    height: cardHeight,
                    child: const _KpiCard(
                      label: 'Activos',
                      value: '8',
                      sublabel: 'Pedidos',
                      sublabelColor: AppColors.kpiGreen,
                      icon: Icons.sync,
                    ),
                  ),
                  const SizedBox(width: gap),
                  _kpiCell(
                    width: cardWidth,
                    height: cardHeight,
                    child: const _KpiCard(
                      label: 'Mensual',
                      value: '125k',
                      sublabel: 'Litros',
                      icon: Icons.calendar_today_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: gap),
              Row(
                children: [
                  _kpiCell(
                    width: cardWidth,
                    height: cardHeight,
                    child: const _KpiCard(
                      label: 'Burn Rate',
                      value: '78%',
                      icon: Icons.local_fire_department_outlined,
                      showProgress: true,
                      progress: 0.78,
                    ),
                  ),
                  const SizedBox(width: gap),
                  _kpiCell(
                    width: cardWidth,
                    height: cardHeight,
                    child: const _KpiCard(
                      label: 'Abastecimiento',
                      value: 'Riesgo',
                      sublabel: 'Revisión requerida',
                      sublabelColor: AppColors.riskRedSubtle,
                      valueColor: AppColors.riskRed,
                      icon: Icons.inventory_2_outlined,
                      isRiskCard: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _kpiCell({
    required double width,
    required double height,
    required Widget child,
  }) {
    return SizedBox(width: width, height: height, child: child);
  }

  Widget _buildConsumptionChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tendencia de Consumo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ConsumptionBarChart(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Buscar pedido por código...',
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: AppColors.textLight, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = ['Todos', 'En ruta', 'Pendientes', 'Completados'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = _selectedFilter == index;
          return Padding(
            padding: EdgeInsets.only(right: index < filters.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.chipInactiveText,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecentOrdersHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Pedidos Recientes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrdersScreen()),
            );
          },
          child: const Text(
            'Ver todos',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final Color sublabelColor;
  final Color? valueColor;
  final IconData icon;
  final bool showProgress;
  final double progress;
  final bool isRiskCard;

  const _KpiCard({
    required this.label,
    required this.value,
    this.sublabel = '',
    this.sublabelColor = AppColors.chipInactiveText,
    required this.icon,
    this.showProgress = false,
    this.progress = 0,
    this.valueColor,
    this.isRiskCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: isRiskCard
            ? Border.all(color: AppColors.riskRed, width: 1.5)
            : Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF495057)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212529),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isRiskCard ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? const Color(0xFF212529),
                  height: 1.05,
                  letterSpacing: -0.8,
                ),
              ),
              if (showProgress) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox(
                    height: 7,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFE9ECEF),
                      color: AppColors.kpiGreen,
                    ),
                  ),
                ),
              ] else if (sublabel.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: sublabelColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
