import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'resource_assignment_screen.dart';
import 'provider_tracking_screen.dart';
import 'iot_cistern_detail_screen.dart'; // <-- IMPORTANTE: Agregamos la pantalla de Detalle Cisterna

class ProviderDispatchesScreen extends StatelessWidget {
  const ProviderDispatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Buscador
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por ID, Cliente o Destino...',
                hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Botón Nuevo Despacho
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text('Nuevo Despacho', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D3E),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Filtros (Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos', isActive: true),
                _buildFilterChip('Pending', isActive: false),
                _buildFilterChip('Confirmed', isActive: false),
                _buildFilterChip('In Route', isActive: false),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Tarjeta 1: Pending (Logística del Norte) - ¡AQUÍ CONECTAMOS EL DETALLE DE CISTERNA!
          _buildDispatchCard(
            id: '#DS-40922',
            status: 'Pending',
            statusBgColor: const Color(0xFFFFEBEE),
            statusTextColor: AppColors.error,
            client: 'Logística del Norte S.A.',
            details: Column(
              children: [
                _buildDetailRow(Icons.water_drop_outlined, '12,500 Lts - Diesel Premium', AppColors.textDark),
                const SizedBox(height: 4),
                _buildDetailRow(Icons.access_time, 'ETA: Hoy, 14:30 PM', AppColors.textDark),
              ],
            ),
            actions: Row(
              children: [
                Expanded(child: _buildSolidButton('Approve', const Color(0xFF006D3E), Colors.white)),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOutlinedButton(
                    'View Details',
                    onPressed: () {
                      // Navegación hacia el Detalle de Cisterna IoT
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IotCisternDetailScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. Tarjeta 2: In Route (Transportes Valdivia)
          _buildDispatchCard(
            id: '#DS-40925',
            status: 'In Route',
            statusBgColor: const Color(0xFF2ECC71),
            statusTextColor: Colors.white,
            client: 'Transportes Valdivia',
            details: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
                    Container(width: 150, height: 4, decoration: BoxDecoration(color: const Color(0xFF006D3E), borderRadius: BorderRadius.circular(2))),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.water_drop_outlined, '8,200 Lts - Regular 95', AppColors.textDark),
                const SizedBox(height: 4),
                _buildDetailRow(Icons.location_on_outlined, 'A 12km de destino', const Color(0xFF006D3E), isBold: true),
              ],
            ),
            actions: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navegación hacia la pantalla de Seguimiento Operativo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProviderTrackingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4EFDF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Live Tracking', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 6. Tarjeta 3: Confirmed (Agroindustria Central)
          _buildDispatchCard(
            id: '#DS-40928',
            status: 'Confirmed',
            statusBgColor: const Color(0xFFD4EFDF),
            statusTextColor: const Color(0xFF006D3E),
            client: 'Agroindustria Central',
            details: Column(
              children: [
                _buildDetailRow(Icons.water_drop_outlined, '25,000 Lts - Jet A1', AppColors.textDark),
                const SizedBox(height: 4),
                _buildDetailRow(Icons.calendar_today_outlined, 'Programado: Mañana 08:00 AM', AppColors.textDark),
              ],
            ),
            actions: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navegación hacia la pantalla de asignación de recursos
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResourceAssignmentScreen()),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_outlined, size: 16, color: Color(0xFF006D3E)),
                label: const Text('Assign Driver', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF006D3E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 7. Tarjeta 4: Delivered (Minera Los Pasos)
          _buildDispatchCard(
            id: '#DS-40920',
            status: 'Delivered',
            statusBgColor: const Color(0xFFEAECEE),
            statusTextColor: AppColors.textGrey,
            client: 'Minera Los Pasos',
            details: Column(
              children: [
                _buildDetailRow(Icons.water_drop_outlined, '45,000 Lts - Diesel', AppColors.textDark),
                const SizedBox(height: 4),
                _buildDetailRow(Icons.check_circle_outline, 'Completado ayer 18:45', const Color(0xFF006D3E)),
              ],
            ),
            actions: SizedBox(
              width: double.infinity,
              child: _buildSolidButton('View Proof of Delivery', const Color(0xFFEAECEE), AppColors.textGrey),
            ),
          ),
          const SizedBox(height: 16),

          // 8. Tarjeta 5: Pending con Alerta (Puerto Vallarta)
          _buildDispatchCard(
            id: '#DS-40931',
            status: 'Pending',
            statusBgColor: const Color(0xFFFFEBEE),
            statusTextColor: AppColors.error,
            client: 'Puerto Vallarta Terminal',
            details: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.water_drop_outlined, '5,000 Lts - Lubricantes', AppColors.textDark),
                const SizedBox(height: 4),
                const Text('! Urgente: Stock bajo', style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            actions: Row(
              children: [
                Expanded(child: _buildSolidButton('Approve', const Color(0xFF006D3E), Colors.white)),
                const SizedBox(width: 12),
                Expanded(child: _buildOutlinedButton('Details')),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 9. Tarjeta Resumen Verde
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF006D3E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RESUMEN DEL DÍA', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 4),
                const Text('142.5k Lts', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Despachos totales proyectados', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(26), // Transparente claro
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Activos', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            SizedBox(height: 4),
                            Text('12', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Pendientes', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            SizedBox(height: 4),
                            Text('08', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
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
    );
  }

  // ====== WIDGETS REUTILIZABLES DE ESTA PANTALLA ======

  Widget _buildFilterChip(String label, {required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2ECC71) : const Color(0xFFEAECEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : AppColors.textGrey,
        ),
      ),
    );
  }

  Widget _buildDispatchCard({
    required String id,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required String client,
    required Widget details,
    required Widget actions,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(client, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          details,
          const SizedBox(height: 16),
          actions,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color textColor, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 11, color: textColor, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildSolidButton(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  // Modificado para aceptar navegación opcional (onPressed)
  Widget _buildOutlinedButton(String text, {VoidCallback? onPressed}) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}