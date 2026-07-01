import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'security_configuration_screen.dart'; // Importación de la vista completa de seguridad corporativa
import 'login_screen.dart';
import '../services/session_manager.dart';

class ProviderProfileView extends StatefulWidget {
  const ProviderProfileView({Key? key}) : super(key: key);

  @override
  State<ProviderProfileView> createState() => _ProviderProfileViewState();
}

class _ProviderProfileViewState extends State<ProviderProfileView> {
  // Estados para los interruptores de la sección de Notificaciones (Proveedor)
  bool _stockAlerts = true;
  bool _monthlyReports = true;
  bool _loginAlerts = false;

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.user;
    final companyName = user?.name ?? 'Empresa Proveedora';
    final userEmail = user?.email ?? 'admin@fueltrack-corp.com';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // ==========================================
          // CABECERA DEL PERFIL (Logo Corporativo y Estado)
          // ==========================================
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF006D3E), // Color corporativo verde
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/trailer.png'), // Imagen de perfil del administrador
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF006D3E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  companyName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  'Administrador Principal: $userEmail',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified, color: Color(0xFF006D3E), size: 12),
                          SizedBox(width: 4),
                          Text('Proveedor Verificado', style: TextStyle(color: Color(0xFF006D3E), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('ID: FT-88291', style: TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ==========================================
          // DATOS DE LA EMPRESA
          // ==========================================
          _buildSectionCard(
            title: 'Datos de la Empresa',
            icon: Icons.domain,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoField('Razón Social', companyName),
                const SizedBox(height: 16),
                _buildInfoField('RFC / Identificación Fiscal', 'FSI990101TX4'),
                const SizedBox(height: 16),
                _buildInfoField('Correo Corporativo', userEmail),
                const SizedBox(height: 16),
                _buildInfoField('Ubicación Central', 'Av. Logística 450, Ciudad Industrial'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showEditProfileDialog(context, companyName, userEmail),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4EFDF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Actualizar Información', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ==========================================
          // SEGURIDAD Y ACCESO (Redirige a la configuración completa del prototipo)
          // ==========================================
          _buildSectionCard(
            title: 'Seguridad y Acceso',
            icon: Icons.shield_outlined,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.security, color: Color(0xFF006D3E), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('MFA Activado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                            SizedBox(height: 2),
                            Text('Tu cuenta está protegida por Autenticación de Dos Factores.', style: TextStyle(fontSize: 11, color: Color(0xFF006D3E))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildActionRow('Contraseña', 'Cambiar'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                _buildActionRow('Sesiones activas', 'Ver todas'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityConfigurationScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Configuración de Seguridad',
                      style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ==========================================
          // GESTIÓN DE ROLES
          // ==========================================
          _buildSectionCard(
            title: 'Gestión de Roles',
            icon: Icons.people_outline,
            trailing: InkWell(
              onTap: () {},
              child: const Icon(Icons.add, color: AppColors.textDark, size: 22),
            ),
            child: Column(
              children: [
                _buildRoleItem('JP', 'Juan Pérez', 'Operador Senior', const Color(0xFFD4EFDF), const Color(0xFF006D3E)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                _buildRoleItem('MG', 'María García', 'Analista de Datos', const Color(0xFFF4F7F7), AppColors.textDark),
                const SizedBox(height: 16),
                const Text('3 usuarios adicionales con acceso limitado', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ==========================================
          // NOTIFICACIONES
          // ==========================================
          _buildSectionCard(
            title: 'Notificaciones',
            icon: Icons.tune,
            child: Column(
              children: [
                _buildNotificationToggle('Alertas de Stock Crítico', 'Notificar al caer el 15%', _stockAlerts, (val) => setState(() => _stockAlerts = val)),
                const SizedBox(height: 8),
                _buildNotificationToggle('Reportes Mensuales', 'Envío por correo electrónico', _monthlyReports, (val) => setState(() => _monthlyReports = val)),
                const SizedBox(height: 8),
                _buildNotificationToggle('Inicios de Sesión', 'Alertas de seguridad push', _loginAlerts, (val) => setState(() => _loginAlerts = val)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ==========================================
          // CERRAR SESIÓN
          // ==========================================
           SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                SessionManager.instance.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
              label: const Text('Cerrar Sesión de Proveedor', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, String currentName, String currentEmail) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Actualizar Información', style: TextStyle(color: Color(0xFF006D3E))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Razón Social'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo Corporativo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E)),
              onPressed: () {
                SessionManager.instance.user?.name = nameController.text;
                SessionManager.instance.user?.email = emailController.text;
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Información actualizada exitosamente')));
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // WIDGETS REUTILIZABLES INTERNOS

  Widget _buildSectionCard({required String title, required IconData icon, Widget? trailing, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF006D3E), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActionRow(String label, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
        Text(actionText, style: const TextStyle(fontSize: 13, color: Color(0xFF006D3E), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRoleItem(String initials, String name, String role, Color bgAvatar, Color textAvatar) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: bgAvatar,
          child: Text(initials, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textAvatar)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text(role, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
      ],
    );
  }

  Widget _buildNotificationToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF006D3E),
        ),
      ],
    );
  }
}
