import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';
import 'analytics_report_screen.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

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
            _buildExportButton(context),
            const SizedBox(height: 12),
            _buildBreadcrumb(),
            const SizedBox(height: 20),
            _buildMetricCards(),
            const SizedBox(height: 16),
            _buildSyncPendingCard(),
            const SizedBox(height: 16),
            _buildSensorStatusCard(),
            const SizedBox(height: 16),
            _buildProTipCard(),
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

  Widget _buildExportButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: AppColors.trackingDarkGreen,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsReportScreen()),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.picture_as_pdf_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Exportar PDF',
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

  Widget _buildBreadcrumb() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText.withValues(alpha: 0.9)),
        children: const [
          TextSpan(text: 'Panel Principal '),
          TextSpan(text: '> ', style: TextStyle(color: AppColors.chipInactiveText)),
          TextSpan(
            text: 'Analítica',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.trackingDarkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards() {
    return Row(
      children: [
        Expanded(
          child: _MetricPlaceholderCard(
            icon: Icons.info_outline,
            label: 'Consumo Total',
            message: 'Datos insuficientes para este periodo',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricPlaceholderCard(
            icon: Icons.speed_outlined,
            label: 'Eficiencia Flota',
            message: 'Calculando métricas base...',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricPlaceholderCard(
            icon: Icons.show_chart,
            label: 'Proyección Mensual',
            message: 'Esperando historial de carga',
          ),
        ),
      ],
    );
  }

  Widget _buildSyncPendingCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.trackingDeliveredBtnBg,
                  AppColors.trackingAccentGreen.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.analytics_outlined, size: 32, color: AppColors.trackingDarkGreen),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sincronización de Sensores de Flota Pendiente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Para habilitar el dashboard de Burn Rate, es necesario sincronizar los sensores IoT de la flota. Se requieren 7 días de datos continuos para generar proyecciones confiables.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.chipInactiveText.withValues(alpha: 0.95),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: AppColors.trackingDarkGreen,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Sincronizar Datos IoT',
                              style: TextStyle(
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
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: AppColors.trackingDeliveredBtnBg,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.help_outline, color: AppColors.trackingDarkGreen, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Ver Guía de Configuración',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.trackingDarkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de Sensores',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          _SensorStatusRow(
            name: 'Sensor Principal #01',
            status: 'Transmitiendo',
            isActive: true,
            icon: Icons.sensors,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          _SensorStatusRow(
            name: 'Unidad de Flota B-12',
            status: 'Desconectado',
            isActive: false,
            icon: Icons.local_shipping_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildProTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.trackingDarkGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consejo Pro',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mientras se despliegan los sensores automáticos, solicita a los conductores registrar las cargas manualmente desde la app móvil.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
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
}

class _MetricPlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String message;

  const _MetricPlaceholderCard({
    required this.icon,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.chipInactiveText),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.chipInactiveText.withValues(alpha: 0.9),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorStatusRow extends StatelessWidget {
  final String name;
  final String status;
  final bool isActive;
  final IconData icon;

  const _SensorStatusRow({
    required this.name,
    required this.status,
    required this.isActive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.trackingDeliveredBtnBg : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? AppColors.trackingDarkGreen : AppColors.chipInactiveText,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.trackingAccentGreen : AppColors.chipInactiveText,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? AppColors.trackingAccentGreen : AppColors.chipInactiveText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          isActive ? Icons.signal_cellular_alt : Icons.signal_cellular_off,
          size: 18,
          color: isActive ? AppColors.trackingAccentGreen : AppColors.chipInactiveText,
        ),
      ],
    );
  }
}
