import 'package:flutter/material.dart';
import '../constants/colors.dart';

class IotMonitoringScreen extends StatelessWidget {
  const IotMonitoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9), // Fondo claro
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 16),
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
            radius: 14,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // BADGE DE ESTADO PRINCIPAL
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71), // Verde brillante del diseÃ±o
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.local_shipping_outlined, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'ESTADO: EN RUTA (UNIDAD 042)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // ALERTAS CRÃTICAS ACTIVAS
            // ==========================================
            Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
                SizedBox(width: 8),
                Text(
                  'ALERTAS CRÃTICAS ACTIVAS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Alerta 1: CaÃ­da de presiÃ³n
            _buildCriticalAlertCard(
              icon: Icons.compress,
              title: 'CaÃ­da de presiÃ³n',
              subtitle: 'Tanque principal A-1',
              trailingWidget: const Text(
                '0.8 BAR',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 8),

            // Alerta 2: Apertura no autorizada
            _buildCriticalAlertCard(
              icon: Icons.lock_open,
              title: 'Apertura no autorizada',
              subtitle: 'VÃ¡lvula de descarga posterior',
              trailingWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(4)),
                child: const Text('HACE 2M', style: TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // MAPA DE UBICACIÃ“N (MODO OSCURO TECH)
            // ==========================================
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  // Imagen placeholder techy oscura con lÃ­neas verdes
                  image: AssetImage('assets/images/trailer.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Color(0xFF006D3E), BlendMode.hue),
                ),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Stack(
                children: [
                  // Capa oscura para mejor contraste
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  // Controles de Zoom (+ / -)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: AppColors.textDark, size: 18),
                            onPressed: () {},
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            padding: EdgeInsets.zero,
                          ),
                          Container(height: 1, width: 24, color: AppColors.borderLight),
                          IconButton(
                            icon: const Icon(Icons.remove, color: AppColors.textDark, size: 18),
                            onPressed: () {},
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // PÃ­ldora inferior de ubicaciÃ³n
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text('Autopista 57, KM 128 - En Ruta', style: TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                          ),
                          const Text('42 KM/H', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // GRID DE SENSORES IOT
            // ==========================================
            Row(
              children: [
                Expanded(child: _buildSensorMetricCard('PRESIÃ“N', Icons.speed, '2.4', ' BAR', 0.6, const Color(0xFF2ECC71))),
                const SizedBox(width: 12),
                Expanded(child: _buildSensorMetricCard('NIVEL', Icons.battery_charging_full, '82', ' %', 0.82, const Color(0xFF2ECC71))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatusCard('ESTADO VÃLVULA', Icons.plumbing, 'ABIERTA', AppColors.error)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatusCard('SMART LOCK', Icons.lock_outline, 'BLOQUEADO', const Color(0xFF006D3E))),
              ],
            ),
            const SizedBox(height: 12),

            // Tarjeta Larga: Temperatura
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.thermostat, color: AppColors.textDark, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TEMPERATURA CARGA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('18.5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4, left: 4),
                              child: Text('Â°C', style: TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.trending_down, size: 14, color: Color(0xFF006D3E)),
                      SizedBox(width: 4),
                      Text('~ -0.2Â°/h', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ==========================================
            // BITÃCORA DE EVENTOS
            // ==========================================
            const Text('BITÃCORA DE EVENTOS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
            const SizedBox(height: 16),

            _buildTimelineEvent(
              isActive: true,
              isLast: false,
              title: 'Entrada Geocerca',
              subtitle: 'Zona Industrial QuerÃ©taro Nte.',
              time: '14:22',
            ),
            _buildTimelineEvent(
              isActive: false,
              isLast: false,
              title: 'En Ruta',
              subtitle: 'Carretera Federal 57D',
              time: '12:05',
            ),
            _buildTimelineEvent(
              isActive: false,
              isLast: true,
              title: 'Salida Planta',
              subtitle: 'RefinerÃ­a FuelTrack Terminal 1',
              time: '08:45',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===============================================
  // WIDGETS REUTILIZABLES INTERNOS
  // ===============================================

  Widget _buildCriticalAlertCard({required IconData icon, required String title, required String subtitle, required Widget trailingWidget}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(icon, color: AppColors.error, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.error)),
                          const SizedBox(height: 2),
                          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                    trailingWidget,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorMetricCard(String title, IconData icon, String value, String unit, double progress, Color progressColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF006D3E), size: 16),
              Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 2),
                child: Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress, backgroundColor: AppColors.borderLight, color: progressColor, minHeight: 4),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, IconData icon, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Icon(icon, color: statusColor, size: 28),
          const SizedBox(height: 8),
          Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
        ],
      ),
    );
  }

  Widget _buildTimelineEvent({required bool isActive, required bool isLast, required String title, required String subtitle, required String time}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2ECC71) : AppColors.textGrey,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 4),
                    color: AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
