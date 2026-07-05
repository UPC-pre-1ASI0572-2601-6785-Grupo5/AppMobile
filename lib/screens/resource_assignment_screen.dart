import 'package:flutter/material.dart';
import '../constants/colors.dart';

import '../services/fleet_service.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class ResourceAssignmentScreen extends StatefulWidget {
  final OrderModel order;
  const ResourceAssignmentScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<ResourceAssignmentScreen> createState() => _ResourceAssignmentScreenState();
}

class _ResourceAssignmentScreenState extends State<ResourceAssignmentScreen> {
  int? _selectedDriverIndex;
  int? _selectedVehicleIndex;
  bool _isLoading = true;
  List<DriverModel> _drivers = [];
  List<TankModel> _tanks = [];
  final FleetService _fleetService = FleetService();
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final drivers = await _fleetService.getDrivers();
      final tanks = await _fleetService.getTanks();
      if (mounted) {
        setState(() {
          _drivers = drivers.where((d) => d.status == 'AVAILABLE' && d.completedTripsSinceRest < 2).toList();
          _tanks = tanks.where((t) => t.status == 'AVAILABLE' && t.completedTripsSinceMaintenance < 5).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return 'Desconocida';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM, yyyy -\nhh:mm a').format(dt);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Text(
              'Despachos > Orden #FT-${widget.order.createdAt.isNotEmpty ? widget.order.createdAt.substring(0, 4) : ''}-${widget.order.id}',
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Título Principal
            const Text(
              'Asignación de Recursos',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),

            // Badge "Pendiente de Asignación"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.assignment_turned_in_outlined, color: AppColors.primary, size: 14),
                  SizedBox(width: 6),
                  Text('Pendiente de Asignación', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // TARJETA: RESUMEN DE LA ORDEN
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.receipt_long, color: AppColors.primary, size: 24),
                          const SizedBox(width: 12),
                          const Text('Resumen de la\nOrden', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Fecha Solicitada', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(_formatDate(widget.order.createdAt), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Cliente', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: AppColors.textGrey),
                      const SizedBox(width: 8),
                      Text(widget.order.name.isNotEmpty ? widget.order.name : 'Cliente Anónimo', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Combustible', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.local_gas_station_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(widget.order.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Volumen', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${widget.order.quantityGallons} GL', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ==========================================
            // VALIDACIONES DE RIESGO
            // ==========================================
            const Text('VALIDACIONES DE RIESGO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            _buildRiskCard('Stock Disponible', 'Planta Callao Terminal', '12k GL'),
            _buildRiskCard('Línea de Crédito', 'Estado: Activa', '\$45,000'),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary)))
            else ...[
              // ==========================================
              // SECCIÓN: CONDUCTORES
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Conductores Disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
              const SizedBox(height: 12),
              if (_drivers.isEmpty)
                const Padding(padding: EdgeInsets.all(16), child: Text('No hay conductores disponibles.', style: TextStyle(color: AppColors.textGrey)))
              else
                ..._drivers.asMap().entries.map((e) => _buildDriverOption(
                  index: e.key,
                  name: e.value.name,
                  details: 'Licencia ${e.value.licenseNumber}',
                  isAvailable: true,
                  imgUrl: e.value.profilePicture ?? 'assets/images/logo.png',
                )).toList(),
              const SizedBox(height: 24),

              // ==========================================
              // SECCIÓN: CISTERNAS
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Cisternas Disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
              const SizedBox(height: 12),
              if (_tanks.isEmpty)
                const Padding(padding: EdgeInsets.all(16), child: Text('No hay cisternas disponibles con capacidad suficiente.', style: TextStyle(color: AppColors.textGrey)))
              else
                ..._tanks.where((t) => t.capacityGallons >= widget.order.quantityGallons).toList().asMap().entries.map((e) => _buildVehicleOption(
                  index: e.key,
                  name: e.value.model,
                  capacity: '${e.value.capacityGallons} GL',
                  plate: e.value.plate,
                  statusTag: 'DISPONIBLE',
                )).toList(),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),

      // ==========================================
      // BARRA INFERIOR (BOTONES)
      // ==========================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: (_selectedVehicleIndex != null && _selectedDriverIndex != null && !_isLoading)
                      ? () async {
                          setState(() => _isLoading = true);
                          try {
                            final driver = _drivers[_selectedDriverIndex!];
                            final validTanks = _tanks.where((t) => t.capacityGallons >= widget.order.quantityGallons).toList();
                            final tank = validTanks[_selectedVehicleIndex!];
                            
                            await _orderService.dispatchOrder(widget.order.id!, driver.id!, tank.id!);
                            if (mounted) {
                              Navigator.pop(context, true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Recursos asignados correctamente'), backgroundColor: AppColors.primary),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
                              );
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.borderLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  child: const Text('Confirmar Asignación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================
  // WIDGETS REUTILIZABLES INTERNOS
  // ===============================================

  Widget _buildRiskCard(String title, String subtitle, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FBF6), // Fondo verde clarito
        border: Border.all(color: const Color(0xFFD4EFDF)), // Borde verde claro
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildDriverOption({required int index, required String name, required String details, required bool isAvailable, required String imgUrl}) {
    final bool isSelected = _selectedDriverIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDriverIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withAlpha(26), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                imgUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                // Protección por si la imagen de internet no carga
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 44,
                  height: 44,
                  color: const Color(0xFFEAECEE),
                  child: const Icon(Icons.person, color: AppColors.textGrey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(details, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: isAvailable ? AppColors.primary : const Color(0xFFF39C12), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailable ? 'DISPONIBLE AHORA' : 'EN SERVICIO',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isAvailable ? AppColors.primary : const Color(0xFFF39C12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET MODIFICADO: Volvemos al ícono de camioncito gris, tal como está en el Figma
  Widget _buildVehicleOption({required int index, required String name, required String capacity, required String plate, required String statusTag}) {
    final bool isSelected = _selectedVehicleIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicleIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withAlpha(26), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            // Contenedor Gris con el Icono (IDÉNTICO AL FIGMA)
            Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(color: const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.local_shipping, color: AppColors.textGrey, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFEAECEE), borderRadius: BorderRadius.circular(4)),
                        child: Text(statusTag, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Capacidad: $capacity (Placa: $plate)', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
