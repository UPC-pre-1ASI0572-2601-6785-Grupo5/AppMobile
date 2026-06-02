import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';
import '../widgets/tracking_map_placeholder.dart';
import '../widgets/tracking_timeline.dart';
import 'dispatch_details_screen.dart';
import 'delivery_success_screen.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  static const _bottomNavIndex = 2;

  static const _timelineSteps = [
    TrackingStep(
      title: 'Pedido Confirmado',
      subtitle: '09:15 AM',
      icon: Icons.check,
      state: TrackingStepState.completed,
    ),
    TrackingStep(
      title: 'En Ruta',
      subtitle: 'Cerca de tu ubicación',
      icon: Icons.location_on,
      state: TrackingStepState.active,
    ),
    TrackingStep(
      title: 'Llegada Estimada',
      subtitle: '10:30 AM (Proyectado)',
      icon: Icons.schedule,
      state: TrackingStepState.pending,
    ),
    TrackingStep(
      title: 'Entregado',
      subtitle: 'Pendiente de firma',
      icon: Icons.inventory_2_outlined,
      state: TrackingStepState.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: const FuelTrackAppBar(backgroundColor: AppColors.surfaceWhite),
      body: Column(
        children: [
          _buildOrderSummary(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                const TrackingMapPlaceholder(),
                _buildBottomSheet(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: _bottomNavIndex,
        activeStyle: BottomNavActiveStyle.filled,
        onTap: (index) => handleMainNavigation(context, index, _bottomNavIndex),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      color: AppColors.surfaceWhite,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.trackingAccentGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_gas_station, color: AppColors.trackingDarkGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '#FT-2023-05',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.trackingAccentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'En Ruta',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.trackingAccentGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ETA',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.chipInactiveText.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '15 min',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.trackingAccentGreen,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.56,
      minChildSize: 0.52,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'PROGRESO DEL PEDIDO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.chipInactiveText,
                ),
              ),
              const SizedBox(height: 20),
              const TrackingTimeline(steps: _timelineSteps),
              const SizedBox(height: 20),
              _buildDriverCard(),
              const SizedBox(height: 12),
              _buildVehicleCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Detalles',
                      Icons.visibility_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DispatchDetailsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Contactar',
                      Icons.phone_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDeliveredButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.trackingCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.placeholderBg,
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/100?img=33',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Roberto G.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.trackingAccentGreen),
                    const SizedBox(width: 4),
                    const Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.trackingDarkGreen,
                      ),
                    ),
                    Text(
                      ' (1,240 entregas)',
                      style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.trackingCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'UNIDAD',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: AppColors.chipInactiveText,
                ),
              ),
              Icon(Icons.local_shipping_outlined, size: 20, color: AppColors.trackingDarkGreen.withValues(alpha: 0.7)),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'VXB-402',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.trackingDarkGreen,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 8,
              backgroundColor: Color(0xFFE5E7EB),
              color: AppColors.trackingDarkGreen,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Capacidad',
                style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
              ),
              Text(
                '12,000L',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.trackingDarkGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.trackingDarkGreen,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
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
    );
  }

  Widget _buildDeliveredButton(BuildContext context) {
    return Material(
      color: AppColors.trackingDeliveredBtnBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DeliverySuccessScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_shipping_outlined, size: 20, color: AppColors.trackingDarkGreen),
              SizedBox(width: 8),
              Text(
                'Pedido entregado',
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
    );
  }
}
