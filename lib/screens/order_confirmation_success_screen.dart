import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/fueltrack_app_bar.dart';
import 'dashboard_screen.dart';
import 'tracking_screen.dart';

class OrderConfirmationSuccessScreen extends StatelessWidget {
  final String orderCode;
  final String volume;
  final String eta;

  const OrderConfirmationSuccessScreen({
    Key? key,
    required this.orderCode,
    required this.volume,
    required this.eta,
  }) : super(key: key);

  static const _bgColor = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: const FuelTrackAppBar(backgroundColor: _bgColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _buildSuccessGraphic(),
            const SizedBox(height: 24),
            const Text(
              '¡Pedido Realizado con Éxito!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tu solicitud ha sido procesada correctamente y se encuentra en fase de logística.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.chipInactiveText,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            _buildOrderCard(),
            const SizedBox(height: 24),
            _buildPrimaryButton(
              context,
              label: 'Ver Seguimiento',
              icon: Icons.local_shipping_outlined,
              backgroundColor: AppColors.trackingAccentGreen,
              textColor: Colors.white,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackingScreen()),
                  (route) => route.isFirst,
                );
              },
            ),
            const SizedBox(height: 12),
            _buildPrimaryButton(
              context,
              label: 'Ir al Inicio',
              icon: Icons.home_outlined,
              backgroundColor: AppColors.trackingDeliveredBtnBg,
              textColor: AppColors.trackingDarkGreen,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildInfoBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessGraphic() {
    return SizedBox(
      height: 160,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.trackingAccentGreen.withValues(alpha: 0.25),
                width: 8,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.trackingAccentGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 52, color: Colors.white),
          ),
          Positioned(
            top: 8,
            right: 12,
            child: _floatingBadge(Icons.local_shipping_outlined),
          ),
          Positioned(
            bottom: 12,
            left: 8,
            child: _floatingBadge(Icons.local_gas_station),
          ),
        ],
      ),
    );
  }

  Widget _floatingBadge(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
          ),
        ],
      ),
      child: Icon(icon, size: 18, color: AppColors.trackingDarkGreen),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _detailColumn('CÓDIGO', orderCode, valueColor: AppColors.trackingAccentGreen),
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

  Widget _detailColumn(String label, String value, {Color? valueColor, bool showClock = false}) {
    return Column(
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
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showClock) ...[
              const Icon(Icons.schedule, size: 16, color: AppColors.textDark),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: textColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
        color: AppColors.trackingCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: AppColors.chipInactiveText.withValues(alpha: 0.8)),
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
