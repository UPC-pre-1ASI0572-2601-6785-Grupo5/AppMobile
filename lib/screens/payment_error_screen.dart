import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import 'payment_confirmation_screen.dart';

class PaymentErrorScreen extends StatelessWidget {
  const PaymentErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/images/logo.png', width: 32, height: 32, fit: BoxFit.cover)),
            const SizedBox(width: 8),
            const Text(AppStrings.appName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                ),
                const SizedBox(height: 24),
                const Text('Transacción Fallida', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 8),
                const Text('No pudimos procesar tu suscripción al Plan Pro.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey)),
                const SizedBox(height: 24),
                _buildErrorCard(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.refresh), SizedBox(width: 8), Text('Reintentar Pago')]),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Contactar Soporte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFA), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Posibles causas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          _ErrorItem(Icons.account_balance_wallet, 'Fondos insuficientes', 'Verifica el saldo disponible en tu cuenta.'),
          _ErrorItem(Icons.credit_card_off, 'Tarjeta bloqueada', 'Revisa la fecha de vencimiento o contacta a tu banco.'),
          _ErrorItem(Icons.wifi_off, 'Problemas de conexión', 'Hubo una interrupción técnica durante la validación.'),
        ],
      ),
    );
  }
}

class _ErrorItem extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const _ErrorItem(this.icon, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [Icon(icon, color: AppColors.error, size: 18), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey))]))]),
  );
}