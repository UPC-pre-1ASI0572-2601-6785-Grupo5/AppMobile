import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'alerts_screen.dart'; // <-- Importación agregada para que funcionen las alertas

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // Esta variable controla qué diseño se muestra. true = con datos, false = sin datos.
  bool _hasData = false;

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
          // ¡AQUÃ ESTÃ EL OJITO! Botón para alternar entre vistas
          IconButton(
            icon: Icon(_hasData ? Icons.visibility : Icons.visibility_off, color: AppColors.primary),
            tooltip: 'Alternar Vista de Datos',
            onPressed: () {
              setState(() {
                _hasData = !_hasData;
              });
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () {
                  // MODIFICADO: Ahora sí abre las notificaciones al presionarlo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlertsScreen()),
                  );
                },
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
            radius: 16,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      // Muestra una vista u otra dependiendo del estado del ojito
      body: _hasData ? _buildPopulatedState() : _buildEmptyState(),
    );
  }

  // ==========================================
  // VISTA 1: CON DATOS (Gráficas y métricas)
  // ==========================================
  Widget _buildPopulatedState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 16, color: Colors.white),
                label: const Text('Reporte Ejecutivo', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D3E),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alerta de Desabastecimiento Crítico', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                      const SizedBox(height: 6),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 11, color: AppColors.error, height: 1.4),
                          children: [
                            TextSpan(text: 'Se estima que el inventario de combustible se agotará el '),
                            TextSpan(text: '24 de Octubre, 2023. ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Se recomienda programar reabastecimiento inmediato para evitar paros operativos (Burn Rate: 14.2% diario).'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              children: [
                const Text('Proyección de Consumo de Flota', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 24),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(value: 0.75, strokeWidth: 12, backgroundColor: const Color(0xFFE8F8F5), valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('75%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          Text('RESERVA ACTUAL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Ritmo de consumo óptimo', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.trending_down, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text('-2.4% vs semana anterior', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPopulatedMetricCard(icon: Icons.payments_outlined, badge: 'Costo Promedio', title: 'Costo Operativo Promedio', value: '\$1.42', suffix: 'USD', valueColor: AppColors.textDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildPopulatedMetricCard(icon: Icons.savings_outlined, badge: 'Este Mes', title: 'Ahorro Mensual', value: '+\$12,450', suffix: 'USD', valueColor: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Análisis de Consumo Corporativo\nMensual', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)), Icon(Icons.more_vert, color: AppColors.textGrey, size: 20)]),
                const SizedBox(height: 20),
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSimpleBar(60), _buildSimpleBar(80), _buildSimpleBar(50), _buildSimpleBar(90), _buildSimpleBar(110, isHighlighted: true), _buildSimpleBar(40),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [Text('Ene', style: TextStyle(fontSize: 10, color: AppColors.textGrey)), Text('Feb', style: TextStyle(fontSize: 10, color: AppColors.textGrey)), Text('Mar', style: TextStyle(fontSize: 10, color: AppColors.textGrey)), Text('Abr', style: TextStyle(fontSize: 10, color: AppColors.textGrey)), Text('May', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)), Text('Jun', style: TextStyle(fontSize: 10, color: AppColors.textGrey))],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Optimización de Operaciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          _buildOptimizationTile(Icons.local_shipping_outlined, 'Ruta de Mayor Rendimiento', 'Corredor Norte (L2)'),
          const SizedBox(height: 12),
          _buildOptimizationTile(Icons.access_time, 'Ventana Óptima de Suministro', '22:00 - 04:00 AM'),
          const SizedBox(height: 12),
          _buildOptimizationTile(Icons.speed, 'Eficiencia de Combustible (Flota)', '24.5 L / 100 km'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSimpleBar(double height, {bool isHighlighted = false}) {
    return Container(width: 24, height: height, decoration: BoxDecoration(color: isHighlighted ? AppColors.primary : const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(4)));
  }

  Widget _buildPopulatedMetricCard({required IconData icon, required String badge, required String title, required String value, required String suffix, required Color valueColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFE8F8F5), shape: BoxShape.circle), child: Icon(icon, size: 16, color: AppColors.primary)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(12)), child: Text(badge, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textGrey)))]),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)), const SizedBox(width: 4), Padding(padding: const EdgeInsets.only(bottom: 3), child: Text(suffix, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)))]),
        ],
      ),
    );
  }

  Widget _buildOptimizationTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FBFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark))]))]),
    );
  }

  // ==========================================
  // VISTA 2: SIN DATOS (Tu diseño de sincronización pendiente)
  // ==========================================
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 16, color: Colors.white),
                label: const Text('Exportar PDF', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: const [Text('Panel Principal', style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w600)), Icon(Icons.chevron_right, size: 16, color: AppColors.textGrey), Text('Analítica', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 20),
          _buildSkeletonCard('Consumo Total', Icons.info_outline, 'Datos insuficientes para este periodo'),
          const SizedBox(height: 12),
          _buildSkeletonCard('Eficiencia Flota', Icons.speed_outlined, 'Calculando métricas base...'),
          const SizedBox(height: 12),
          _buildSkeletonCard('Proyección Mensual', Icons.trending_up, 'Esperando historial de carga'),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAECEE),
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(image: AssetImage('assets/images/trailer.png'), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.white60, BlendMode.lighten)),
                  ),
                  child: Center(child: Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))]), child: const Icon(Icons.auto_graph, color: AppColors.primary, size: 28))),
                ),
                const SizedBox(height: 24),
                const Text('Sincronización de\nSensores de Flota\nPendiente', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.5),
                    children: [
                      TextSpan(text: 'Como administrador, para habilitar el tablero de Burn Rate, es necesario sincronizar los sensores de su flota. '),
                      TextSpan(text: 'Se requieren al menos 7 días de datos', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      TextSpan(text: ' continuos para que nuestros algoritmos generen proyecciones precisas.'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.sync, color: Colors.white, size: 18), label: const Text('Sincronizar Datos IoT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0))),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.help_outline, color: AppColors.primary, size: 18), label: const Text('Ver Guía de Configuración', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4EFDF), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Estado de Sensores', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          _buildSensorStatus(title: 'Sensor Principal #01', subtitle: 'Transmitiendo', icon: Icons.sensors, isActive: true),
          const SizedBox(height: 12),
          _buildSensorStatus(title: 'Unidad de Flota B-12', subtitle: 'Desconectado', icon: Icons.sensors_off, isActive: false),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF006D3E), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Consejo Pro', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)), SizedBox(height: 8), Text('Asegúrate de que tus conductores registren cada carga manualmente mientras completamos el despliegue de los sensores automáticos.', style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4))]),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)), Icon(icon, size: 16, color: AppColors.textGrey)]),
          const SizedBox(height: 12),
          Container(width: 80, height: 20, decoration: BoxDecoration(color: const Color(0xFFEAECEE), borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildSensorStatus({required String title, required String subtitle, required IconData icon, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isActive ? const Color(0xFFE8F8F5) : const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(12), border: Border.all(color: isActive ? const Color(0xFFB2EBF2) : AppColors.borderLight)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isActive ? const Color(0xFFD4EFDF) : const Color(0xFFEAECEE), shape: BoxShape.circle), child: Icon(icon, size: 16, color: isActive ? AppColors.primary : AppColors.textGrey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)), const SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? AppColors.primary : AppColors.textGrey))])),
          if (isActive) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}
