import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum BottomNavActiveStyle { filled, tinted }

class OrdersBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final BottomNavActiveStyle activeStyle;

  const OrdersBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.activeStyle = BottomNavActiveStyle.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.grid_view_rounded, label: 'Inicio'),
      _NavItem(icon: Icons.shopping_cart_outlined, label: 'Pedidos'),
      _NavItem(icon: Icons.local_shipping_outlined, label: 'Seguimiento'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Analítica'),
      _NavItem(icon: Icons.person_outline, label: 'Perfil'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;
              final useTinted = activeStyle == BottomNavActiveStyle.tinted;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive
                              ? (useTinted
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.primary)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isActive
                              ? (useTinted ? AppColors.primary : Colors.white)
                              : AppColors.chipInactiveText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive ? AppColors.primary : AppColors.chipInactiveText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
