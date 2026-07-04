import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login_screen.dart';
import '../services/session_manager.dart';
import '../services/profile_service.dart';
import '../models/user_model.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- Local State for simulation ---
  String _currentPlan = 'Enterprise Pro';
  bool _mfaEnabled = true;
  List<Map<String, dynamic>> _sedes = [];
  final List<Map<String, String>> _tickets = [
    {'title': 'Revisión de sensor #882 y Facturación Oct', 'status': 'Abierto'}
  ];

  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;

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
        final sites = await _profileService.getSites(user.id);
        setState(() {
          _mfaEnabled = updatedUser.mfaEnabled;
          _currentPlan = updatedUser.subscriptionPlan ?? 'Starter';
          _sedes = sites;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    final user = SessionManager.instance.user;
    final userName = user?.name ?? 'Usuario';
    final userRole = user?.isProvider == true ? 'Proveedor' : 'Cliente';
    final userEmail = user?.email ?? '';
    
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
                          child: Image.asset(
                            'assets/images/logo.png',
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
                        children: [
                          Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text('$userRole • $userEmail', style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.2)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditProfileDialog(context, userName, userEmail),
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
                InkWell(
                  onTap: _showPlanSelectionDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFB2EBF2))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PLAN ACTUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text(_currentPlan, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFF006D3E), borderRadius: BorderRadius.circular(20)),
                                child: const Text('CAMBIAR', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildListTile(Icons.receipt_long_outlined, 'Facturación y Recibos', onTap: _showBillingDialog),
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
              InkWell(
                onTap: _showAddSedeDialog,
                child: const Text('Añadir\nNueva', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
              )
            ],
          ),
          const SizedBox(height: 12),
          ..._sedes.asMap().entries.map((entry) {
            int index = entry.key;
            var sede = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildSedeCard(sede['name']!, sede['address']!, index),
            );
          }).toList(),
          const SizedBox(height: 16),

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
                _buildSecurityTile(Icons.lock_outline, 'Contraseña', 'Protege el acceso a tu cuenta', 'Cambiar ahora', AppColors.primary, null, onTap: _showChangePasswordDialog),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildSecurityTile(Icons.verified_user_outlined, 'MFA (2FA)', 'Autenticación en dos pasos', _mfaEnabled ? 'Desactivar' : 'Configurar', _mfaEnabled ? AppColors.error : AppColors.primary, _mfaEnabled ? 'ACTIVADO' : 'INACTIVO', onTap: _showMfaDialog),
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
                        onPressed: _showSupportChatDialog,
                        icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
                        label: const Text('Chat de Ayuda', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showOpenTicketDialog,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4EFDF), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('Abrir Ticket', style: TextStyle(color: Color(0xFF006D3E), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSupportTile(Icons.menu_book_outlined, 'Documentación Técnica', 'Guías de uso y configuración', false, onTap: _showTechDocsDialog),
                const SizedBox(height: 8),
                _buildSupportTile(Icons.confirmation_num_outlined, 'Tickets Abiertos (${_tickets.length})', 'Visualiza tus solicitudes recientes', true, onTap: _showTicketsDialog),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 6. BOTÓN DE CERRAR SESIÓN
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                SessionManager.instance.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
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

  // --- DIALOGS (Simulation Methods) ---

  void _showEditProfileDialog(BuildContext context, String currentName, String currentEmail) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    final companyController = TextEditingController(text: SessionManager.instance.user?.companyName ?? '');
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Editar Perfil', style: TextStyle(color: AppColors.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Razón Social'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                final user = SessionManager.instance.user;
                if (user != null) {
                  try {
                    await _profileService.updateProfile(user.id, {
                      'companyName': companyController.text,
                    });
                    setState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showPlanSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Plan'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Basic', 'Pro', 'Enterprise Pro'].map((plan) {
                  return RadioListTile<String>(
                    title: Text(plan),
                    value: plan,
                    groupValue: _currentPlan,
                    onChanged: (val) async {
                      if (val != null) {
                        final user = SessionManager.instance.user;
                        if (user != null) {
                          try {
                            await _profileService.changeSubscriptionPlan(user.id, val);
                            setState(() => _currentPlan = val);
                            setDialogState(() => _currentPlan = val);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan actualizado')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        }
                      }
                    },
                  );
                }).toList(),
              );
            }
          ),
        );
      }
    );
  }

  void _showBillingDialog() {
    String price = _currentPlan == 'Enterprise Pro' ? '299.00' : (_currentPlan == 'Pro' ? '199.00' : '99.00');
    
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
              const Text('Facturación y Recibos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.receipt, color: AppColors.textGrey),
                title: Text('Plan $_currentPlan - Mes Actual', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Pagado • \$$price USD'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.receipt, color: AppColors.textGrey),
                title: Text('Plan $_currentPlan - Mes Pasado', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Pagado • \$$price USD'),
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }
    );
  }

  void _showAddSedeDialog() {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Sede'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de Sede')),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Dirección')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final user = SessionManager.instance.user;
              if (user != null) {
                try {
                  await _profileService.addSite(user.id, nameCtrl.text, addressCtrl.text);
                  await _loadProfileData(); // Reload sites
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Añadir')
          ),
        ],
      )
    );
  }

  void _showEditSedeDialog(int index) {
    final nameCtrl = TextEditingController(text: _sedes[index]['name']);
    final addressCtrl = TextEditingController(text: _sedes[index]['address']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Sede'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de Sede')),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Dirección')),
          ],
        ),
        actions: [
          TextButton(onPressed: () async {
            try {
              if (_sedes[index]['id'] != null) {
                await _profileService.deleteSite(_sedes[index]['id']);
                await _loadProfileData();
              }
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }, child: const Text('Eliminar', style: TextStyle(color: AppColors.error))),
          ElevatedButton(
            onPressed: () {
              // Edit isn't implemented in API in this demo, just close
              Navigator.pop(context);
            },
            child: const Text('Cerrar')
          ),
        ],
      )
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña Actual')),
            const SizedBox(height: 12),
            TextField(controller: newCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva Contraseña')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final user = SessionManager.instance.user;
              if (user != null) {
                try {
                  await _profileService.changePassword(user.id, currentCtrl.text, newCtrl.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Actualizar')
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
            style: ElevatedButton.styleFrom(backgroundColor: _mfaEnabled ? AppColors.error : AppColors.primary),
            onPressed: () async {
              final user = SessionManager.instance.user;
              if (user != null) {
                try {
                  await _profileService.toggleMfa(user.id, !_mfaEnabled);
                  setState(() => _mfaEnabled = !_mfaEnabled);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(_mfaEnabled ? 'Desactivar' : 'Activar')
          ),
        ],
      )
    );
  }

  void _showSupportChatDialog() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Iniciando chat de soporte (Simulado)...')));
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
            onPressed: () {
              setState(() {
                _tickets.insert(0, {'title': titleCtrl.text.isEmpty ? 'Ticket sin asunto' : titleCtrl.text, 'status': 'Abierto'});
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket creado exitosamente')));
            },
            child: const Text('Enviar')
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Guía de Integración API REST', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Endpoints disponibles, autenticación JWT, y esquemas de datos.\n', style: TextStyle(fontSize: 12)),
            Text('• SLA y Tiempos de Respuesta', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Acuerdos de nivel de servicio para despachos y resolución de incidencias.\n', style: TextStyle(fontSize: 12)),
            Text('• Manual de Sensores IoT', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Configuración y sincronización de sensores volumétricos con la aplicación.', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      )
    );
  }

  // ===================== WIDGETS REUTILIZABLES =====================

  Widget _buildListTile(IconData icon, String title, {String? trailingText, VoidCallback? onTap}) {
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
      onTap: onTap,
    );
  }

  Widget _buildSedeCard(String title, String subtitle, int index) {
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
          InkWell(
            onTap: () => _showEditSedeDialog(index),
            child: const Icon(Icons.settings_outlined, color: AppColors.textDark, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTile(IconData icon, String title, String subtitle, String actionText, Color actionColor, String? badge, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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