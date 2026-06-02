import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const _bottomNavIndex = 4;
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
            _buildUserCard(),
            const SizedBox(height: 20),
            _buildSectionTitle('Gestión de Cuenta'),
            const SizedBox(height: 10),
            _buildPlanCard(),
            const SizedBox(height: 10),
            _buildMenuTile(
              icon: Icons.receipt_long_outlined,
              title: 'Facturación y Recibos',
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _buildMenuTile(
              icon: Icons.credit_card_outlined,
              title: 'Métodos de Pago',
              subtitle: 'VISA **** 4242',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildSectionHeader(
              title: 'Configuración de Sedes',
              actionLabel: 'Añadir Nueva',
              onAction: () {},
            ),
            const SizedBox(height: 10),
            _buildSiteCard(
              name: 'Sede Norte - Principal',
              address: 'Parque Industrial, Nave 4',
            ),
            const SizedBox(height: 8),
            _buildSiteCard(
              name: 'Sede Sur - Distribución',
              address: 'Puerto Logístico A-12',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Seguridad y Privacidad'),
            const SizedBox(height: 10),
            _buildSecurityCard(
              title: 'Contraseña',
              subtitle: 'Último cambio: hace 3 meses',
              actionLabel: 'Cambiar ahora',
              actionColor: AppColors.trackingDarkGreen,
              onAction: () {},
            ),
            const SizedBox(height: 8),
            _buildSecurityCard(
              title: 'MFA (2FA)',
              subtitle: 'Autenticación por SMS y App',
              actionLabel: 'Configurar',
              actionColor: AppColors.trackingDarkGreen,
              badge: 'ACTIVADO',
              onAction: () {},
            ),
            const SizedBox(height: 8),
            _buildSecurityCard(
              title: 'Sesiones',
              subtitle: '3 dispositivos activos',
              actionLabel: 'Cerrar otras sesiones',
              actionColor: AppColors.riskRed,
              onAction: () {},
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Centro de Soporte'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SupportButton(
                    label: 'Chat de Ayuda',
                    backgroundColor: AppColors.trackingDarkGreen,
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SupportButton(
                    label: 'Abrir Ticket',
                    backgroundColor: AppColors.trackingDeliveredBtnBg,
                    textColor: AppColors.trackingDarkGreen,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.menu_book_outlined,
              title: 'Documentación Técnica',
              subtitle: 'Guías de uso y configuración de API',
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              icon: Icons.confirmation_number_outlined,
              title: 'Tickets Abiertos (2)',
              subtitle: 'Revisión de sensor #882 y Facturación Oct',
              showExternalLink: true,
            ),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
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

  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://i.pravatar.cc/200?img=12',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 72,
                height: 72,
                color: AppColors.placeholderBg,
                child: const Icon(Icons.person, size: 36, color: AppColors.textGrey),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Carlos Rodriguez',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Administrador de Sede • Sede Norte',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.chipInactiveText.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.trackingDeliveredBtnBg,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, size: 18, color: AppColors.trackingDarkGreen),
                      SizedBox(width: 8),
                      Text(
                        'Editar Perfil',
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Row(
      children: [
        Expanded(child: _buildSectionTitle(title)),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.trackingDarkGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
                children: [
                  TextSpan(text: 'PLAN ACTUAL: '),
                  TextSpan(
                    text: 'Enterprise Pro',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
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
              'ACTIVO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.trackingDarkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.trackingDarkGreen),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.chipInactiveText.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.chipInactiveText.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSiteCard({required String name, required String address}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.trackingDeliveredBtnBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_outlined, color: AppColors.trackingDarkGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.chipInactiveText.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.settings_outlined, size: 20, color: AppColors.chipInactiveText.withValues(alpha: 0.7)),
        ],
      ),
    );
  }

  Widget _buildSecurityCard({
    required String title,
    required String subtitle,
    required String actionLabel,
    required Color actionColor,
    String? badge,
    required VoidCallback onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.trackingDeliveredBtnBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.trackingDarkGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.chipInactiveText.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: actionColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showExternalLink = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.trackingDarkGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.chipInactiveText.withValues(alpha: 0.9),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (showExternalLink)
            Icon(Icons.open_in_new, size: 18, color: AppColors.chipInactiveText.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.riskRedLight,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 20, color: AppColors.riskRed),
                SizedBox(width: 8),
                Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.riskRed,
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

class _SupportButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _SupportButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
