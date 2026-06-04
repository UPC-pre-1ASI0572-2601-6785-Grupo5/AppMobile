import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AlertConfigurationScreen extends StatefulWidget {
  const AlertConfigurationScreen({super.key});

  @override
  State<AlertConfigurationScreen> createState() => _AlertConfigurationScreenState();
}

class _AlertConfigurationScreenState extends State<AlertConfigurationScreen> {
  // Estados para los interruptores (Switches)
  bool _fugasActivo = true;
  bool _bajoNivelActivo = true;
  bool _smartLockActivo = true;
  bool _desvioRutaActivo = false;

  // Estado para el slider de presión
  double _presionCritica = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.settings_suggest, color: Color(0xFF006D3E), size: 24),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Alertas: Tanque TK-402',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // NOTIFICACIONES PUSH (Estado general)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4EFDF)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4EFDF))),
                    child: const Icon(Icons.speaker_phone, size: 16, color: Color(0xFF2ECC71)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Notificaciones Push', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        SizedBox(height: 2),
                        Text('ID Dispositivo: #8B42-AX', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Color(0xFF006D3E), size: 14),
                      SizedBox(width: 4),
                      Text('ACTIVO', style: TextStyle(color: Color(0xFF006D3E), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // TELEMETRÍA Y ESTADO
            // ==========================================
            const Text('TELEMETRÍA Y ESTADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                children: [
                  _buildToggleRow(
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppColors.error,
                    title: 'Fugas de Combustible',
                    subtitle: 'Caída súbita de presión PSI',
                    value: _fugasActivo,
                    onChanged: (val) => setState(() => _fugasActivo = val),
                  ),
                  const Divider(color: AppColors.borderLight, height: 1),
                  _buildToggleRow(
                    icon: Icons.water_drop,
                    iconColor: const Color(0xFF006D3E),
                    title: 'Bajo Nivel IoT',
                    subtitle: 'Alerta crítica bajo 15%',
                    value: _bajoNivelActivo,
                    onChanged: (val) => setState(() => _bajoNivelActivo = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // SEGURIDAD FÍSICA
            // ==========================================
            const Text('SEGURIDAD FÍSICA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: _buildToggleRow(
                icon: Icons.lock_open,
                iconColor: AppColors.textGrey,
                title: 'Apertura Smart Lock',
                subtitle: 'Acceso no autorizado a válvulas',
                value: _smartLockActivo,
                onChanged: (val) => setState(() => _smartLockActivo = val),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // LOGÍSTICA DE RUTA
            // ==========================================
            const Text('LOGÍSTICA DE RUTA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: _buildToggleRow(
                icon: Icons.route,
                iconColor: AppColors.textGrey,
                title: 'Desvío de Ruta',
                subtitle: 'Salida de geocerca permitida',
                value: _desvioRutaActivo,
                onChanged: (val) => setState(() => _desvioRutaActivo = val),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // UMBRALES DE SEVERIDAD
            // ==========================================
            const Text('UMBRALES DE SEVERIDAD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SLIDER DE PRESIÓN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PRESIÓN CRÍTICA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${_presionCritica.toInt()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4, left: 4),
                                child: Text('PSI', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(12)),
                        child: const Text('Nivel Alerta: Medio', style: TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF006D3E),
                      inactiveTrackColor: AppColors.borderLight,
                      thumbColor: const Color(0xFF006D3E),
                      overlayColor: const Color(0xFF006D3E).withOpacity(0.1),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _presionCritica,
                      min: 10,
                      max: 100,
                      divisions: 90,
                      onChanged: (val) {
                        setState(() {
                          _presionCritica = val;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('10 PSI', style: TextStyle(fontSize: 9, color: AppColors.borderLight)),
                      Text('55 PSI', style: TextStyle(fontSize: 9, color: AppColors.borderLight)),
                      Text('100 PSI', style: TextStyle(fontSize: 9, color: AppColors.borderLight)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: AppColors.borderLight, height: 1),
                  ),

                  // INPUT DE TIEMPO
                  const Text('TIEMPO DE DESVÍO PERMITIDO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7F7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('15', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              Text('MIN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7F7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Icon(Icons.history, color: AppColors.textDark, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, size: 12, color: AppColors.textGrey),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'El sistema disparará alerta crítica tras superar este intervalo fuera de ruta.',
                          style: TextStyle(fontSize: 10, color: AppColors.textGrey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // BOTÓN GUARDAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración guardada exitosamente'), backgroundColor: Color(0xFF2ECC71)),
                  );
                },
                icon: const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                label: const Text('Guardar Configuración', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // Bottom Navigation Bar (Visual para que sea idéntico al Figma)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Pestaña de Alertas seleccionada
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Despachos'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'Flota'),
          BottomNavigationBarItem(
            // Ícono de alertas en verde porque está activo
            icon: Icon(Icons.warning_amber_rounded, color: Color(0xFF2ECC71)),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  // WIDGET REUTILIZABLE PARA LAS FILAS CON SWITCH
  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
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
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2ECC71),
          ),
        ],
      ),
    );
  }
}