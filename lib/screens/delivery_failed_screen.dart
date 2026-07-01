import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DeliveryFailedScreen extends StatefulWidget {
  const DeliveryFailedScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryFailedScreen> createState() => _DeliveryFailedScreenState();
}

class _DeliveryFailedScreenState extends State<DeliveryFailedScreen> {
  final int _selectedIndex = 2; // Seguimiento

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
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sub-encabezado del pedido
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Text('#FT-2023-05', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Icono de Fallo (Equis Roja)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                        color: AppColors.error, // Rojo de error
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8)),
                        ]
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),

                  // Textos principales
                  const Text(
                    'Entrega Fallida',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'El suministro no ha sido completado. Se\ndetectó una incidencia que impidió la\ndescarga.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 32),

                  // Tarjetas de Resumen
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          icon: Icons.local_gas_station_outlined,
                          label: 'VOLUMEN TOTAL',
                          value: '12,000L',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          icon: Icons.access_time,
                          label: 'FINALIZACIÓN',
                          value: '14:45',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tarjeta de Detalle de Incidencia
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5), // Fondo rojizo muy claro
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withAlpha(51), width: 1), // Borde rojizo sutil
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Detalle de Incidencia', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Motivo: Destinatario no disponible',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.error),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No se pudo establecer contacto con el personal autorizado en la planta. El tiempo de espera (30 min) ha expirado.',
                          style: TextStyle(fontSize: 12, color: AppColors.error, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFFFD6D6)), // Divisor rojizo
                        const SizedBox(height: 12),
                        const Text(
                          'CÓDIGO ERROR: #ERR-992-B821-X9',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botones de Acción
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.white),
                      label: const Text('Reprogramar Entrega', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006D3E), // Verde oscuro
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.support_agent_outlined, size: 18, color: AppColors.textDark),
                      label: const Text('Contactar Soporte', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (index != _selectedIndex) {
          Navigator.pop(context);
        }
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
