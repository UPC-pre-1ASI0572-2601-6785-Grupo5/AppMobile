import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import 'dashboard_screen.dart'; // IMPORTACIÓN DEL DASHBOARD

class SubscriptionSuccessScreen extends StatelessWidget {
  final String planName;
  final double planPrice;

  const SubscriptionSuccessScreen({
    Key? key,
    required this.planName,
    required this.planPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculamos una fecha simulada para el próximo pago (30 días después)
    final nextPaymentDate = DateTime.now().add(const Duration(days: 30));
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final formattedDate = '${nextPaymentDate.day} ${months[nextPaymentDate.month - 1]}, ${nextPaymentDate.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F4),
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
              AppStrings.appName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textDark),
            onPressed: () {
              // Navegar al dashboard limpiando el stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '¿Necesitas ayuda con la configuración?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.help_outline, color: AppColors.primary, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Consultar Guía de Inicio Rápido',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Ilustración central con badge de éxito
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/success_illustration.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.dashboard_customize,
                            color: AppColors.primary,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                '¡Suscripción Exitosa!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tu cuenta corporativa ha sido activada correctamente. Ahora tienes acceso total a las herramientas avanzadas de gestión de combustible.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.5),
              ),

              const SizedBox(height: 32),

              // Tarjetas de detalles
              _buildDetailCard(
                label: 'PLAN ACTIVO',
                icon: Icons.star_border,
                value: '$planName Business',
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                label: 'FACTURACIÓN',
                icon: Icons.calendar_today_outlined,
                value: 'Mensual (\$${planPrice.toStringAsFixed(0)}/mes)',
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                label: 'PRÓXIMO PAGO',
                icon: Icons.event_available_outlined,
                value: formattedDate,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  // NAVEGACIÓN AL DASHBOARD
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.space_dashboard_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Ir al Dashboard', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  // Acción para ver factura
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textDark,
                  side: const BorderSide(color: AppColors.borderLight),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.textGrey),
                    SizedBox(width: 8),
                    Text('Ver Factura', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String label, required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}