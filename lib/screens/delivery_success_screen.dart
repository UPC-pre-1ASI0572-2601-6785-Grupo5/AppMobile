import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'digital_receipt_screen.dart'; // Importación vital para navegar
import 'dashboard_screen.dart';

import '../models/order_model.dart';

class DeliverySuccessScreen extends StatefulWidget {
  final OrderModel order;
  const DeliverySuccessScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<DeliverySuccessScreen> createState() => _DeliverySuccessScreenState();
}

class _DeliverySuccessScreenState extends State<DeliverySuccessScreen> {
  final int _selectedIndex = 2; // Mantenemos activo el tab de Seguimiento

  // Lista para guardar los puntos de la firma dibujada
  List<Offset?> _signaturePoints = [];

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
                  Text('#FT-${widget.order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Icono de Éxito
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8)),
                        ]
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),

                  // Textos principales
                  const Text(
                    'Entrega Exitosa',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'El suministro ha sido completado y\nverificado por el sistema de gestión de flotas\nFuelTrack.',
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
                          value: '${widget.order.quantityGallons.toStringAsFixed(0)}L',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          icon: Icons.access_time,
                          label: 'FINALIZACIÓN',
                          value: widget.order.completedAt != null ? _formatTime(widget.order.completedAt!) : '--:--',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tarjeta de Firma Digital Interactiva
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.draw_outlined, size: 18, color: AppColors.textDark),
                                SizedBox(width: 8),
                                Text('Firma Digital', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              ],
                            ),
                            // Botón de Limpiar si hay firma
                            if (_signaturePoints.isNotEmpty)
                              GestureDetector(
                                onTap: () => setState(() => _signaturePoints.clear()),
                                child: const Text('Limpiar', style: TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Ãrea de la firma INTERACTIVA
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7F7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderLight, width: 2),
                          ),
                          child: Stack(
                            children: [
                              // Detector de gestos para dibujar
                              ClipRect(
                                child: GestureDetector(
                                  onPanStart: (details) {
                                    setState(() {
                                      _signaturePoints.add(details.localPosition);
                                    });
                                  },
                                  onPanUpdate: (details) {
                                    setState(() {
                                      _signaturePoints.add(details.localPosition);
                                    });
                                  },
                                  onPanEnd: (details) {
                                    setState(() {
                                      _signaturePoints.add(null); // Separador de trazos
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent, // Asegura que capture los gestos en toda el área
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CustomPaint(
                                      painter: InteractiveSignaturePainter(_signaturePoints),
                                    ),
                                  ),
                                ),
                              ),
                              // Mensaje de ayuda si está vacío
                              if (_signaturePoints.isEmpty)
                                const Center(
                                  child: Text('Firma aquí', style: TextStyle(color: AppColors.textLight, fontSize: 16, fontStyle: FontStyle.italic)),
                                ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.borderLight),
                                  ),
                                  child: const Text('VERIFICADO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              const Text('Código Hash de Seguridad', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                              const SizedBox(height: 4),
                              Text(widget.order.securityHash ?? '#FT-HASH-PENDING', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // BOTÓN CON NAVEGACIÓN CORREGIDA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // NAVEGACIÓN A LA PANTALLA DEL VOUCHER
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DigitalReceiptScreen(
                            signaturePoints: _signaturePoints,
                            order: widget.order,
                          )),
                        );
                      },
                      icon: const Icon(Icons.description_outlined, size: 18),
                      label: const Text('Ver comprobante digital'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71), // Verde más claro del diseño
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Vuelve al Dashboard inicial
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardScreen(initialIndex: 0)),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home_outlined, size: 18, color: AppColors.textDark),
                      label: const Text('Volver al Dashboard', style: TextStyle(color: AppColors.textDark)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8F8F5), // Fondo verde muy tenue
                        elevation: 0,
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

  String _formatTime(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }
}

// CustomPainter actualizado para dibujar líneas basadas en gestos
class InteractiveSignaturePainter extends CustomPainter {
  final List<Offset?> points;

  InteractiveSignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        // Dibuja una línea entre puntos consecutivos
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant InteractiveSignaturePainter oldDelegate) {
    return true; // Siempre redibuja cuando cambian los puntos
  }
}
