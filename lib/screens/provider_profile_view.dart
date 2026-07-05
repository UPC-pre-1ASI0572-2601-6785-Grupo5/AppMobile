import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login_screen.dart';
import '../services/session_manager.dart';
import '../services/profile_service.dart';
import '../models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = SessionManager.instance.user;
    if (user != null) {
      try {
        final updatedUser = await _profileService.fetchUserProfile(user.id);
        setState(() {
          _mfaEnabled = updatedUser.mfaEnabled;
          _profileImagePath = updatedUser.profilePicture;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = SessionManager.instance.user;
      if (user != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Img = 'data:image/png;base64,' + base64Encode(bytes);
        try {
          await _profileService.updateProfile(user.id, {'profilePicture': base64Img});
          setState(() {
            _profileImagePath = base64Img;
          });
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto actualizada')));
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF006D3E)));
    }

    final user = SessionManager.instance.user;
    final companyName = user?.companyName ?? user?.name ?? 'Empresa Proveedora';
    final userEmail = user?.email ?? 'admin@fueltrack-corp.com';
    final rfc = user?.taxId ?? 'FSI990101TX4';
    final address = user?.address ?? 'Av. Logística 450, Ciudad Industrial';
    
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
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF006D3E), shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.white,
                          backgroundImage: _profileImagePath != null
                              ? (_profileImagePath!.startsWith('data:image')
                                  ? MemoryImage(base64Decode(_profileImagePath!.split(',')[1]))
                                  : NetworkImage(_profileImagePath!))
                              : NetworkImage('https://api.dicebear.com/7.x/bottts/png?seed=$userEmail') as ImageProvider,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFF006D3E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.edit, color: Colors.white, size: 14),
                      ),
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
                _buildInfoField('RFC / Identificación Fiscal', rfc),
                const SizedBox(height: 16),
                _buildInfoField('Correo Corporativo', userEmail),
                const SizedBox(height: 16),
                _buildInfoField('Ubicación Central', address),
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
                  decoration: BoxDecoration(color: _mfaEnabled ? const Color(0xFFE8F8F5) : const Color(0xFFFDE8E8), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: _mfaEnabled ? const Color(0xFF006D3E) : AppColors.error, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_mfaEnabled ? 'MFA Activado' : 'MFA Desactivado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _mfaEnabled ? const Color(0xFF006D3E) : AppColors.error)),
                            const SizedBox(height: 2),
                            Text(_mfaEnabled ? 'Tu cuenta está protegida por Autenticación de Dos Factores.' : 'Habilita 2FA para mayor seguridad.', style: TextStyle(fontSize: 11, color: _mfaEnabled ? const Color(0xFF006D3E) : AppColors.error)),
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
          // CENTRO DE SOPORTE (Contáctanos)
          // ==========================================
          _buildSectionCard(
            title: 'Contáctanos',
            icon: Icons.support_agent,
            child: Column(
              children: [
                _buildSupportTile(Icons.email_outlined, 'Correo Electrónico', 'soporte@fueltrack.com.pe', false),
                const SizedBox(height: 8),
                _buildSupportTile(Icons.phone_outlined, 'Línea de Atención', '+51 987 654 321', false),
                const SizedBox(height: 8),
                _buildSupportTile(Icons.menu_book_outlined, 'Documentación Técnica', 'Guías de uso de la API', true, onTap: _showTechDocsDialog),
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
    final rfcController = TextEditingController(text: SessionManager.instance.user?.taxId ?? '');
    final addressController = TextEditingController(text: SessionManager.instance.user?.address ?? '');
    
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
              const SizedBox(height: 16),
              TextField(
                controller: rfcController,
                decoration: const InputDecoration(labelText: 'RFC / Identificación Fiscal'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Dirección Central'),
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
              onPressed: () async {
                final address = addressController.text.trim().toLowerCase();
                if (address.isNotEmpty) {
                  if (address.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La dirección debe tener al menos 10 caracteres')));
                    return;
                  }
                  if (!address.contains('av') && !address.contains('calle') && !address.contains('jr') && !address.contains('mz') && !address.contains('lote') && !address.contains('km')) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, ingresa una dirección válida (ej. Av., Calle, Jr., Mz., Lote)')));
                    return;
                  }
                }

                final user = SessionManager.instance.user;
                if (user != null) {
                  try {
                    // Se actualiza en el backend
                    await _profileService.updateProfile(user.id, {
                      'companyName': nameController.text,
                      'email': emailController.text,
                      'taxId': rfcController.text,
                      'address': addressController.text,
                    });
                    setState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Información actualizada exitosamente')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña Actual')),
            const SizedBox(height: 12),
            TextField(controller: newController, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva Contraseña')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E)),
            onPressed: () async {
              final user = SessionManager.instance.user;
              if (user != null) {
                try {
                  await _profileService.changePassword(user.id, currentController.text, newController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada exitosamente')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                }
              }
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
            onPressed: () async {
              final user = SessionManager.instance.user;
              if (user != null) {
                try {
                  await _profileService.toggleMfa(user.id, !_mfaEnabled);
                  setState(() => _mfaEnabled = !_mfaEnabled);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                }
              }
            },
            child: Text(_mfaEnabled ? 'Desactivar' : 'Activar', style: const TextStyle(color: Colors.white))
          ),
        ],
      )
    );
  }



  void _showTechDocsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Documentación Técnica de la API'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Arquitectura de Integración', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
              SizedBox(height: 8),
              Text('FuelTrack expone una API RESTful alojada en Render (https://fueltrack-backend-api.onrender.com).'),
              SizedBox(height: 12),
              Text('1. Autenticación (JWT)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Todos los endpoints seguros requieren un token JWT enviado en el header de la solicitud HTTP: Authorization: Bearer <tu_token_jwt>. Los tokens expiran en 24h.'),
              SizedBox(height: 12),
              Text('2. Endpoints Principales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('• GET /api/v1/orders - Lista de pedidos activos.\n• PATCH /api/v1/orders/{id}/dispatch - Iniciar despacho de un pedido.\n• PATCH /api/v1/orders/{id}/deliver - Marcar como entregado con firma digital.'),
              SizedBox(height: 12),
              Text('3. Monitoreo IoT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Los datos de telemetría (temperatura, ubicación, velocidad) se envían vía WebSockets al backend de FuelTrack para reflejarse en tiempo real en la plataforma.'),
            ],
          ),
        ),
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

}
