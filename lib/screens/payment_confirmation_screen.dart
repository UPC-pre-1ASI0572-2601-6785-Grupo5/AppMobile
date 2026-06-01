import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import 'subscription_success_screen.dart';
import 'payment_error_screen.dart'; // Importante para la navegación de error

class PaymentConfirmationScreen extends StatefulWidget {
  final String planName;
  final String planDescription;
  final double planPrice;

  const PaymentConfirmationScreen({
    Key? key,
    required this.planName,
    required this.planDescription,
    required this.planPrice,
  }) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  // CONTROLADOR AÑADIDO: Para leer el número de tarjeta sin cambiar el diseño
  final _cardNumberController = TextEditingController();

  bool _saveCard = true;
  bool _isLoading = false;
  int _selectedPaymentMethod = 0;

  // LÓGICA ACTUALIZADA: Ahora decide si ir a Éxito o Error
  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // REGLA: Si el número tiene '0000', mandamos a la pantalla de error
      final bool esTarjetaBloqueada = _cardNumberController.text.contains('0000');

      setState(() => _isLoading = false);

      if (esTarjetaBloqueada) {
        // Navegación a ERROR
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentErrorScreen()),
        );
      } else {
        // Navegación a ÉXITO
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionSuccessScreen(
              planName: widget.planName,
              planPrice: widget.planPrice,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar el pago. Intente de nuevo.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose(); // Limpieza del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = widget.planPrice;
    final double tax = subtotal * 0.15;
    final double total = subtotal + tax;

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumen del Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: widget.planName == 'Pro' ? AppColors.primary : AppColors.borderLight,
                    width: 1.5
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.planName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 4),
                                  Text(widget.planDescription, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.planName == 'Pro')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('POPULAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF856404))),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('\$${widget.planPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 4, left: 2),
                                      child: Text('/mes', style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                            Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Impuestos (15%)', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                            Text('\$${tax.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total a pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTrustBadge(Icons.shield_outlined, 'SSL SECURED'),
                _buildTrustBadge(Icons.lock_outline, 'JWT PROTECTED'),
                _buildTrustBadge(Icons.verified_outlined, 'COMPLIANCE'),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Método de Pago',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildPaymentToggle(
                    icon: Icons.credit_card,
                    label: 'Tarjeta',
                    isSelected: _selectedPaymentMethod == 0,
                    onTap: () => setState(() => _selectedPaymentMethod = 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentToggle(
                    icon: Icons.account_balance_outlined,
                    label: 'Corporativo',
                    isSelected: _selectedPaymentMethod == 1,
                    onTap: () => setState(() => _selectedPaymentMethod = 1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Titular de la tarjeta', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Constructora Horizonte S.A.C.'),
                    validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Número de tarjeta', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cardNumberController, // ASIGNADO AQUÍ
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '4532 1847 9921 6408',
                      suffixIcon: Icon(Icons.credit_card, color: AppColors.textGrey),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vencimiento', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            const SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(hintText: '08 / 29'),
                              validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CVV', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            const SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: '***',
                                suffixIcon: Icon(Icons.help_outline, color: AppColors.textGrey, size: 18),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _saveCard,
                          onChanged: (value) => setState(() => _saveCard = value ?? false),
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            'Guardar esta tarjeta para futuros pagos corporativos.',
                            style: TextStyle(fontSize: 12, color: AppColors.textDark),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handlePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Confirmar Pago de \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Al confirmar, aceptas nuestros Términos de Servicio. FuelManager procesa tus datos bajo estándares PCI-DSS Nivel 1 para máxima seguridad.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: AppColors.textGrey, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.borderLight)),
          child: Icon(icon, color: AppColors.textGrey, size: 20),
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildPaymentToggle({required IconData icon, required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.textGrey),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}