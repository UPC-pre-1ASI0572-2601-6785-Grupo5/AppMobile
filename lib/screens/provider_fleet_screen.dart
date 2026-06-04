import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'iot_cistern_detail_screen.dart';

class ProviderFleetScreen extends StatelessWidget {
  const ProviderFleetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Panel de Operaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FBF6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD4EFDF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Cumplimiento', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('94.2%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF5E7), // Tono rojizo/naranja suave
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDEBD0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Alertas', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('03', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.error)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Conductores Activos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text('Total: 12', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          _buildDriverCard(
            name: 'Ricardo Méndez',
            id: 'ID: #44021',
            statusText: 'ALERTA FATIGA',
            statusColor: AppColors.error,
            statusBgColor: const Color(0xFFFFEBEE),
            borderColor: const Color(0xFFFFCDD2),
            avatarUrl: 'https://i.pravatar.cc/150?img=11',
            dotColor: AppColors.error,
            bottomContent: Row(
              children: const [
                Icon(Icons.timer_outlined, size: 14, color: AppColors.textGrey),
                SizedBox(width: 6),
                Text('9h 45m de conducción continua', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          _buildDriverCard(
            name: 'Carlos Pérez',
            id: 'ID: #44089',
            statusText: 'EN RUTA',
            statusColor: const Color(0xFF006D3E),
            statusBgColor: const Color(0xFFE8F8F5),
            borderColor: AppColors.borderLight,
            avatarUrl: 'https://i.pravatar.cc/150?img=12',
            dotColor: const Color(0xFF2ECC71),
            bottomContent: Column(
              children: [
                LinearProgressIndicator(value: 0.75, backgroundColor: AppColors.borderLight, color: const Color(0xFF006D3E), minHeight: 4),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Ruta: Corredor Norte', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                    Text('75%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                  ],
                ),
              ],
            ),
          ),
          _buildDriverCard(
            name: 'Elena Martínez',
            id: 'ID: #44112',
            statusText: 'DESCANSANDO',
            statusColor: AppColors.textDark,
            statusBgColor: const Color(0xFFEAECEE),
            borderColor: AppColors.borderLight,
            avatarUrl: 'https://i.pravatar.cc/150?img=5',
            dotColor: AppColors.textGrey,
            bottomContent: Row(
              children: const [
                Icon(Icons.bed_outlined, size: 14, color: AppColors.textGrey),
                SizedBox(width: 6),
                Text('Reanudación en: 01h 15m', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cisternas Activas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              GestureDetector(
                onTap: () {},
                child: const Text('Ver todas >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _buildCisternCard(
                  context: context,
                  title: 'MX-4501',
                  subtitle: 'KENWORTH T680 • EN RUTA',
                  fuelLevel: 0.82,
                  fuelText: '82%',
                  pressure: '32.4 PSI',
                  valveStatus: 'Cerrada',
                  lockStatus: 'Bloqueado',
                  speed: '88 km/h',
                  speedColor: AppColors.error,
                ),
                const SizedBox(width: 16),
                _buildCisternCard(
                  context: context,
                  title: 'MX-4502',
                  subtitle: 'VOLVO VNL • EN RUTA',
                  fuelLevel: 0.45,
                  fuelText: '45%',
                  pressure: '31.8 PSI',
                  valveStatus: 'Cerrada',
                  lockStatus: 'Bloqueado',
                  speed: '65 km/h',
                  speedColor: const Color(0xFF006D3E),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDriverCard({
    required String name,
    required String id,
    required String statusText,
    required Color statusColor,
    required Color statusBgColor,
    required Color borderColor,
    required String avatarUrl,
    required Color dotColor,
    required Widget bottomContent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(id, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(statusText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          bottomContent,
        ],
      ),
    );
  }

  Widget _buildCisternCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double fuelLevel,
    required String fuelText,
    required String pressure,
    required String valveStatus,
    required String lockStatus,
    required String speed,
    required Color speedColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IotCisternDetailScreen()),
        );
      },
      child: Container(
        width: 280,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Estable', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nivel de Combustible', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text(fuelText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: fuelLevel, backgroundColor: AppColors.borderLight, color: const Color(0xFF006D3E), minHeight: 4),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: AppColors.borderLight),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.compress, size: 16, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PRESIÓN', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                          Text(pressure, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.lock, size: 16, color: Color(0xFF006D3E)),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SMART LOCK', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                          Text(lockStatus, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
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
                      const Icon(Icons.swap_vert, size: 16, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('VÁLVULA', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                          Text(valveStatus, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.speed, size: 16, color: speedColor),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('VELOCIDAD', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                          Text(speed, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: speedColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}