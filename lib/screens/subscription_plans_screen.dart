import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import 'payment_confirmation_screen.dart';
import '../services/session_manager.dart';
import 'dashboard_screen.dart';
import 'provider_dashboard_screen.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({Key? key}) : super(key: key);

  void _navigateToPayment(BuildContext context, String name, double price, String desc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(
          planName: name,
          planPrice: price,
          planDescription: desc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              final user = SessionManager.instance.user;
              final isProvider = user != null && user.isProvider;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => isProvider ? const ProviderDashboardScreen() : const DashboardScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Planes de Suscripción',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Optimice el consumo de combustible de su flota con nuestras soluciones escalables. Elija el plan que mejor se adapte a sus necesidades empresariales.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            _buildPlanCard(
              context,
              title: 'Básico',
              priceValue: 29.0,
              description: 'Ideal para operaciones iniciales',
              period: '/mes',
              features: [
                'Gestión de 1 Sede',
                'Historial limitado (30 días)',
                'Soporte Básico vía Email',
              ],
              buttonText: 'Comenzar',
              buttonColor: const Color(0xFFE0EAE5),
              buttonTextColor: AppColors.textGrey,
            ),

            const SizedBox(height: 24),

            _buildPlanCard(
              context,
              title: 'Pro',
              priceValue: 59.0,
              description: 'Gestión avanzada de flota',
              period: '/mes',
              isPopular: true,
              features: [
                'Hasta 5 Sedes corporativas',
                'Reportes Descargables (PDF/Excel)',
                'Soporte Prioritario 24/7',
                'Alertas de consumo en tiempo real',
              ],
              buttonText: 'Elegir Pro',
              buttonColor: AppColors.primary,
              buttonTextColor: Colors.white,
            ),

            const SizedBox(height: 24),

            _buildPlanCard(
              context,
              title: 'Empresarial',
              priceValue: 99.0,
              description: 'Solución corporativa integral',
              period: '/mes',
              features: [
                'Sedes ilimitadas',
                'Integración API / ERP',
                'Soporte dedicado & Consultoría',
                'Paneles de control personalizados',
              ],
              buttonText: 'Contáctanos',
              buttonColor: const Color(0xFF4A6559),
              buttonTextColor: Colors.white,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      BuildContext context, {
        required String title,
        required double priceValue,
        required String description,
        required String period,
        required List<String> features,
        required String buttonText,
        required Color buttonColor,
        required Color buttonTextColor,
        bool isPopular = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPopular ? Border.all(color: AppColors.primary, width: 2) : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: const Text(
                'POPULAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${priceValue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        period,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToPayment(context, title, priceValue, description),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
}