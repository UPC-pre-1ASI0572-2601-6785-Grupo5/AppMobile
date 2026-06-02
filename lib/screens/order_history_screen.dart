import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/csv_export_error_banner.dart';
import '../widgets/orders_bottom_navigation.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const _bgColor = Color(0xFFF8F9FA);

  bool _showCsvError = false;
  bool _isExporting = false;

  static const _historyOrders = [
    _HistoryOrder(
      id: '#FLT-2024-001',
      date: '24 Oct, 2023',
      time: '14:30 PM',
      fuel: 'Diesel Ultra',
      quantity: '1,200 Litros',
    ),
    _HistoryOrder(
      id: '#FLT-2024-002',
      date: '23 Oct, 2023',
      time: '09:15 AM',
      fuel: 'Gasolina 95',
      quantity: '850 Litros',
    ),
    _HistoryOrder(
      id: '#FLT-2024-003',
      date: '22 Oct, 2023',
      time: '16:45 PM',
      fuel: 'Diesel Premium B5',
      quantity: '2,400 Litros',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: const FuelTrackAppBar(
        backgroundColor: _bgColor,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showCsvError) ...[
              CsvExportErrorBanner(
                onDismiss: () => setState(() => _showCsvError = false),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Historial de Pedidos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Consulta y descarga registros de suministros finalizados.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.chipInactiveText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _buildExportButton(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 20),
            _buildSummaryCard(
              icon: Icons.check_circle_outline,
              iconBg: AppColors.statusEnRutaBg,
              label: 'TOTAL ENTREGADOS',
              value: '1,284',
              badge: '+12%',
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              icon: Icons.local_gas_station_outlined,
              iconBg: const Color(0xFFF3F4F6),
              label: 'VOLUMEN TOTAL',
              value: '45.2k L',
            ),
            const SizedBox(height: 12),
            _buildEfficiencyCard(),
            const SizedBox(height: 20),
            ..._historyOrders.map((o) => _HistoryOrderCard(order: o)),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Mostrando 10 de 1,284 resultados',
                style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
              ),
            ),
            const SizedBox(height: 12),
            _buildLoadMoreButton(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: 1,
        activeStyle: BottomNavActiveStyle.filled,
        onTap: (index) => handleMainNavigation(context, index, 1),
      ),
    );
  }

  Future<void> _exportCsv() async {
    setState(() {
      _isExporting = true;
      _showCsvError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isExporting = false;
      _showCsvError = true;
    });
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.trackingDarkGreen,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _isExporting ? null : _exportCsv,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isExporting)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.download_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isExporting ? 'Generando...' : 'Exportar CSV',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
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
          hintText: 'FLT-2024',
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: AppColors.textLight, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.statusEnRutaBg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Estado: Entregado',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.statusEnRutaText,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.close, size: 16, color: AppColors.statusEnRutaText.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Últimos 30 días',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.chipInactiveText,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.chipInactiveText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
    String? badge,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: AppColors.trackingDarkGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.chipInactiveText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Text(
              badge,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.kpiGreen,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.trackingDarkGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eficiencia de Entrega',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '98.4%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.984,
              minHeight: 6,
              backgroundColor: Color(0x33FFFFFF),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.chipInactiveText,
          backgroundColor: const Color(0xFFF3F4F6),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Cargar más registros',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _HistoryOrder {
  final String id;
  final String date;
  final String time;
  final String fuel;
  final String quantity;

  const _HistoryOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.fuel,
    required this.quantity,
  });
}

class _HistoryOrderCard extends StatelessWidget {
  final _HistoryOrder order;

  const _HistoryOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.statusEnRutaBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.trackingDarkGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${order.id}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(order.date, style: const TextStyle(fontSize: 12, color: AppColors.chipInactiveText)),
                        const SizedBox(width: 14),
                        const Icon(Icons.access_time, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(order.time, style: const TextStyle(fontSize: 12, color: AppColors.chipInactiveText)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.statusEnRutaBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Entregado',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.statusEnRutaText,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COMBUSTIBLE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.chipInactiveText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.fuel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CANTIDAD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.chipInactiveText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.quantity,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, size: 22, color: AppColors.chipInactiveText),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.description_outlined, size: 22, color: AppColors.chipInactiveText),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
