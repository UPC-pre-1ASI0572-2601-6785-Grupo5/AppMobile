import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'dashboard_screen.dart';

class OrderFailedScreen extends StatelessWidget {
  const OrderFailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9), // Fondo gris muy claro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta la flecha de regreso nativa
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            // 1. Elemento visual central (X roja con íconos flotantes)
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Círculo exterior rojo clarito
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(25), // Fondo rojo muy tenue
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Círculo interior rojo fuerte
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.error.withAlpha(50), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 48),
                  ),
                  // Ãcono flotante superior derecho (Camión)
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: const Icon(Icons.local_shipping_outlined, color: AppColors.textGrey, size: 18),
                    ),
                  ),
                  // Ãcono flotante inferior izquierdo (Edificio/Planta)
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: const Icon(Icons.domain, color: AppColors.textGrey, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Textos principales
            const Text(
              '¡Error al Procesar el Pedido!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2),
            ),
            const SizedBox(height: 12),
            const Text(
              'Lo sentimos, ha ocurrido un problema\ninesperado. Por favor, revisa la información\nde abajo o intenta nuevamente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.4),
            ),
            const SizedBox(height: 24),

            // 3. Banner de Motivo del Error
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEDEC), // Rojo muy pastel
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFADBD8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error, color: AppColors.error, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('MOTIVO DEL ERROR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 0.5)),
                        SizedBox(height: 4),
                        Text('Fallo en la comunicación con la\nterminal de carga', style: TextStyle(fontSize: 13, color: AppColors.error, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Tarjeta blanca con detalles del pedido
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  const Text('CÓDIGO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  const Text('#FT-8892', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)), // El verde oscuro de tu app
                  const SizedBox(height: 16),

                  Container(height: 1, width: 40, color: AppColors.borderLight),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text('VOLUMEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                          SizedBox(height: 4),
                          Text('5,000 L', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('ETA APROX.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.access_time, size: 14, color: AppColors.textDark),
                              SizedBox(width: 4),
                              Text('45 min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 5. Botones de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica para volver a intentar o ver seguimiento si aplica
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.map_outlined, color: AppColors.textDark, size: 18),
                label: const Text('Ver Seguimiento', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E8E8), // Gris claro
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Vuelve completamente a la pantalla de Inicio (Dashboard)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_outlined, color: Colors.white, size: 18),
                label: const Text('Ir al Inicio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71), // Verde brillante
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 6. Tarjeta gris de notificaciones
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F4), // Gris muy clarito
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: AppColors.textGrey, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Notificaciones activas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        SizedBox(height: 4),
                        Text(
                          'Te enviaremos una notificación cuando el camión cisterna esté a menos de 5km de tu ubicación.',
                          style: TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
