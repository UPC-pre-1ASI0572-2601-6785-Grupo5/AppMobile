import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import 'tracking_details_screen.dart';
import 'delivery_success_screen.dart';
import 'alerts_screen.dart'; // <-- ImportaciÃ³n agregada

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_gas_station_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('#FT-2023-05', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text('En Ruta', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('ETA', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    Text('15 min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 350,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(-12.0464, -77.0428),
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                        userAgentPackageName: 'com.example.fueltrack',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: const LatLng(-12.0464, -77.0428),
                            width: 60,
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(color: AppColors.primary.withAlpha(128), blurRadius: 10, spreadRadius: 5),
                                      ]
                                  ),
                                  child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Column(
                    children: [
                      _buildMapFloatingButton(Icons.my_location),
                      const SizedBox(height: 8),
                      _buildMapFloatingButton(Icons.layers_outlined),
                    ],
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                        ]
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: AppColors.borderLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const Text(
                            'PROGRESO DEL PEDIDO',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1),
                          ),
                          const SizedBox(height: 24),
                          _buildTimelineStep(isCompleted: true, isActive: false, icon: Icons.check, title: 'Pedido Confirmado', subtitle: '09:15 AM', isLast: false),
                          _buildTimelineStep(isCompleted: false, isActive: true, icon: Icons.location_on_outlined, title: 'En Ruta', subtitle: 'Cerca de tu ubicaciÃ³n', isLast: false),
                          _buildTimelineStep(isCompleted: false, isActive: false, icon: Icons.access_time, title: 'Llegada Estimada', subtitle: '10:30 AM (Proyectado)', isLast: false),
                          _buildTimelineStep(isCompleted: false, isActive: false, icon: Icons.inventory_2_outlined, title: 'Entregado', subtitle: 'Pendiente de firma', isLast: true),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network('https://i.pravatar.cc/150?img=12', width: 48, height: 48, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Roberto G.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: const [
                                        Icon(Icons.star, color: AppColors.primary, size: 14),
                                        SizedBox(width: 4),
                                        Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        SizedBox(width: 4),
                                        Text('(1,240 entregas)', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFEFEFEF), borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('UNIDAD', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                    Icon(Icons.local_shipping_outlined, color: AppColors.primary),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text('VXB-402', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                const SizedBox(height: 12),
                                Stack(
                                  children: [
                                    Container(height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
                                    Container(width: 200, height: 4, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Capacidad', style: TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w600)),
                                    Text('12,000L', style: TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const TrackingDetailsScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18, color: Colors.white),
                                  label: const Text('Detalles', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D3E),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.call_outlined, size: 18, color: Colors.white),
                                  label: const Text('Contactar', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D3E),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DeliverySuccessScreen()),
                                );
                              },
                              icon: const Icon(Icons.inventory_outlined, size: 18, color: AppColors.primary),
                              label: const Text('Pedido entregado', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8F8F5),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapFloatingButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Icon(icon, color: AppColors.textDark, size: 20),
    );
  }

  Widget _buildTimelineStep({
    required bool isCompleted,
    required bool isActive,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    Color iconColor;
    Color bgColor;

    if (isCompleted) {
      iconColor = Colors.white;
      bgColor = const Color(0xFF006D3E);
    } else if (isActive) {
      iconColor = const Color(0xFF006D3E);
      bgColor = const Color(0xFF006D3E).withAlpha(51);
    } else {
      iconColor = AppColors.textGrey;
      bgColor = AppColors.borderLight;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: const Color(0xFF006D3E).withAlpha(128), width: 4) : null,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? const Color(0xFF006D3E) : AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive || isCompleted ? AppColors.textDark : AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? AppColors.primary : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
