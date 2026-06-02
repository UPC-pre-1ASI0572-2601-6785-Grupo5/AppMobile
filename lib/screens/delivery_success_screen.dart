import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/digital_signature_panel.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';
import 'digital_receipt_screen.dart';
import 'tracking_screen.dart';

class DeliverySuccessScreen extends StatelessWidget {
  const DeliverySuccessScreen({Key? key}) : super(key: key);

  static const _bottomNavIndex = 2;
  static const _orderCode = '#FT-2023-05';
  static const _volume = '12,000L';
  static const _finishTime = '14:45';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: const FuelTrackAppBar(backgroundColor: AppColors.surfaceWhite),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 28),
            _buildSuccessIcon(),
            const SizedBox(height: 20),
            const Text(
              'Entrega Exitosa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.trackingDarkGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'El suministro ha sido completado y verificado por el sistema de gestión de flotas FuelTrack.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.chipInactiveText.withValues(alpha: 0.95),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            _buildSummaryCards(),
            const SizedBox(height: 20),
            const DigitalSignaturePanel(),
            const SizedBox(height: 24),
            _buildPrimaryButton(
              context,
              label: 'Ver comprobante digital',
              icon: Icons.description_outlined,
              backgroundColor: AppColors.trackingAccentGreen,
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DigitalReceiptScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildPrimaryButton(
              context,
              label: 'Volver',
              icon: Icons.home_outlined,
              backgroundColor: AppColors.trackingDeliveredBtnBg,
              textColor: AppColors.trackingDarkGreen,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackingScreen()),
                  (route) => route.isFirst,
                );
              },
            ),
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

  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.description_outlined, size: 20, color: AppColors.trackingDarkGreen.withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        const Text(
          _orderCode,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.trackingDarkGreen,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.trackingAccentGreen,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 48, color: Colors.white),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.local_gas_station, 'VOLUMEN TOTAL', _volume)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.schedule, 'FINALIZACIÓN', _finishTime)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.trackingAccentGreen),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: AppColors.chipInactiveText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
}
