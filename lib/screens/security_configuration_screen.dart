import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SecurityConfigurationScreen extends StatelessWidget {
  const SecurityConfigurationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FuelTrack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER
            // ==========================================
            const Text('Configuración de Seguridad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text(
              'Gestiona los accesos de tu equipo, protocolos de seguridad y credenciales de acceso corporativo.',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // TARJETA 1: MFA
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.security, color: Color(0xFF006D3E), size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Autenticación de Dos\nFactores (MFA)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
                              child: const Text('Desactivado', style: TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Añade una capa extra de seguridad a tu cuenta solicitando un código de verificación además de tu contraseña.',
                    style: TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phonelink_lock, color: Colors.white, size: 16),
                      label: const Text('Activar MFA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006D3E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // TARJETA 2: CAMBIAR CONTRASEÑA
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.history, color: AppColors.textDark, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Text('Cambiar Contraseña', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Contraseña Actual', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Nueva Contraseña', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4EFDF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Actualizar Contraseña', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // TARJETA 3: GESTIÓN DE ROLES Y EQUIPO
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.people, color: Color(0xFF006D3E), size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Text('Gestión de\nRoles y Equipo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.person_add_alt_1, color: Color(0xFF006D3E), size: 14),
                          SizedBox(width: 4),
                          Text('Invitar\nUsuario', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D3E), height: 1.2)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Usuario', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Text('Rol', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildUserRoleRow('AM', 'Alejandro\nMendoza', 'a.mendoza@fuelops.com', 'Administrador', const Color(0xFFE8F8F5), const Color(0xFF2ECC71)),
                  const SizedBox(height: 12),
                  _buildUserRoleRow('LG', 'Lucía García', 'l.garcia@fuelops.com', 'Operador\nFlota', const Color(0xFFD4EFDF), const Color(0xFF006D3E)),
                  const SizedBox(height: 12),
                  _buildUserRoleRow('RT', 'Ricardo Torres', 'r.torres@fuelops.com', 'Auditor', const Color(0xFFEAECEE), AppColors.textDark),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: AppColors.borderLight, height: 1),
                  ),

                  // INFORMACIÓN SOBRE PERMISOS
                  const Text('Información sobre Permisos', style: TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildPermissionInfo('Los Administradores pueden gestionar facturación, flotas y otros usuarios.'),
                  const SizedBox(height: 8),
                  _buildPermissionInfo('Los Operadores solo tienen acceso a despachos y alertas en tiempo real.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // TARJETA 4: SESIONES ACTIVAS
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.devices, color: AppColors.error, size: 20),
                          const SizedBox(width: 12),
                          const Text('Sesiones\nActivas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                        ],
                      ),
                      const Text('Cerrar todas\nlas sesiones', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.w500, height: 1.2)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSessionRow(Icons.desktop_windows, 'Chrome en Windows', 'Ciudad de México • IP: 189.21.XX.XX', isCurrent: true),
                  const SizedBox(height: 12),
                  _buildSessionRow(Icons.smartphone, 'App FuelOps (iPhone 13)', 'Monterrey • Hace 2 horas', isCurrent: false),
                  const SizedBox(height: 12),
                  _buildSessionRow(Icons.laptop_mac, 'Safari en MacOS', 'Guadalajara • Hace 1 día', isCurrent: false),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ====== WIDGETS REUTILIZABLES ======

  Widget _buildUserRoleRow(String initials, String name, String email, String role, Color badgeBgColor, Color badgeTextColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF9FBFB), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFD4EFDF),
            child: Text(initials, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                const SizedBox(height: 2),
                Text(email, style: const TextStyle(fontSize: 9, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
            child: Text(role, textAlign: TextAlign.center, style: TextStyle(color: badgeTextColor, fontSize: 8, fontWeight: FontWeight.bold, height: 1.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionInfo(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF006D3E), size: 14),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10, color: AppColors.textGrey, height: 1.3))),
        ],
      ),
    );
  }

  Widget _buildSessionRow(IconData icon, String title, String subtitle, {required bool isCurrent}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FBFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGrey, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textGrey)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFD4EFDF), borderRadius: BorderRadius.circular(4)),
              child: const Text('ACTUAL', style: TextStyle(color: Color(0xFF006D3E), fontSize: 8, fontWeight: FontWeight.bold)),
            )
          else
            const Icon(Icons.logout, color: AppColors.error, size: 18),
        ],
      ),
    );
  }
}