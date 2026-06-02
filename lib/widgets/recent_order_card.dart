import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum RecentOrderStatus { enRuta, confirmado, entregado }

class RecentOrderItem {
  final String id;
  final String volume;
  final String date;
  final RecentOrderStatus status;
  final String? eta;

  const RecentOrderItem({
    required this.id,
    required this.volume,
    required this.date,
    required this.status,
    this.eta,
  });
}

class RecentOrderCard extends StatelessWidget {
  final RecentOrderItem order;

  const RecentOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badge = _badgeStyle(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                    Text(
                      order.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.volume,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badge.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badge.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (order.status == RecentOrderStatus.entregado) ...[
                const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textLight),
                const SizedBox(width: 4),
              ],
              Text(
                order.date,
                style: const TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
              if (order.eta != null) ...[
                const Spacer(),
                const Icon(Icons.access_time, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'ETA: ${order.eta}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  _BadgeStyle _badgeStyle(RecentOrderStatus status) {
    switch (status) {
      case RecentOrderStatus.enRuta:
        return const _BadgeStyle(
          label: 'En ruta',
          background: AppColors.statusEnRutaBg,
          textColor: AppColors.statusEnRutaText,
        );
      case RecentOrderStatus.confirmado:
        return const _BadgeStyle(
          label: 'Confirmado',
          background: AppColors.statusConfirmadoBg,
          textColor: AppColors.statusConfirmadoText,
        );
      case RecentOrderStatus.entregado:
        return const _BadgeStyle(
          label: 'Entregado',
          background: AppColors.statusEntregadoBg,
          textColor: AppColors.statusEntregadoText,
        );
    }
  }
}

class _BadgeStyle {
  final String label;
  final Color background;
  final Color textColor;

  const _BadgeStyle({
    required this.label,
    required this.background,
    required this.textColor,
  });
}
