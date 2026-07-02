import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login_screen.dart';
import '../services/session_manager.dart';

class ProviderProfileView extends StatefulWidget {
  const ProviderProfileView({Key? key}) : super(key: key);

  @override
  State<ProviderProfileView> createState() => _ProviderProfileViewState();
}

class _ProviderProfileViewState extends State<ProviderProfileView> {
  // Estados para notificaciones
  bool _stockAlerts = true;
  bool _monthlyReports = true;
  bool _loginAlerts = false;

  // Estados locales para simulación
  bool _mfaEnabled = true;
  final List<Map<String, String>> _tickets = [
    {'title': 'Problemas con el despacho #4092', 'status': 'Abierto'}
  ];

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
          // CABECERA DEL PERFIL
          // ==========================================
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Color(0xFF006D3E), shape: BoxShape.circle),
                      child: const CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/trailer.png'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFF006D3E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: const Icon(Icons.edit, color: Colors.white, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(companyName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text('Administrador Principal: $userEmail', style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(20)),
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
                      decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(20)),
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
          // SEGURIDAD Y PRIVACIDAD (Interactivo)
          // ==========================================
          _buildSectionCard(
            title: 'Seguridad y Privacidad',
            icon: Icons.shield_outlined,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.security, color: Color(0xFF006D3E), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_mfaEnabled ? 'MFA Activado' : 'MFA Desactivado', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                            const SizedBox(height: 2),
                            Text(_mfaEnabled ? 'Tu cuenta está protegida por Autenticación de Dos Factores.' : 'Habilita 2FA para mayor seguridad.', style: const TextStyle(fontSize: 11, color: Color(0xFF006D3E))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildActionRow('Contraseña', 'Cambiar', onTap: _showChangePasswordDialog),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                _buildActionRow('MFA (2FA)', _mfaEnabled ? 'Desactivar' : 'Configurar', onTap: _showMfaDialog, isDanger: _mfaEnabled),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ==========================================
          // CENTRO DE SOPORTE (Añadido para el proveedor)
          // ==========================================
          _buildSectionCard(
            title: 'Centro de Soporte',
            icon: Icons.support_agent,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showSupportChatDialog,
                        icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
                        label: const Text('Chat de Ayuda', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showOpenTicketDialog,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4EFDF), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('Abrir Ticket', style: TextStyle(color: Color(0xFF006D3E), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSupportTile(Icons.menu_book_outlined, 'Documentación Técnica', 'Guías de uso de la API', false, onTap: _showTechDocsDialog),
                const SizedBox(height: 8),
                _buildSupportTile(Icons.confirmation_num_outlined, 'Tickets Abiertos (${_tickets.length})', 'Tus solicitudes recientes', true, onTap: _showTicketsDialog),
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agregar rol (Simulado)')));
              },
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

  // --- DIALOGS (Simulation Methods) ---

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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Información actualizada exitosamente (Local)')));
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Contraseña Actual')),
            SizedBox(height: 12),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Nueva Contraseña')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada exitosamente (Simulado)')));
            },
            child: const Text('Actualizar', style: TextStyle(color: Colors.white))
          ),
        ],
      )
    );
  }

  void _showMfaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_mfaEnabled ? 'Desactivar 2FA' : 'Configurar 2FA'),
        content: Text(_mfaEnabled ? '¿Estás seguro de que deseas desactivar la autenticación de dos factores? Tu cuenta será menos segura.' : 'Se te enviará un código SMS a tu teléfono registrado cada vez que inicies sesión.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _mfaEnabled ? AppColors.error : const Color(0xFF006D3E)),
            onPressed: () {
              setState(() => _mfaEnabled = !_mfaEnabled);
              Navigator.pop(context);
            },
            child: Text(_mfaEnabled ? 'Desactivar' : 'Activar', style: const TextStyle(color: Colors.white))
          ),
        ],
      )
    );
  }

  void _showSupportChatDialog() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Iniciando chat de soporte para Proveedor...')));
  }

  void _showOpenTicketDialog() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abrir Ticket'),
        content: TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Asunto del problema'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E)),
            onPressed: () {
              setState(() {
                _tickets.insert(0, {'title': titleCtrl.text.isEmpty ? 'Ticket sin asunto' : titleCtrl.text, 'status': 'Abierto'});
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket creado exitosamente')));
            },
            child: const Text('Enviar', style: TextStyle(color: Colors.white))
          ),
        ],
      )
    );
  }

  void _showTicketsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tickets Abiertos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 16),
              if (_tickets.isEmpty) const Text('No hay tickets abiertos.')
              else ..._tickets.map((t) => ListTile(
                leading: const Icon(Icons.confirmation_num, color: AppColors.primary),
                title: Text(t['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Estado: ${t['status']}'),
              )).toList(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }
    );
  }

  void _showTechDocsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Documentación Técnica'),
        content: const Text('Aquí se mostraría la documentación completa (Manuales, Integración API para Proveedores, etc).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      )
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

  Widget _buildActionRow(String label, String actionText, {VoidCallback? onTap, bool isDanger = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
            Text(actionText, style: TextStyle(fontSize: 13, color: isDanger ? AppColors.error : const Color(0xFF006D3E), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
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

  Widget _buildSupportTile(IconData icon, String title, String subtitle, bool isLink, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
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
