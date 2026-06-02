import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/digital_signature_panel.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';

class DigitalReceiptScreen extends StatelessWidget {
  const DigitalReceiptScreen({Key? key}) : super(key: key);

  static const _bottomNavIndex = 2;
  static const _orderCode = '#FT-2023-05';
  static const _volume = '12,000 L';
  static const _dateTime = '24 May 2024 • 11:32 PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const FuelTrackAppBar(backgroundColor: Color(0xFFF8F9FA)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildVoucherCard(),
            const SizedBox(height: 16),
            const DigitalSignaturePanel(),
            const SizedBox(height: 20),
            _buildPrimaryButton(
              label: 'Descargar PDF',
              icon: Icons.download_outlined,
              backgroundColor: AppColors.trackingDarkGreen,
              textColor: Colors.white,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildPrimaryButton(
              label: 'Ver Comprobante',
              icon: Icons.visibility_outlined,
              backgroundColor: AppColors.trackingDeliveredBtnBg,
              textColor: AppColors.trackingDarkGreen,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildSecurityBanner(),
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

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.description_outlined, size: 22, color: AppColors.trackingDarkGreen.withValues(alpha: 0.85)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Entrega Confirmada',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.trackingDarkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _dateTime,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.chipInactiveText.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://images.unsplash.com/photo-1601584115197-04ec0407c070?w=80&q=80',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 44,
              height: 44,
              color: AppColors.placeholderBg,
              child: const Icon(Icons.local_shipping, color: AppColors.textGrey, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.trackingDarkGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Voucher Digital $_orderCode',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.trackingDeliveredBtnBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Certificado PDF',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                top: BorderSide(color: AppColors.trackingDarkGreen, width: 4),
                left: BorderSide(color: Color(0xFFE5E7EB)),
                right: BorderSide(color: Color(0xFFE5E7EB)),
                bottom: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'VOLUMEN ENTREGADO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.chipInactiveText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            _volume,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.trackingDarkGreen,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.trackingDeliveredBtnBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_gas_station, color: AppColors.trackingDarkGreen, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Producto', 'Diesel Ultra-B10'),
                const SizedBox(height: 12),
                _buildDetailRow('Unidad', 'Tractor FH-500'),
                const SizedBox(height: 12),
                _buildDetailRow('Operador', 'Carlos Mendoza'),
                const SizedBox(height: 12),
                _buildDetailRow('Ubicación', 'Planta Norte, GDL'),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Icon(
                      Icons.qr_code_2,
                      size: 48,
                      color: AppColors.chipInactiveText.withValues(alpha: 0.5),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.chipInactiveText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
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

  Widget _buildSecurityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.trackingDeliveredBtnBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.trackingAccentGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, size: 20, color: AppColors.trackingDarkGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Respaldo Seguro',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Este documento tiene validez legal y ha sido encriptado para su seguridad.',
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
