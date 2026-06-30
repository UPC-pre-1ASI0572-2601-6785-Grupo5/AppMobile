import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login_screen.dart'; // Importamos tu pantalla de login para cerrar sesión
import '../services/session_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Igual que las demás, sin Scaffold ni AppBar propio para no duplicar
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tarjeta de Perfil Principal
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://i.pravatar.cc/150?img=11', // Foto del usuario
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Color(0xFF006D3E), shape: BoxShape.circle),
                              child: const Icon(Icons.shield, color: Colors.white, size: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Carlos Rodríguez', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          SizedBox(height: 4),
                          Text('Administrador de Sede • Sede Norte', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.2)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF006D3E)),
                    label: const Text('Editar Perfil', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4EFDF),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Gestión de Cuenta
          Row(
            children: const [
              Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Gestión de Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFB2EBF2))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('PLAN ACTUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5)),
                            SizedBox(height: 4),
                            Text('Enterprise Pro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF006D3E), borderRadius: BorderRadius.circular(20)),
                          child: const Text('ACTIVO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildListTile(Icons.receipt_long_outlined, 'Facturación y Recibos'),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildListTile(Icons.credit_card_outlined, 'Métodos de Pago', trailingText: 'VISA **** 4242'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Configuración de Sedes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.domain, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text('Configuración de Sedes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
              const Text('Añadir\nNueva', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          _buildSedeCard('Sede Norte - Principal', 'Parque Industrial, Nave 4'),
          const SizedBox(height: 8),
          _buildSedeCard('Sede Sur - Distribución', 'Puerto Logístico A-12'),
          const SizedBox(height: 24),

          // 4. Seguridad y Privacidad
          Row(
            children: const [
              Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Seguridad y Privacidad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
            child: Column(
              children: [
                _buildSecurityTile(Icons.lock_outline, 'Contraseña', 'Último cambio: hace 3 meses', 'Cambiar ahora', AppColors.primary, null),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildSecurityTile(Icons.verified_user_outlined, 'MFA (2FA)', 'Autenticación por SMS y App', 'Configurar', AppColors.primary, 'ACTIVADO'),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildSecurityTile(Icons.devices_outlined, 'Sesiones', '3 dispositivos activos', 'Cerrar otras sesiones', AppColors.error, null),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 5. Centro de Soporte
          Row(
            children: const [
              Icon(Icons.support_agent, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Centro de Soporte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
                        label: const Text('Chat de Ayuda', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4EFDF), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('Abrir Ticket', style: TextStyle(color: Color(0xFF006D3E), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSupportTile(Icons.menu_book_outlined, 'Documentación Técnica', 'Guías de uso y configuración de API', false),
                const SizedBox(height: 8),
                _buildSupportTile(Icons.confirmation_num_outlined, 'Tickets Abiertos (2)', 'Revisión de sensor #882 y Facturación Oct', true),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 6. BOTÓN DE CERRAR SESIÓN (FUNCIONAL)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // Aquí está la magia: Borramos todo el stack de rutas y lo mandamos al Login
              onPressed: () {
                SessionManager.instance.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false, // Esto destruye el historial previo
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE), // Fondo rojito
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===================== WIDGETS REUTILIZABLES =====================

  Widget _buildListTile(IconData icon, String title, {String? trailingText}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textGrey, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildSedeCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFF4F7F7), shape: BoxShape.circle),
            child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          const Icon(Icons.settings_outlined, color: AppColors.textDark, size: 20),
        ],
      ),
    );
  }

  Widget _buildSecurityTile(IconData icon, String title, String subtitle, String actionText, Color actionColor, String? badge) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF006D3E), borderRadius: BorderRadius.circular(20)),
                        child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                const SizedBox(height: 8),
                Text(actionText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: actionColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTile(IconData icon, String title, String subtitle, bool isLink) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFF4F7F7), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.textGrey, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          if (isLink) const Icon(Icons.open_in_new, color: AppColors.textGrey, size: 16),
        ],
      ),
    );
  }
}