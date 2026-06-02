import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';

class AnalyticsReportScreen extends StatelessWidget {
  const AnalyticsReportScreen({Key? key}) : super(key: key);

  static const _bottomNavIndex = 3;
  static const _bgColor = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: const FuelTrackAppBar(backgroundColor: _bgColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportButton(),
            const SizedBox(height: 16),
            _buildCriticalAlert(),
            const SizedBox(height: 16),
            _buildConsumptionProjection(),
            const SizedBox(height: 12),
            _buildMetricRow(),
            const SizedBox(height: 16),
            _buildMonthlyChart(),
            const SizedBox(height: 20),
            _buildOptimizationSection(),
          ],
        ),
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: _bottomNavIndex,
        activeStyle: BottomNavActiveStyle.filled,
        onTap: (index) => handleMainNavigation(context, index, _bottomNavIndex),
      ),
    );
  }

  Widget _buildReportButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: AppColors.trackingAccentGreen,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Reporte Ejecutivo',
                  style: TextStyle(
                    fontSize: 13,
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

  Widget _buildCriticalAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.riskRedLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.riskRed.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.riskRed.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.riskRed, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alerta de Desabastecimiento Crítico',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.riskRed,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'El inventario de combustible se estima agotado el 24 Oct 2023. Se recomienda reposición inmediata. Burn Rate actual: 14.2% diario.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.riskRedSubtle.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionProjection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proyección de Consumo de Flota',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 14,
                      backgroundColor: const Color(0xFFE5E7EB),
                      color: AppColors.trackingAccentGreen,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '75%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.trackingDarkGreen,
                        ),
                      ),
                      Text(
                        'RESERVA ACTUAL',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: AppColors.chipInactiveText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Ritmo de consumo óptimo',
              style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.trackingDeliveredBtnBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '-2.4% vs semana anterior',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.trackingDarkGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow() {
    return Row(
      children: [
        Expanded(
          child: _SmallMetricCard(
            icon: Icons.payments_outlined,
            tag: 'Costo Promedio',
            value: 'Costo Operativo Promedio',
            highlight: '\$1.42 USD',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SmallMetricCard(
            icon: Icons.savings_outlined,
            tag: 'Este Mes',
            value: 'Ahorro Mensual',
            highlight: '+\$12,450 USD',
            highlightColor: AppColors.trackingAccentGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Análisis de Consumo Corporativo Mensual',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: AppColors.chipInactiveText.withValues(alpha: 0.8)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: _MonthlyLineChartPainter(),
              size: const Size(double.infinity, 140),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Ene', style: TextStyle(fontSize: 11, color: AppColors.chipInactiveText)),
              Text('Feb', style: TextStyle(fontSize: 11, color: AppColors.chipInactiveText)),
              Text('Mar', style: TextStyle(fontSize: 11, color: AppColors.chipInactiveText)),
              Text('Abr', style: TextStyle(fontSize: 11, color: AppColors.chipInactiveText)),
              Text('May', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.trackingDarkGreen)),
              Text('Jun', style: TextStyle(fontSize: 11, color: AppColors.chipInactiveText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Optimización de Operaciones',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        _OptimizationCard(
          icon: Icons.local_shipping_outlined,
          text: 'Ruta de Mayor Rendimiento: Corredor Norte (L2)',
        ),
        const SizedBox(height: 10),
        _OptimizationCard(
          icon: Icons.schedule,
          text: 'Ventana Óptima de Suministro: 22:00 - 04:00 AM',
        ),
        const SizedBox(height: 10),
        _OptimizationCard(
          icon: Icons.speed,
          text: 'Eficiencia de Combustible (Flota): 24.5 L / 100 km',
        ),
      ],
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  final IconData icon;
  final String tag;
  final String value;
  final String highlight;
  final Color? highlightColor;

  const _SmallMetricCard({
    required this.icon,
    required this.tag,
    required this.value,
    required this.highlight,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.trackingAccentGreen),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.trackingDeliveredBtnBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 11, color: AppColors.chipInactiveText),
          ),
          const SizedBox(height: 4),
          Text(
            highlight,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: highlightColor ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptimizationCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OptimizationCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.trackingDeliveredBtnBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.trackingDarkGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(size.width * 0.05, size.height * 0.72),
      Offset(size.width * 0.22, size.height * 0.58),
      Offset(size.width * 0.38, size.height * 0.65),
      Offset(size.width * 0.55, size.height * 0.42),
      Offset(size.width * 0.72, size.height * 0.28),
      Offset(size.width * 0.88, size.height * 0.38),
    ];

    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.trackingAccentGreen.withValues(alpha: 0.25),
          AppColors.trackingAccentGreen.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = AppColors.trackingAccentGreen
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = AppColors.trackingAccentGreen;
    for (var i = 0; i < points.length; i++) {
      final radius = i == 4 ? 5.0 : 3.5;
      canvas.drawCircle(points[i], radius, dotPaint);
      if (i == 4) {
        final ringPaint = Paint()
          ..color = AppColors.trackingAccentGreen.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(points[i], 9, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
