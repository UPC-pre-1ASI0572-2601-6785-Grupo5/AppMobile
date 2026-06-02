import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/orders_bottom_navigation.dart';

class DispatchDetailsScreen extends StatelessWidget {
  const DispatchDetailsScreen({Key? key}) : super(key: key);

  static const _bgColor = Color(0xFFF5F7F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.trackingDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalles del Despacho',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.trackingDarkGreen,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            _buildVehicleCard(),
            const SizedBox(height: 16),
            _buildNotificationsCard(),
            const SizedBox(height: 16),
            _buildGeofenceCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: 2,
        activeStyle: BottomNavActiveStyle.filled,
        onTap: (index) => handleMainNavigation(context, index, 2),
      ),
    );
  }

  Widget _buildVehicleCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1601584114707-775aac4f3a0f?w=800&q=80',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.local_shipping, size: 64, color: AppColors.textLight),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.trackingDarkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ACTIVO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unidad Cisterna TX-402',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Modelo: Scania G450',
                      style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
                    ),
                    Text(
                      'Premium Logistics',
                      style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.trackingDeliveredBtnBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ID: #99281-FL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: _MetricBox(label: 'Capacidad', value: '32,000 L')),
              SizedBox(width: 8),
              Expanded(child: _MetricBox(label: 'Carga Actual', value: '28,500 L')),
              SizedBox(width: 8),
              Expanded(child: _MetricBox(label: 'Consumo', value: '2.4 km/L')),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Sensores de Telemetría Activos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _SensorChip(icon: Icons.thermostat_outlined, text: 'Temp: 24°C')),
              SizedBox(width: 8),
              Expanded(child: _SensorChip(icon: Icons.compress, text: 'Presión: 115 PSI')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: _SensorChip(icon: Icons.speed_outlined, text: 'Vel: 68 km/h')),
              SizedBox(width: 8),
              Expanded(child: _SensorChip(icon: Icons.water_drop_outlined, text: 'Viscosidad: OK')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notificaciones Recientes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Icon(Icons.history, size: 20, color: AppColors.chipInactiveText.withValues(alpha: 0.8)),
            ],
          ),
          const SizedBox(height: 16),
          _NotificationItem(
            icon: Icons.factory_outlined,
            iconColor: AppColors.trackingDarkGreen,
            iconBg: AppColors.trackingDeliveredBtnBg,
            title: 'Cisterna salió de planta',
            time: 'Hace 45 min',
            description: 'Despacho verificado en Terminal Norte. Rumbo a destino principal.',
          ),
          const Divider(height: 24, color: Color(0xFFE5E7EB)),
          _NotificationItem(
            icon: Icons.traffic,
            iconColor: AppColors.riskRed,
            iconBg: AppColors.riskRedLight,
            title: 'Entrando a zona de tráfico pesado',
            time: 'Hace 12 min',
            description: 'Retraso estimado de 8 minutos detectado en Autopista Central.',
          ),
          const Divider(height: 24, color: Color(0xFFE5E7EB)),
          _NotificationItem(
            icon: Icons.schedule,
            iconColor: AppColors.trackingDarkGreen,
            iconBg: AppColors.trackingDeliveredBtnBg,
            title: 'ETA actualizado a 15 min',
            time: 'Justo ahora',
            description: 'La unidad se aproxima a la geocerca de destino. Personal de descarga notificado.',
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GEOCERCA DE DESTINO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppColors.chipInactiveText,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Planta Refinería Sur',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const _GeofenceMapPlaceholder(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        'ZONA DE ENTREGA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.trackingDarkGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Column(
                      children: [
                        _ZoomButton(icon: Icons.add),
                        const SizedBox(height: 6),
                        _ZoomButton(icon: Icons.remove),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
              children: [
                TextSpan(text: 'Distancia restante: '),
                TextSpan(
                  text: '4.2 km',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Estado de Geocerca: ',
                style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
              ),
              const Icon(Icons.check_circle, size: 16, color: AppColors.trackingAccentGreen),
              const SizedBox(width: 4),
              const Text(
                'Monitoreando',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.trackingDarkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.trackingDarkGreen,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_full, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Ver Mapa en Pantalla Completa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.chipInactiveText),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.trackingDarkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SensorChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.trackingDarkGreen),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.trackingDarkGreen,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String time;
  final String description;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.time,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: AppColors.chipInactiveText),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.chipInactiveText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GeofenceMapPlaceholder extends StatelessWidget {
  const _GeofenceMapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFB74D),
            Color(0xFF81C784),
            Color(0xFF4FC3F7),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.trackingAccentGreen, width: 2.5),
            borderRadius: BorderRadius.circular(6),
            color: AppColors.trackingAccentGreen.withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;

  const _ZoomButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, size: 18, color: AppColors.textDark),
    );
  }
}
