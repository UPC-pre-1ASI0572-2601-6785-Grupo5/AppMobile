import 'package:flutter/material.dart';
import '../constants/colors.dart';

class IotCisternDetailScreen extends StatelessWidget {
  const IotCisternDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 16),
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
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // CONTROLES MAESTROS
                  // ==========================================
                  const Text('CONTROLES MAESTROS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMasterControl(
                          title: 'Smart Lock',
                          subtitle: 'DESBLOQUEADO',
                          icon: Icons.lock_open,
                          bgColor: const Color(0xFF006D3E),
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMasterControl(
                          title: 'Válvula',
                          subtitle: 'CERRADA',
                          icon: Icons.plumbing,
                          bgColor: const Color(0xFFFFEBEE),
                          textColor: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ==========================================
                  // OPERADOR ASIGNADO
                  // ==========================================
                  const Text('OPERADOR ASIGNADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage('assets/images/logo.png'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Carlos Mendoza', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                                      const SizedBox(width: 4),
                                      const Text('En Servicio • 6h 24m', style: TextStyle(fontSize: 11, color: Color(0xFF2ECC71), fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.phone, color: Color(0xFF006D3E), size: 18),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: AppColors.borderLight),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: const [
                                Text('LICENCIA', style: TextStyle(fontSize: 9, color: AppColors.textGrey)),
                                SizedBox(height: 4),
                                Text('TIPO A-II', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              ],
                            ),
                            Container(width: 1, height: 24, color: AppColors.borderLight),
                            Column(
                              children: const [
                                Text('CALIFICACIÓN', style: TextStyle(fontSize: 9, color: AppColors.textGrey)),
                                SizedBox(height: 4),
                                Text('4.9/5.0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==========================================
                  // MAPA (GEOCERCA)
                  // ==========================================
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        // Imagen de mapa en tonos grises/plata
                        image: AssetImage('assets/images/trailer.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.security, color: Color(0xFF006D3E), size: 12),
                                SizedBox(width: 4),
                                Text('Geocerca: Terminal Norte', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Color(0xFF006D3E), shape: BoxShape.circle),
                            child: const Icon(Icons.fullscreen, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // TELEMETRÃA IOT (SECCIÓN OSCURA)
            // ==========================================
            Container(
              width: double.infinity,
              color: const Color(0xFF22282A), // Fondo oscuro
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera oscura
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Telemetría IoT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Real-Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Actualizado hace: 2 segundos', style: TextStyle(fontSize: 10, color: Colors.white70)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFF004D2A), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('5G\nONLINE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71), height: 1.1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tarjeta 1: Nivel Ultrasónico
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF2D3335), borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        const Text('NIVEL ULTRASÓNICO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1)),
                        const SizedBox(height: 20),
                        // Dibujo del Tanque
                        Container(
                          width: 80,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 85, // Altura dinámica (simulando 72%)
                            decoration: const BoxDecoration(
                              color: Color(0xFF2ECC71),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('24,500', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4, left: 4),
                              child: Text('Lts.', style: TextStyle(fontSize: 12, color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Capacidad: 34,000L', style: TextStyle(fontSize: 10, color: Colors.white54)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tarjeta 2: Presión Interna
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF2D3335), borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        const Text('PRESIÓN INTERNA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1)),
                        const SizedBox(height: 24),
                        // Medidor Circular
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: 0.75, // 1.8 de 2.4 max aprox
                                strokeWidth: 8,
                                backgroundColor: Colors.white12,
                                color: const Color(0xFF2ECC71),
                              ),
                            ),
                            Column(
                              children: const [
                                Text('1.8', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('BAR', style: TextStyle(fontSize: 10, color: Colors.white54)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('MIN 0.5', style: TextStyle(fontSize: 9, color: Colors.white54)),
                            Text('MAX 2.4', style: TextStyle(fontSize: 9, color: Colors.white54)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tarjeta 3: Temperatura
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF2D3335), borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        const Text('TEMPERATURA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1)),
                        const SizedBox(height: 12),
                        const Icon(Icons.thermostat, color: Color(0xFF2ECC71), size: 28),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('22.4', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6, left: 4),
                              child: Text('°C', style: TextStyle(fontSize: 14, color: Colors.white54)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 4,
                          width: 120,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF2ECC71), Colors.white12]),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Estado: Estable', style: TextStyle(fontSize: 10, color: Colors.white54)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Historial de Flujo (Barras)
                  const Text('HISTORIAL DE FLUJO (24H)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(16, (index) {
                        // Alturas aleatorias para simular el gráfico del diseño
                        final heights = [30.0, 45.0, 25.0, 50.0, 60.0, 40.0, 35.0, 20.0, 15.0, 30.0, 45.0, 10.0, 35.0, 40.0, 25.0, 15.0];
                        return Container(
                          width: 14,
                          height: heights[index],
                          decoration: BoxDecoration(
                            color: const Color(0xFF006D3E).withOpacity(0.8),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // FOOTER BLANCO
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFFF4F7F7),
              child: Column(
                children: [
                  _buildFooterInfoCard(icon: Icons.speed, title: 'VELOCIDAD PROMEDIO', value: '68 km/h'),
                  const SizedBox(height: 12),
                  _buildFooterInfoCard(icon: Icons.route, title: 'PRÓXIMO PUNTO', value: 'Terminal B - 12km'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Despachos o Flota, según donde lo integres
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), shape: BoxShape.circle),
              child: const Icon(Icons.local_shipping, color: AppColors.primary),
            ),
            label: 'Despachos',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'Flota'),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alertas'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  // WIDGETS REUTILIZABLES

  Widget _buildMasterControl({required String title, required String subtitle, required IconData icon, required Color bgColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.8), letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildFooterInfoCard({required IconData icon, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFE8F8F5), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF006D3E), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 9, color: AppColors.textGrey, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
        ],
      ),
    );
  }
}
