import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/main_navigation.dart';
import '../widgets/fueltrack_app_bar.dart';
import '../widgets/orders_bottom_navigation.dart';

enum _AlertFilter { all, critical, warning }

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  static const _bgColor = Color(0xFFF8F9FA);
  _AlertFilter _selectedFilter = _AlertFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: const FuelTrackAppBar(
        backgroundColor: _bgColor,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
            ..._buildFilteredAlerts(),
            const SizedBox(height: 16),
            _buildTodaySummary(),
            const SizedBox(height: 16),
            _buildMapPreview(),
            const SizedBox(height: 16),
            _buildControlActions(),
          ],
        ),
      ),
      bottomNavigationBar: OrdersBottomNavigation(
        currentIndex: 0,
        activeStyle: BottomNavActiveStyle.tinted,
        onTap: (index) => handleMainNavigation(context, index, 0),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'Alertas',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.done_all, size: 16, color: AppColors.trackingAccentGreen.withValues(alpha: 0.9)),
              const SizedBox(width: 6),
              Text(
                'Marcar todo como leído',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.trackingDarkGreen.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Todas',
            isSelected: _selectedFilter == _AlertFilter.all,
            onTap: () => setState(() => _selectedFilter = _AlertFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Críticas',
            icon: Icons.cancel_outlined,
            iconColor: AppColors.riskRed,
            isSelected: _selectedFilter == _AlertFilter.critical,
            onTap: () => setState(() => _selectedFilter = _AlertFilter.critical),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Advertencias',
            icon: Icons.warning_amber_outlined,
            iconColor: AppColors.warning,
            isSelected: _selectedFilter == _AlertFilter.warning,
            onTap: () => setState(() => _selectedFilter = _AlertFilter.warning),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredAlerts() {
    final alerts = <Widget>[];

    if (_selectedFilter == _AlertFilter.all || _selectedFilter == _AlertFilter.critical) {
      alerts.add(_CriticalAlertCard());
    }
    if (_selectedFilter == _AlertFilter.all || _selectedFilter == _AlertFilter.warning) {
      alerts.add(const SizedBox(height: 12));
      alerts.add(_WarningAlertCard());
    }
    if (_selectedFilter == _AlertFilter.all) {
      alerts.add(const SizedBox(height: 12));
      alerts.add(_TrackingAlertCard());
      alerts.add(const SizedBox(height: 12));
      alerts.add(_IotAlertCard());
    }

    return alerts;
  }

  Widget _buildTodaySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de Hoy',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          _SummaryRow(label: 'Críticas', count: '01', color: AppColors.riskRed),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Advertencias', count: '03', color: AppColors.warning),
          const SizedBox(height: 10),
          _SummaryRow(label: 'En ruta', count: '12', color: AppColors.trackingAccentGreen),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B2B26),
                    Color(0xFF243830),
                    Color(0xFF1B2B26),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _MapGridPainter(),
                size: const Size(double.infinity, 140),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Sede Norte activa hace 30 segundos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.trackingDeliveredBtnBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones de Control',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.trackingDarkGreen,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _ControlActionButton(icon: Icons.support_agent, label: 'SOPORTE')),
              const SizedBox(width: 12),
              Expanded(child: _ControlActionButton(icon: Icons.bar_chart, label: 'REPORTE')),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.trackingDarkGreen : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.trackingDarkGreen : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? Colors.white : iconColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CriticalAlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AlertCard(
      accentColor: AppColors.riskRed,
      icon: Icons.cancel,
      iconBg: AppColors.riskRedLight,
      category: 'PRIORIDAD CRÍTICA',
      categoryColor: AppColors.riskRed,
      time: 'Hace 2 min',
      title: 'Posible fuga detectada - Sede Norte',
      body:
          'El sensor IoT #SN-442 reporta una caída de presión anómala. Se recomienda inspección inmediata del tanque principal.',
      actions: [
        _AlertActionButton(
          label: 'Ver Mapa de Fuga',
          backgroundColor: AppColors.riskRed,
          textColor: Colors.white,
        ),
        _AlertActionButton(
          label: 'Cerrar Válvulas',
          backgroundColor: AppColors.riskRedLight,
          textColor: AppColors.riskRed,
        ),
      ],
    );
  }
}

class _WarningAlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AlertCard(
      accentColor: AppColors.warning,
      icon: Icons.warning_amber_rounded,
      iconBg: const Color(0xFFFFF3CD),
      category: 'ADVERTENCIA DE STOCK',
      categoryColor: AppColors.warning,
      time: 'Hace 15 min',
      title: 'Nivel bajo en tanque ultra-diésel',
      body: 'El tanque T-03 registra un 18% de capacidad. Se sugiere programar un pedido de reposición en las próximas 24 horas.',
      actions: [
        _AlertActionButton(
          label: 'Programar Pedido',
          icon: Icons.local_shipping_outlined,
          backgroundColor: AppColors.trackingDeliveredBtnBg,
          textColor: AppColors.trackingDarkGreen,
        ),
      ],
    );
  }
}

class _TrackingAlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AlertCard(
      accentColor: AppColors.trackingAccentGreen,
      icon: Icons.info_outline,
      iconBg: AppColors.trackingDeliveredBtnBg,
      category: 'SEGUIMIENTO',
      categoryColor: AppColors.trackingDarkGreen,
      time: 'Hace 45 min',
      title: 'Cisterna VXB-402 en ruta',
      body: 'La unidad se encuentra a 8 km de la planta de destino. ETA estimado: 15 minutos.',
      footer: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.placeholderBg,
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/56?img=33',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 16, color: AppColors.textGrey),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Conductor: Roberto M.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.chipInactiveText,
            ),
          ),
        ],
      ),
    );
  }
}

class _IotAlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AlertCard(
      accentColor: AppColors.chipInactiveText,
      icon: Icons.sensors,
      iconBg: const Color(0xFFF3F4F6),
      category: 'NOTIFICACIÓN IOT',
      categoryColor: AppColors.chipInactiveText,
      time: 'Hace 1 h',
      title: 'Sensor de presión calibrado con éxito',
      body: 'El sensor #SN-442 completó su calibración automática. Precisión actual: 98.5%.',
    );
  }
}

class _AlertCard extends StatelessWidget {
  final Color accentColor;
  final IconData icon;
  final Color iconBg;
  final String category;
  final Color categoryColor;
  final String time;
  final String title;
  final String body;
  final List<_AlertActionButton>? actions;
  final Widget? footer;

  const _AlertCard({
    required this.accentColor,
    required this.icon,
    required this.iconBg,
    required this.category,
    required this.categoryColor,
    required this.time,
    required this.title,
    required this.body,
    this.actions,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                          child: Icon(icon, size: 18, color: accentColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        color: categoryColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.chipInactiveText.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.chipInactiveText.withValues(alpha: 0.95),
                        height: 1.45,
                      ),
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 12),
                      footer!,
                    ],
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: actions!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;

  const _AlertActionButton({
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: textColor),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _ControlActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ControlActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.trackingDarkGreen),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: AppColors.trackingDarkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.trackingMapRoute.withValues(alpha: 0.12)
      ..strokeWidth = 0.5;

    for (var i = 0; i <= 8; i++) {
      final x = size.width * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var i = 0; i <= 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final nodePaint = Paint()..color = AppColors.trackingMapRoute;
    final glowPaint = Paint()
      ..color = AppColors.trackingMapRoute.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final nodes = [
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.55, size.height * 0.55),
      Offset(size.width * 0.75, size.height * 0.3),
    ];

    for (final node in nodes) {
      canvas.drawCircle(node, 10, glowPaint);
      canvas.drawCircle(node, 4, nodePaint);
    }

    final linePaint = Paint()
      ..color = AppColors.trackingMapRoute.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(nodes[0].dx, nodes[0].dy)
      ..lineTo(nodes[1].dx, nodes[1].dy)
      ..lineTo(nodes[2].dx, nodes[2].dy);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
