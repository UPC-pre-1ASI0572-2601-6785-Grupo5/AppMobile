import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/fuel_order.dart';

class OrderCard extends StatelessWidget {
  final FuelOrder order;
  final VoidCallback? onDetailsTap;

  const OrderCard({
    Key? key,
    required this.order,
    this.onDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: statusStyle.label,
                backgroundColor: statusStyle.background,
                textColor: statusStyle.textColor,
                icon: statusStyle.icon,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailRow(
            icon: Icons.water_drop_outlined,
            iconColor: const Color(0xFF5DADE2),
            label: 'Volumen',
            value: order.volumeLiters,
          ),
          const SizedBox(height: 8),
          _DetailRow(
            icon: order.secondaryIcon,
            iconColor: AppColors.textLight,
            label: order.secondaryLabel,
            value: order.secondaryValue,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.borderLight),
          ),
          Row(
            children: [
              Text(
                order.dateLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDetailsTap,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Detalles',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _StatusStyle _statusStyle(OrderStatus status) {
    switch (status) {
      case OrderStatus.enRuta:
        return _StatusStyle(
          label: 'En ruta',
          background: AppColors.primary.withValues(alpha: 0.12),
          textColor: const Color(0xFF159A5C),
          icon: Icons.local_shipping_outlined,
        );
      case OrderStatus.confirmado:
        return _StatusStyle(
          label: 'Confirmado',
          background: const Color(0xFFE8F4FD),
          textColor: const Color(0xFF2980B9),
          icon: Icons.check_circle_outline,
        );
      case OrderStatus.pendiente:
        return _StatusStyle(
          label: 'Pendiente',
          background: const Color(0xFFFFF3E0),
          textColor: const Color(0xFFE67E22),
          icon: Icons.schedule,
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
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
}

class _StatusStyle {
  final String label;
  final Color background;
  final Color textColor;
  final IconData icon;

  _StatusStyle({
    required this.label,
    required this.background,
    required this.textColor,
    required this.icon,
  });
}
