import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/fueltrack_app_bar.dart';
import 'dashboard_screen.dart';
import 'tracking_screen.dart';

class OrderConfirmationErrorScreen extends StatelessWidget {
  final String orderCode;
  final String volume;
  final String eta;
  final String errorReason;

  const OrderConfirmationErrorScreen({
    Key? key,
    required this.orderCode,
    required this.volume,
    required this.eta,
    this.errorReason = 'Fallo en la comunicación con la terminal de carga',
  }) : super(key: key);

  static const _bgColor = Color(0xFFF8F9FA);
  static const _errorPink = Color(0xFFFDEDEC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: const FuelTrackAppBar(backgroundColor: _bgColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _buildErrorGraphic(),
            const SizedBox(height: 24),
            const Text(
              '¡Error al Procesar el Pedido!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Lo sentimos, ha ocurrido un problema inesperado. Por favor, revisa la información de abajo o intenta nuevamente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.chipInactiveText,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            _buildErrorReasonCard(),
            const SizedBox(height: 16),
            _buildOrderCard(),
            const SizedBox(height: 24),
            _buildSecondaryButton(
              context,
              label: 'Ver Seguimiento',
              icon: Icons.map_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackingScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildPrimaryButton(context),
            const SizedBox(height: 24),
            _buildInfoBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorGraphic() {
    return SizedBox(
      height: 160,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.riskRedLight.withValues(alpha: 0.5),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 48, color: Colors.white),
          ),
          Positioned(
            top: 36,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_gas_station, size: 18, color: Colors.white.withValues(alpha: 0.7)),
                Container(
                  width: 24,
                  height: 2,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                Icon(Icons.local_shipping, size: 18, color: Colors.white.withValues(alpha: 0.7)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorReasonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _errorPink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MOTIVO DEL ERROR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  errorReason,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
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

  Widget _buildOrderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CÓDIGO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.chipInactiveText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            orderCode,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.trackingAccentGreen,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          Row(
            children: [
              Expanded(child: _detailColumn('VOLUMEN', volume)),
              Expanded(child: _detailColumn('ETA APROX.', eta, showClock: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailColumn(String label, String value, {bool showClock = false}) {
    return Column(
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
        const SizedBox(height: 6),
        Row(
          children: [
            if (showClock) ...[
              const Icon(Icons.schedule, size: 16, color: AppColors.textDark),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: AppColors.chipInactiveText),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.chipInactiveText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.trackingAccentGreen,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_outlined, size: 20, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Ir al Inicio',
                  style: TextStyle(
                    fontSize: 15,
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

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_none, size: 20, color: AppColors.chipInactiveText.withValues(alpha: 0.8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notificaciones activas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Te enviaremos una notificación cuando el camión cisterna esté a menos de 5km de tu ubicación.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.chipInactiveText.withValues(alpha: 0.95),
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
