import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'provider_dispatches_screen.dart';
import 'provider_fleet_screen.dart';
import 'iot_critical_alerts_screen.dart';
import 'provider_profile_view.dart';      // <-- IMPORTANTE: La nueva vista de Perfil de Proveedor
import 'iot_monitoring_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProviderDashboardScreen extends StatefulWidget {
  final int? initialIndex;
  const ProviderDashboardScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
    _initializeIndex();
  }

  Future<void> _initializeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (widget.initialIndex != null) {
      prefs.setInt('provider_dashboard_index', widget.initialIndex!);
    } else {
      final savedIndex = prefs.getInt('provider_dashboard_index');
      if (savedIndex != null && mounted) {
        setState(() {
          _selectedIndex = savedIndex;
        });
      }
    }
  }

  // Lista de pantallas para el proveedor con todas las pestañas conectadas
  late final List<Widget> _pages = [
    _buildProviderDashboardView(),          // Ãndice 0: Inicio Proveedor
    const ProviderDispatchesScreen(),       // Ãndice 1: Gestión de Despachos
    const ProviderFleetScreen(),            // Ãndice 2: Panel de Flota (Conductores y Cisternas)
    const IotCriticalAlertsScreen(),        // Ãndice 3: Centro de Alertas Críticas
    const ProviderProfileView(),            // Ãndice 4: Perfil Corporativo
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 32,
                  height: 32,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FuelControl Pro',
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
                onPressed: () {
                  // Navegar a la pestaña de Alertas directamente
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt('provider_dashboard_index', index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? AppColors.primary.withAlpha(26) : Colors.transparent,
                  shape: BoxShape.circle
              ),
              child: Icon(Icons.dashboard_customize, color: _selectedIndex == 0 ? AppColors.primary : AppColors.textGrey),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? Icons.local_shipping : Icons.local_shipping_outlined),
              label: 'Despachos'
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2 ? Icons.directions_car : Icons.directions_car_outlined),
              label: 'Flota'
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warning_amber_rounded,
              color: _selectedIndex == 3 ? AppColors.error : AppColors.textGrey,
            ),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 4 ? Icons.person : Icons.person_outline),
              label: 'Perfil'
          ),
        ],
      ),
    );
  }

  Widget _buildProviderDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          const Text('Hola, Administrador Flota', style: TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          const Text('Panel de Proveedor', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 20),

          // Métrica Principal: Entregas Activas
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Entregas Activas', style: TextStyle(fontSize: 14, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('42', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.trending_up, color: AppColors.primary, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Métricas Secundarias: Cisternas y Conductores
          Row(
            children: [
              Expanded(
                child: _buildSmallMetricCard(
                  title: 'Cisternas Disp.',
                  value: '18 / 25',
                  icon: Icons.local_shipping_outlined,
                  iconColor: AppColors.primary,
                  iconBgColor: const Color(0xFFE8F8F5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallMetricCard(
                  title: 'Conductores',
                  value: '156',
                  icon: Icons.people_outline,
                  iconColor: AppColors.primary,
                  iconBgColor: const Color(0xFFE8F8F5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sección: Monitoreo en Ruta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MONITOREO EN RUTA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
              GestureDetector(
                onTap: () {},
                child: const Text('Ver Mapa Completo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/trailer.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error),
                        SizedBox(width: 4),
                        Text('12 Unidades Críticas', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sección: Alertas IoT Críticas
          const Text('ALERTAS IOT CRÃTICAS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
          const SizedBox(height: 12),

          // Alerta interactiva que redirige al monitoreo IoT general
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IotMonitoringScreen()),
              );
            },
            child: _buildIotAlert(
              isCritical: true,
              icon: Icons.thermostat,
              title: 'Variación de Temperatura',
              time: 'Ahora',
              description: 'Cisterna A-12 detectó +3°C sobre el límite permitido.',
            ),
          ),

          const SizedBox(height: 12),
          _buildIotAlert(
            isCritical: false,
            icon: Icons.tire_repair,
            title: 'Baja presión neumáticos',
            time: '15 min',
            description: 'Unidad B-04 reporta presión 20 PSI en eje trasero.',
          ),
          const SizedBox(height: 24),

          // Sección: Despachos Recientes
          const Text('DESPACHOS RECIENTES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          _buildDispatchItem(
            refCode: '#REF-8902-X',
            destination: 'Destino: Planta Norte',
            driver: 'Conductor: A. Pérez',
            status: 'EN RUTA',
            isCompleted: false,
          ),
          _buildDispatchItem(
            refCode: '#REF-8891-B',
            destination: 'Destino: Centro Logístico',
            driver: 'Conductor: M. López',
            status: 'EN RUTA',
            isCompleted: false,
          ),
          _buildDispatchItem(
            refCode: '#REF-8875-A',
            destination: 'Destino: Terminal Aéreo',
            driver: 'Conductor: C. Ruiz',
            status: 'COMPLETADO',
            isCompleted: true,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSmallMetricCard({required String title, required String value, required IconData icon, required Color iconColor, required Color iconBgColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildIotAlert({required bool isCritical, required IconData icon, required String title, required String time, required String description}) {
    final Color mainColor = isCritical ? AppColors.error : const Color(0xFFE67E22);
    final Color bgColor = isCritical ? const Color(0xFFFFEBEE) : const Color(0xFFFEF5E7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCritical ? const Color(0xFFFFCDD2) : const Color(0xFFFDEBD0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: mainColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: mainColor)),
                    Text(time, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: mainColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textDark, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDispatchItem({required String refCode, required String destination, required String driver, required String status, required bool isCompleted}) {
    final Color statusBgColor = isCompleted ? AppColors.primary : const Color(0xFFE8F8F5);
    final Color statusTextColor = isCompleted ? Colors.white : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Icon(Icons.receipt_long, color: AppColors.textGrey, size: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(refCode, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(destination, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusTextColor, letterSpacing: 0.5)),
              ),
              const SizedBox(height: 6),
              Text(driver, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }
}
