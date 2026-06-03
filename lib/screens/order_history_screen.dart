import 'package:flutter/material.dart';
import '../constants/colors.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
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
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y Descripción
            const Text('Historial de Pedidos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 4),
            const Text('Consulta y descarga registros de suministros\nfinalizados.', style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
            const SizedBox(height: 16),

            // Botón Exportar CSV
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 16, color: Colors.white),
              label: const Text('Exportar CSV', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D3E),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 20),

            // Buscador
            TextField(
              decoration: InputDecoration(
                hintText: 'FLT-2024',
                hintStyle: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),

            // Chips de Filtro
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFB2EBF2)),
                  ),
                  child: Row(
                    children: const [
                      Text('Estado: Entregado', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      SizedBox(width: 4),
                      Icon(Icons.close, size: 12, color: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7F7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: const [
                      Text('Últimos 30 días', style: TextStyle(fontSize: 11, color: AppColors.textDark)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textGrey),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tarjetas de Métricas
            _buildMetricCardWhite(icon: Icons.check_circle_outline, title: 'TOTAL ENTREGADOS', value: '1,284', trailing: '+12%', trailingColor: AppColors.primary),
            const SizedBox(height: 12),
            _buildMetricCardWhite(icon: Icons.local_gas_station_outlined, title: 'VOLUMEN TOTAL', value: '45.2k L', trailing: '', trailingColor: Colors.transparent),
            const SizedBox(height: 12),
            _buildEfficiencyCard(),
            const SizedBox(height: 24),

            // Lista de Historial
            _buildHistoryCard(id: '#FLT-2024-001', date: '24 Oct, 2023', time: '14:30 PM', fuel: 'Diesel Ultra', qty: '1,200 Litros'),
            const SizedBox(height: 12),
            _buildHistoryCard(id: '#FLT-2024-002', date: '23 Oct, 2023', time: '09:15 AM', fuel: 'Gasolina 95', qty: '850 Litros'),
            const SizedBox(height: 12),
            _buildHistoryCard(id: '#FLT-2023-899', date: '21 Oct, 2023', time: '17:45 PM', fuel: 'Biodiesel', qty: '2,500 Litros'),
            const SizedBox(height: 24),

            // Footer
            Center(child: const Text('Mostrando 10 de 1,284 resultados', style: TextStyle(fontSize: 11, color: AppColors.textGrey))),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAECEE),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text('Cargar más registros', style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCardWhite({required IconData icon, required String title, required String value, required String trailing, required Color trailingColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFE8F8F5), shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              if (trailing.isNotEmpty) Text(trailing, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: trailingColor)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildEfficiencyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF006D3E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.check_circle_outline, size: 100, color: Colors.white.withAlpha(25)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Eficiencia de Entrega', style: TextStyle(fontSize: 11, color: Colors.white70)),
              const SizedBox(height: 8),
              const Text('98.4%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.984,
                  backgroundColor: Colors.white.withAlpha(50),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({required String id, required String date, required String time, required String fuel, required String qty}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFE8F8F5), shape: BoxShape.circle),
                    child: const Icon(Icons.local_shipping, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ID:', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                      Text(id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, size: 12, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text('Entregado', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('COMBUSTIBLE', style: TextStyle(fontSize: 9, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(fuel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CANTIDAD', style: TextStyle(fontSize: 9, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(qty, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.remove_red_eye_outlined, size: 18, color: AppColors.textGrey),
              SizedBox(width: 16),
              Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.textGrey),
            ],
          ),
        ],
      ),
    );
  }
}