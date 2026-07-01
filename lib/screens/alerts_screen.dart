import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // Variable que controla si hay notificaciones o no
  bool _hasAlerts = true;

  // Función que se ejecuta al presionar "Marcar todo como leído"
  void _markAllAsRead() {
    setState(() {
      _hasAlerts = false;
    });

    // Muestra un pequeño mensaje de confirmación abajo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las alertas han sido marcadas como leídas'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                icon: const Icon(Icons.notifications_active, color: AppColors.primary),
                onPressed: () {},
              ),
              if (_hasAlerts) // El punto rojo solo sale si hay alertas
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de Alertas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alertas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                if (_hasAlerts)
                  TextButton.icon(
                    onPressed: _markAllAsRead,
                    icon: const Icon(Icons.check, size: 16, color: AppColors.primary),
                    label: const Text('Marcar todo como leído', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // CONDICIONAL: Si hay alertas muestra la lista, sino muestra el estado vacío
            _hasAlerts ? _buildAlertsList() : _buildEmptyState(),

          ],
        ),
      ),
      floatingActionButton: _hasAlerts ? FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.notifications_active, color: Colors.white),
      ) : null,
    );
  }

  // ==========================================
  // VISTA CON ALERTAS (Tu diseño completo original)
  // ==========================================
  Widget _buildAlertsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filtros
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Todas', true, null),
              const SizedBox(width: 8),
              _buildFilterChip('Críticas', false, Icons.warning_rounded, iconColor: AppColors.error),
              const SizedBox(width: 8),
              _buildFilterChip('Advertencias', false, Icons.warning_amber_rounded, iconColor: const Color(0xFFF39C12)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tarjeta 1: Crítica
        _buildAlertCard(
          borderColor: AppColors.error,
          icon: Icons.close,
          iconBgColor: const Color(0xFFFFEBEE),
          iconColor: AppColors.error,
          tagText: 'PRIORIDAD CRÃTICA',
          tagColor: AppColors.error,
          time: 'Hace 2 min',
          title: 'Posible fuga detectada\n- Sede Norte',
          description: 'El sensor 4B-902 reporta una caída de presión anómala fuera de los rangos de seguridad. Se requiere inspección inmediata.',
          actions: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Ver Mapa de\nFuga', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cerrar\nVálvulas', textAlign: TextAlign.center, style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tarjeta 2: Advertencia
        _buildAlertCard(
          borderColor: const Color(0xFFF39C12),
          icon: Icons.warning_amber_rounded,
          iconBgColor: const Color(0xFFFEF5E7),
          iconColor: const Color(0xFFF39C12),
          tagText: 'ADVERTENCIA DE STOCK',
          tagColor: const Color(0xFFF39C12),
          time: 'Hace 15 min',
          title: 'Nivel bajo en tanque ultra-diésel',
          description: 'El tanque T-104 en la central de despacho se encuentra al 12% de su capacidad. Reabastecimiento sugerido en las próximas 4 horas.',
          actions: Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.primary),
              label: const Text('Programar Pedido', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4EFDF),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tarjeta 3: Seguimiento
        _buildAlertCard(
          borderColor: AppColors.primary,
          icon: Icons.info_outline,
          iconBgColor: const Color(0xFFE8F8F5),
          iconColor: AppColors.primary,
          tagText: 'SEGUIMIENTO',
          tagColor: AppColors.primary,
          time: 'Hace 45 min',
          title: 'Cisterna VXB-402 en ruta',
          description: 'La unidad ha salido del centro logístico principal con destino a Estación Oriente. ETA: 14:30 PM.',
          footer: Row(
            children: [
              const CircleAvatar(radius: 12, backgroundImage: AssetImage('assets/images/logo.png')),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFFEAECEE), shape: BoxShape.circle),
                child: const Text('+1', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ),
              const SizedBox(width: 12),
              const Text('Conductor: Roberto M.', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tarjeta 4: IoT
        _buildAlertCard(
          borderColor: const Color(0xFF7F8C8D),
          icon: Icons.sensors,
          iconBgColor: const Color(0xFFF2F4F4),
          iconColor: const Color(0xFF7F8C8D),
          tagText: 'NOTIFICACIÓN IOT',
          tagColor: const Color(0xFF7F8C8D),
          time: 'Hace 1 h',
          title: 'Sensor de presión calibrado con éxito',
          description: 'El sistema de mantenimiento remoto ha finalizado la calibración periódica del nodo S-55. Operatividad al 100%.',
        ),
        const SizedBox(height: 24),

        // Tarjeta de Resumen
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resumen de Hoy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              _buildSummaryRow(AppColors.error, 'Críticas', '01'),
              const SizedBox(height: 12),
              _buildSummaryRow(const Color(0xFFF39C12), 'Advertencias', '03'),
              const SizedBox(height: 12),
              _buildSummaryRow(AppColors.primary, 'En ruta', '12'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Imagen de Mapa / Actividad
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/images/trailer.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(153),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined, color: Colors.white, size: 12),
                  SizedBox(width: 6),
                  Text('Sede Norte activación hace 30 segundos.', style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Acciones de Control
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB2EBF2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Acciones de Control', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]),
                      child: Column(
                        children: const [
                          Icon(Icons.support_agent, color: AppColors.primary, size: 20),
                          SizedBox(height: 4),
                          Text('SOPORTE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]),
                      child: Column(
                        children: const [
                          Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
                          SizedBox(height: 4),
                          Text('REPORTE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==========================================
  // VISTA VACÃA (Cuando marcas todo como leído)
  // ==========================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.check_circle_outline, size: 100, color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: 24),
          const Text('¡Estás al día!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          const Text(
            'No tienes notificaciones pendientes\nen este momento.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.4),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            child: const Text('Volver al Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // ==========================================
  // WIDGETS REUTILIZABLES
  // ==========================================
  Widget _buildFilterChip(String label, bool isSelected, IconData? icon, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : const Color(0xFFF4F7F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
          ],
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required Color borderColor,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String tagText,
    required Color tagColor,
    required String time,
    required String title,
    required String description,
    Widget? actions,
    Widget? footer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      // IntrinsicHeight evita que la pantalla se ponga blanca por un error de renderizado
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                          child: Icon(icon, size: 16, color: iconColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(tagText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: tagColor, letterSpacing: 0.5)),
                                  Text(time, style: const TextStyle(fontSize: 9, color: AppColors.textGrey)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description, style: const TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.4)),
                          if (actions != null) ...[
                            const SizedBox(height: 12),
                            actions,
                          ],
                          if (footer != null) ...[
                            const SizedBox(height: 12),
                            footer,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(Color dotColor, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ],
    );
  }
}
