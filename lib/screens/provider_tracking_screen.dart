
import 'package:flutter/material.dart';
import '../constants/colors.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';
import 'package:intl/intl.dart';

class ProviderTrackingScreen extends StatefulWidget {
  final OrderModel order;
  const ProviderTrackingScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<ProviderTrackingScreen> createState() => _ProviderTrackingScreenState();
}

class _ProviderTrackingScreenState extends State<ProviderTrackingScreen> {
  bool _isLoading = false;
  final OrderService _orderService = OrderService();

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Pendiente';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a • dd MMM').format(dt);
    } catch (e) {
      return isoString;
    }
  }

  String _calculateETA() {
    if (widget.order.dispatchedAt == null && widget.order.createdAt.isEmpty) return '--:--';
    try {
      final baseDate = widget.order.dispatchedAt != null ? widget.order.dispatchedAt! : widget.order.createdAt;
      final dt = DateTime.parse(baseDate).toLocal();
      final etaDt = dt.add(Duration(minutes: widget.order.etaMinutes ?? 0));
      return DateFormat('HH:mm').format(etaDt);
    } catch (e) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
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
              const Icon(Icons.notifications_none, color: AppColors.textDark),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // ENCABEZADO: ID Y VOLUMEN
            // ==========================================
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
                  const Text('DESPACHO ID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text('#FT-${widget.order.id}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(12)),
                        child: Text(widget.order.status == 'DELIVERED' || widget.order.status == 'COMPLETED' ? 'Entregado' : 'En Ruta', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text('• Rastreo Activo', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Combustible', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                            SizedBox(height: 4),
                            Text('Diesel\nPremium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Volumen', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                            SizedBox(height: 4),
                            Text('32,000 L', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ==========================================
            // LÃNEA DE TIEMPO OPERATIVA
            // ==========================================
            const Text('Línea de Tiempo Operativa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 20),

            // Paso 1: Orden Aprobada
            _buildTimelineStep(
              isCompleted: true,
              isLast: false,
              title: 'Orden Aprobada',
              subtitle: '${_formatDate(widget.order.createdAt)}\nVerificado por ${widget.order.providerName ?? "Proveedor"}',
            ),

            // Paso 2: Recurso Asignado
            _buildTimelineStep(
              isCompleted: widget.order.dispatchedAt != null,
              isLast: false,
              title: 'Recurso Asignado',
              subtitle: _formatDate(widget.order.dispatchedAt ?? widget.order.createdAt),
              extraContent: widget.order.dispatchedAt != null ? Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    Text('Operador: ${widget.order.driverName ?? "Conductor Asignado"}', style: const TextStyle(fontSize: 11, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                  ],
                ),
              ) : null,
            ),

            // Paso 3: Carga Finalizada
            _buildTimelineStep(
              isCompleted: widget.order.dispatchedAt != null,
              isLast: false,
              title: 'Carga Finalizada',
              subtitle: '${_formatDate(widget.order.dispatchedAt ?? widget.order.createdAt)}\n${widget.order.providerAddress ?? "Sede Central"}',
            ),

            // Paso 4: En Ruta (ACTUAL - Con Mapa)
            _buildTimelineStep(
              isActive: widget.order.status == 'DISPATCHED' || widget.order.status == 'IN_TRANSIT',
              isLast: false,
              title: 'En Ruta',
              subtitle: 'Salida: ${_formatDate(widget.order.dispatchedAt ?? widget.order.createdAt)}',
              extraContent: (widget.order.status == 'DISPATCHED' || widget.order.status == 'IN_TRANSIT') ? Container(
                margin: const EdgeInsets.only(top: 12),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/trailer.png'), // Mapa simulado
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFF006D3E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.local_shipping, color: Colors.white, size: 14),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Text('Rastreo Activo', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(4)),
                              child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ) : null,
            ),

            // Paso 5: Entregado
            _buildTimelineStep(
              isCompleted: widget.order.status == 'DELIVERED' || widget.order.status == 'COMPLETED',
              isActive: widget.order.status == 'DELIVERED' || widget.order.status == 'COMPLETED',
              isLast: true,
              title: 'Entregado',
              subtitle: (widget.order.status == 'DELIVERED' || widget.order.status == 'COMPLETED') ? _formatDate(widget.order.completedAt) : 'Pendiente • Est. ${_calculateETA()}',
            ),

            const SizedBox(height: 16),

            // ==========================================
            // LLEGADA ESTIMADA (ETA)
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFE8F8F5), shape: BoxShape.circle),
                        child: const Icon(Icons.access_time, color: Color(0xFF006D3E), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('LLEGADA ESTIMADA (ETA)', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_calculateETA(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 6, left: 4),
                                child: Text('hrs', style: TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: AppColors.borderLight),
                  ),
                  const Text('Tiempo de Viaje Estimado', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  const SizedBox(height: 4),
                  Text('${widget.order.etaMinutes ?? 0} minutos', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                  const SizedBox(height: 4),
                  const Text('Ruta sin demoras reportadas', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // DETALLES DE RUTA Y ENTREGA
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detalles de Ruta y Entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 24),

                  // Conector de Origen y Destino
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.textGrey, shape: BoxShape.circle)),
                            Expanded(child: Container(width: 2, color: AppColors.borderLight)),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF006D3E), shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Volumen', style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${widget.order.quantityGallons} GL', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 16),
                              Text('Producto', style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(widget.order.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 24),
                              const Text('ORIGEN', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text(widget.order.providerName ?? 'Sede Central', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 2),
                              Text(widget.order.providerAddress ?? 'Dirección del Proveedor', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),

                              const SizedBox(height: 24),

                              const Text('DESTINO FINAL', style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text(widget.order.documentRef.isNotEmpty ? widget.order.documentRef : 'Sede del Cliente', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 2),
                              const Text('Destino Seleccionado', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (widget.order.status == 'DELIVERED' || widget.order.status == 'COMPLETED') ? null : () async {
                          setState(() => _isLoading = true);
                          try {
                            await _orderService.markAsDelivered(widget.order.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido marcado como entregado'), backgroundColor: AppColors.primary));
                              Navigator.pop(context); // Regresa a la lista de despachos
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                          disabledBackgroundColor: AppColors.borderLight,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          (widget.order.status == 'DELIVERED' || widget.order.status == 'COMPLETED') ? 'Ya Entregado' : 'Marcar como Entregado',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ===============================================
  // WIDGET REUTILIZABLE: LÃNEA DE TIEMPO
  // ===============================================
  Widget _buildTimelineStep({
    bool isCompleted = false,
    bool isActive = false,
    required bool isLast,
    required String title,
    required String subtitle,
    Widget? extraContent,
  }) {
    Color iconColor;
    Color bgColor;

    if (isCompleted) {
      iconColor = Colors.white;
      bgColor = const Color(0xFF006D3E);
    } else if (isActive) {
      iconColor = Colors.white;
      bgColor = const Color(0xFF2ECC71);
    } else {
      iconColor = AppColors.textGrey;
      bgColor = AppColors.borderLight;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna del Icono y la línea vertical
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(
                  isCompleted ? Icons.check : (isActive ? Icons.local_shipping : Icons.flag),
                  size: 14,
                  color: iconColor,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: (isCompleted || isActive) ? const Color(0xFF006D3E).withOpacity(0.3) : AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Columna del Texto y contenido extra
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isActive ? const Color(0xFF006D3E) : (isCompleted ? AppColors.textDark : AppColors.textGrey),
                        ),
                      ),
                      if (isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(4)),
                          child: const Text('ACTUAL', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4),
                  ),
                  if (extraContent != null) extraContent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
