import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DigitalReceiptScreen extends StatelessWidget {
  const DigitalReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Comprobante Digital', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Tarjeta de Comprobante
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF006D3E), size: 64),
                  const SizedBox(height: 16),
                  const Text('Entrega Confirmada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('Pedido #FT-2023-05', style: TextStyle(color: AppColors.textGrey)),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  _buildReceiptRow('Unidad', 'VXB-402'),
                  _buildReceiptRow('Volumen', '12,000 L'),
                  _buildReceiptRow('Fecha', '02 Jun, 2026'),
                  _buildReceiptRow('Hora', '12:28 PM'),
                  _buildReceiptRow('Destino', 'Refinería Sur'),

                  const SizedBox(height: 32),

                  // Simulación de QR
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          color: AppColors.textDark, // Aquí iría tu widget de QR
                          child: const Center(child: Text('QR CODE', style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(height: 12),
                        const Text('Validación Blockchain', style: TextStyle(fontSize: 10, color: AppColors.textGrey, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text('Descargar PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGrey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }
}