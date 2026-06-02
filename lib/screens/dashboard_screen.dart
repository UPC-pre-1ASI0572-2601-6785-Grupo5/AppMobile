import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'tracking_screen.dart'; // Importación de la nueva pantalla

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

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
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Avatar de prueba
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alerta Crítica
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(12),
                border: const Border(left: BorderSide(color: AppColors.error, width: 4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alerta Crítica', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Riesgo de desabastecimiento en Sede Norte', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tarjetas de Métricas (Grid 2x2)
            Row(
              children: [
                Expanded(child: _buildMetricCard(title: 'Activos', value: '8', subtitle: 'Pedidos', subtitleColor: AppColors.primary, icon: Icons.autorenew)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard(title: 'Mensual', value: '125k', subtitle: 'Litros', subtitleColor: AppColors.textGrey, icon: Icons.calendar_today_outlined)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [Icon(Icons.local_fire_department_outlined, size: 14, color: AppColors.textGrey), SizedBox(width: 4), Text('Burn Rate', style: TextStyle(fontSize: 12, color: AppColors.textGrey))]),
                        const SizedBox(height: 8),
                        const Text('78%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: 0.78, backgroundColor: AppColors.borderLight, color: AppColors.primary, minHeight: 4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [Icon(Icons.ev_station_outlined, size: 14, color: AppColors.textGrey), SizedBox(width: 4), Text('Abastecimiento', style: TextStyle(fontSize: 12, color: AppColors.textGrey))]),
                        const SizedBox(height: 8),
                        const Text('Riesgo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.error)),
                        const SizedBox(height: 4),
                        const Text('Revisión requerida', style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gráfico de Tendencia
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tendencia de Consumo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Icon(Icons.trending_up, color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar('Lun', 40, AppColors.primary.withOpacity(0.3)),
                      _buildChartBar('Mar', 60, AppColors.primary.withOpacity(0.4)),
                      _buildChartBar('Mie', 30, AppColors.primary.withOpacity(0.5)),
                      _buildChartBar('Jue', 70, AppColors.primary.withOpacity(0.7)),
                      _buildChartBar('Vie', 100, AppColors.primary),
                      _buildChartBar('Sab', 80, AppColors.primary.withOpacity(0.6)),
                      _buildChartBar('Dom', 50, AppColors.primary.withOpacity(0.3)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buscador
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar pedido por código...',
                hintStyle: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),

            // Chips de Filtro
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', true),
                  _buildFilterChip('En ruta', false),
                  _buildFilterChip('Pendientes', false),
                  _buildFilterChip('Completados', false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de Pedidos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Pedidos Recientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text('Ver todos', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            _buildOrderItem('#FT-2023-01', '5000 Litros', '12 Oct', 'ETA: 15 min', 'En ruta', AppColors.primary),
            _buildOrderItem('#FT-2023-04', '12000 Litros', '11 Oct', null, 'Confirmado', const Color(0xFF85C1E9)),
            _buildOrderItem('#FT-2022-98', '8500 Litros', '10 Oct', null, 'Entregado', AppColors.textGrey),

            const SizedBox(height: 80), // Espacio para el FAB y Bottom Nav
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // Lógica de navegación actualizada
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrackingScreen()),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
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
              decoration: BoxDecoration(color: _selectedIndex == 0 ? AppColors.primary.withOpacity(0.1) : Colors.transparent, shape: BoxShape.circle),
              child: Icon(Icons.dashboard_customize, color: _selectedIndex == 0 ? AppColors.primary : AppColors.textGrey),
            ),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Pedidos'),
          const BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Seguimiento'),
          const BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Analítica'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String subtitle, required Color subtitleColor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 14, color: AppColors.textGrey), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGrey))]),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double height, Color color) {
    return Column(
      children: [
        Container(width: 32, height: height, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
      ),
      child: Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : AppColors.textDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildOrderItem(String id, String amount, String date, String? eta, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              const SizedBox(height: 4),
              Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  if (eta != null) ...[
                    const SizedBox(width: 12),
                    const Icon(Icons.timer_outlined, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(eta, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(fontSize: 12, color: statusColor == AppColors.textGrey ? AppColors.textDark : statusColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}