import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'tracking_screen.dart';
import 'new_order_screen.dart';
import 'alerts_screen.dart'; // <-- ImportaciÃ³n agregada

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                onPressed: () {
                  // MODIFICADO: Ahora abre las notificaciones
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlertsScreen()),
                  );
                },
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
            radius: 16,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar #FT-2023...',
                  hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFilterChip(Icons.calendar_today_outlined, 'Fecha', true),
                const SizedBox(width: 8),
                _buildFilterChip(Icons.swap_vert, 'Estado', false),
                const SizedBox(width: 8),
                _buildFilterChip(Icons.tag, '# CÃ³digo', false),
              ],
            ),
            const SizedBox(height: 24),
            _buildOrderCard(
              context,
              id: '#FT-2023-45',
              product: 'DiÃ©sel Premium B5',
              status: 'En ruta',
              statusColor: const Color(0xFF006D3E),
              volume: '12,500 Litros',
              timeLabel: 'ETA Estimado',
              timeValue: 'Hoy, 14:30 PM',
              date: '24 Oct 2023',
            ),
            const SizedBox(height: 16),
            _buildOrderCard(
              context,
              id: '#FT-2023-44',
              product: 'Gasolina 95 Oct',
              status: 'Confirmado',
              statusColor: const Color(0xFF1976D2),
              volume: '8,200 Litros',
              timeLabel: 'Fecha Entrega',
              timeValue: '26 Oct 2023',
              date: '23 Oct 2023',
            ),
            const SizedBox(height: 16),
            _buildOrderCard(
              context,
              id: '#FT-2023-43',
              product: 'Combustible Jet A1',
              status: 'Pendiente',
              statusColor: const Color(0xFFE67E22),
              volume: '20,000 Litros',
              timeLabel: 'ValidaciÃ³n',
              timeValue: 'En revisiÃ³n',
              date: '22 Oct 2023',
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF006D3E), Color(0xFF11CAA0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Optimiza tu Flota', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Programa tus pedidos automÃ¡ticos y\nrecibe descuentos exclusivos por\nvolumen este mes.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Saber mÃ¡s', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Resumen Mensual', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Estado de tus Ãºltimos 30 dÃ­as', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('45k', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text('Litros\nEntregados', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.2)),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 40, color: AppColors.borderLight),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('12', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            Text('Pedidos\nExitosos', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewOrderScreen(),
              fullscreenDialog: true,
            ),
          );
        },
        backgroundColor: const Color(0xFF006D3E),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? AppColors.primary : AppColors.textGrey),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, {
        required String id,
        required String product,
        required String status,
        required Color statusColor,
        required String volume,
        required String timeLabel,
        required String timeValue,
        required String date,
      }) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.local_shipping, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(product, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.water_drop_outlined, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Volumen', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  Text(volume, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timeLabel, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  Text(timeValue, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              GestureDetector(
                onTap: () {
                  if (status == 'En ruta') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TrackingScreen()),
                    );
                  }
                },
                child: const Text('Detalles >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
