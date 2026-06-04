import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'resource_tracking_detail_screen.dart'; // Navegación al detalle gráfico de la crisis
import 'alert_configuration_screen.dart';     // Navegación a la configuración del hardware/umbrales

class IotCriticalAlertsScreen extends StatelessWidget {
  const IotCriticalAlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal del módulo
          Row(
            children: const [
              Icon(Icons.local_shipping, color: Color(0xFF006D3E), size: 20),
              SizedBox(width: 8),
              Text(
                'Alertas Críticas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ==========================================
          // MÉTRICAS DE ALERTAS
          // ==========================================
          Row(
            children: [
              Expanded(child: _buildMetricTab('Críticas', '02', AppColors.error)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricTab('Avisos', '01', const Color(0xFFF39C12))),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricTab('Info', '01', const Color(0xFF2ECC71))),
            ],
          ),
          const SizedBox(height: 32),

          // ==========================================
          // FEED DE ALERTAS
          // ==========================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('FEED DE ALERTAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('EN VIVO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // TARJETA 1: CRÍTICO (Caída de Presión en Tanque TK-402)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFEBEE), width: 2),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera con indicación de severidad temporal
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.error, size: 14),
                          SizedBox(width: 6),
                          Text('CRÍTICO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 0.5)),
                        ],
                      ),
                      Text('Hace 2 min', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Caída de Presión en Tanque TK-402', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.directions_car, size: 12, color: AppColors.textGrey),
                            SizedBox(width: 6),
                            Text('Asset: FT-9921', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Presión descendió de 45 PSI a 12 PSI en 15 segundos. Posible fuga estructural detectada.',
                        style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.flash_on, color: Colors.white, size: 16),
                          label: const Text('Protocolo de Emergencia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Redirección hacia el detalle con gráfica de CustomPaint
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ResourceTrackingDetailScreen()),
                                );
                              },
                              icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF006D3E)),
                              label: const Text('Ver detalles', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold, fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.borderLight),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(8)),
                            child: IconButton(
                              icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
                              onPressed: () {
                                // Redirección hacia los switches de control de sensores
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AlertConfigurationScreen()),
                                );
                              },
                              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // TARJETA 2: SEGURIDAD (Smart Lock Abierto)
          _buildStandardAlertCard(
            tag: 'SEGURIDAD',
            tagColor: AppColors.error,
            time: 'Hace 15 min',
            icon: Icons.lock_open,
            title: 'Posible Robo - Smart Lock Abierto',
            description: 'El sello electrónico del camión FLT-208 fue vulnerado fuera de zona de descarga autorizada.',
            bottomWidget: Row(
              children: const [
                Icon(Icons.location_on_outlined, size: 12, color: AppColors.textGrey),
                SizedBox(width: 4),
                Text('KM 142 - Autopista Norte', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // TARJETA 3: ADVERTENCIA (Entrada Geocerca restringida)
          _buildStandardAlertCard(
            tag: 'ADVERTENCIA',
            tagColor: const Color(0xFFF39C12),
            time: 'Hace 42 min',
            icon: Icons.warning_amber_rounded,
            title: 'Entrada a Geocerca No Autorizada',
            description: 'Unidad FLT-115 ingresó a zona restringida \'Refinería Sur\'.',
            trailingIcon: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFFEF5E7), shape: BoxShape.circle),
              child: const Icon(Icons.map_outlined, color: Color(0xFFF39C12), size: 20),
            ),
          ),
          const SizedBox(height: 16),

          // TARJETA 4: INFORMATIVO (Entrega de combustible exitosa)
          _buildStandardAlertCard(
            tag: 'INFORMATIVO',
            tagColor: const Color(0xFF2ECC71),
            time: '11:05 AM',
            icon: Icons.info_outline,
            title: 'Entrega Confirmada #ORD-8821',
            description: 'Descarga exitosa de 5,000L Diesel en Estación Central.',
          ),
          const SizedBox(height: 32),

          // ==========================================
          // TIMELINE DE EVENTOS GENERALES
          // ==========================================
          const Text('TIMELINE DE EVENTOS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
            child: Column(
              children: [
                _buildTimelineItem(
                  title: 'Sensor Temp OK',
                  description: 'Estabilización térmica en TK-402 alcanzada (22°C).',
                  time: '10:55',
                  dotColor: const Color(0xFF2ECC71),
                  isLast: false,
                ),
                _buildTimelineItem(
                  title: 'Fallo Comunicación PLC',
                  description: 'Pérdida de señal en módulo RF-Gateway 09.',
                  time: '10:42',
                  dotColor: AppColors.error,
                  isLast: false,
                ),
                _buildTimelineItem(
                  title: 'Login Operador',
                  description: 'Acceso autorizado: Ing. Carlos Ruiz.',
                  time: '10:30',
                  dotColor: const Color(0xFF2C3E50),
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ==========================================
          // ESTADO DE RED DE SENSORES
          // ==========================================
          const Text('ESTADO DE RED DE SENSORES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('DISPONIBILIDAD', style: TextStyle(fontSize: 9, color: Colors.white70, letterSpacing: 0.5)),
                              Text('98.2%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: 0.98, backgroundColor: Colors.white12, color: const Color(0xFF2ECC71), minHeight: 4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('LATENCIA', style: TextStyle(fontSize: 9, color: Colors.white70, letterSpacing: 0.5)),
                              Text('42ms', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: 0.4, backgroundColor: Colors.white12, color: const Color(0xFF2ECC71), minHeight: 4),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                      ],
                    ),
                    const Text('144 Activos | 1 Crítico', style: TextStyle(fontSize: 10, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMetricTab(String title, String count, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accentColor)),
          const SizedBox(height: 8),
          Container(height: 3, width: 24, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }

  Widget _buildStandardAlertCard({
    required String tag,
    required Color tagColor,
    required String time,
    required IconData icon,
    required String title,
    required String description,
    Widget? bottomWidget,
    Widget? trailingIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(bottom: BorderSide(color: tagColor.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: tagColor, size: 14),
                    const SizedBox(width: 6),
                    Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor, letterSpacing: 0.5)),
                  ],
                ),
                Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
                      if (bottomWidget != null) ...[
                        const SizedBox(height: 12),
                        bottomWidget,
                      ],
                    ],
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 16),
                  trailingIcon,
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required Color dotColor,
    required bool isLast,
  }) {
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
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle, border: Border.all(color: dotColor.withOpacity(0.3), width: 3)),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, margin: const EdgeInsets.only(top: 4), color: AppColors.borderLight),
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
                        Text(description, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}