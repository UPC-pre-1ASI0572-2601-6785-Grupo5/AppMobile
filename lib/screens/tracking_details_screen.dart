import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import 'dashboard_screen.dart';
import 'fullscreen_map_screen.dart'; // Importación de la nueva pantalla

class TrackingDetailsScreen extends StatefulWidget {
  const TrackingDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TrackingDetailsScreen> createState() => _TrackingDetailsScreenState();
}

class _TrackingDetailsScreenState extends State<TrackingDetailsScreen> {
  final int _selectedIndex = 2; // Seguimiento activo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles del', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.2)),
            Text('Despacho', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.2)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjeta 1: Detalles de la Unidad
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del camión
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?q=80&w=800&auto=format&fit=crop', // Imagen placeholder de camión
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('ACTIVO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Unidad Cisterna TX-402', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  SizedBox(height: 4),
                                  Text('Modelo: Scania G450\nPremium Logistics', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(38),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('ID:\n#99281-\nFL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Grid de Capacidades
                        Row(
                          children: [
                            Expanded(child: _buildInfoBox('Capacidad', '32,000 L')),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInfoBox('Carga Actual', '28,500 L')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(flex: 1, child: _buildInfoBox('Consumo', '2.4 km/L')),
                            const SizedBox(width: 12),
                            const Expanded(flex: 1, child: SizedBox()), // Espaciador
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Sensores de Telemetría
                        const Text('Sensores de Telemetría Activos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSensorPill(Icons.thermostat_outlined, 'Temp: 24°C'),
                            _buildSensorPill(Icons.compress_outlined, 'Presión: 115 PSI'),
                            _buildSensorPill(Icons.speed_outlined, 'Vel: 88 km/h'),
                            _buildSensorPill(Icons.water_drop_outlined, 'Viscosidad: OK'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjeta 2: Notificaciones Recientes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Notificaciones Recientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Icon(Icons.history, color: AppColors.textGrey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildNotificationItem(
                    icon: Icons.factory_outlined,
                    iconColor: AppColors.primary,
                    title: 'Cisterna salió de planta',
                    time: 'Hace 45 min',
                    desc: 'Despacho verificado en Terminal Norte. Rumbo a destino principal.',
                  ),
                  _buildNotificationItem(
                    icon: Icons.traffic_outlined,
                    iconColor: AppColors.error,
                    title: 'Entrando a zona de tráfico pesado',
                    time: 'Hace 12 min',
                    desc: 'Retraso estimado de 8 minutos detectado en Autopista Central.',
                  ),
                  _buildNotificationItem(
                    icon: Icons.access_time_outlined,
                    iconColor: AppColors.primary,
                    title: 'ETA actualizado a 15 min',
                    time: 'Justo ahora',
                    desc: 'La unidad se aproxima a la geocerca de destino. Personal de descarga notificado.',
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjeta 3: Geocerca y Mapa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GEOCERCA DE DESTINO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  const Text('Planta Refinería Sur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 16),

                  // Mapa Interactivo Real embebido en la tarjeta
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: const MapOptions(
                              initialCenter: LatLng(-12.085, -76.96), // Refinería
                              initialZoom: 15.0,
                              interactionOptions: InteractionOptions(
                                flags: InteractiveFlag.all & ~InteractiveFlag.rotate, // Deshabilita rotación
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                                userAgentPackageName: 'com.example.fueltrack',
                              ),
                              PolygonLayer(
                                polygons: [
                                  Polygon(
                                    points: const [
                                      LatLng(-12.082, -76.964),
                                      LatLng(-12.082, -76.956),
                                      LatLng(-12.088, -76.956),
                                      LatLng(-12.088, -76.964),
                                    ],
                                    color: AppColors.primary.withAlpha(51), // Equivalente a opacity 0.2
                                    borderColor: AppColors.primary,
                                    borderStrokeWidth: 2,
                                  ),
                                ],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: const LatLng(-12.085, -76.96),
                                    width: 120,
                                    height: 30,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                      ),
                                      child: const Center(
                                        child: Text('ZONA DE ENTREGA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Controles de zoom
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                                  child: const Icon(Icons.add, size: 16, color: AppColors.textDark),
                                ),
                                Container(height: 1, width: 24, color: AppColors.borderLight),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                                  child: const Icon(Icons.remove, size: 16, color: AppColors.textDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Distancia restante:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      Text('4.2 km', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado de Geocerca:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      Row(
                        children: const [
                          Icon(Icons.check_circle_outline, size: 14, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text('Monitoreando', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FullscreenMapScreen()),
                        );
                      },
                      icon: const Icon(Icons.fullscreen, size: 18),
                      label: const Text('Ver Mapa en Pantalla Completa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006D3E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildSensorPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String desc,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.borderLight,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                  Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                ],
              ),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(initialIndex: index)),
          (route) => false,
        );
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Pedidos'),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.local_shipping_outlined, color: Colors.white),
          ),
          label: 'Seguimiento',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Analítica'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ],
    );
  }
}