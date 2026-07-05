import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/fleet_service.dart';
import 'iot_cistern_detail_screen.dart';
import 'driver_list_screen.dart';
import 'tank_list_screen.dart';
import 'driver_form_screen.dart';
import 'tank_form_screen.dart';

class ProviderFleetScreen extends StatefulWidget {
  const ProviderFleetScreen({Key? key}) : super(key: key);

  @override
  _ProviderFleetScreenState createState() => _ProviderFleetScreenState();
}

class _ProviderFleetScreenState extends State<ProviderFleetScreen> {
  final FleetService _fleetService = FleetService();
  List<DriverModel> _drivers = [];
  List<TankModel> _tanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final drivers = await _fleetService.getDrivers();
    final tanks = await _fleetService.getTanks();

    // Sort Drivers (Fatigue > Route > Rest)
    drivers.sort((a, b) {
      if (a.status == 'FATIGUE' && b.status != 'FATIGUE') return -1;
      if (b.status == 'FATIGUE' && a.status != 'FATIGUE') return 1;
      if (a.status == 'ON_ROUTE' && b.status != 'ON_ROUTE') return -1;
      if (b.status == 'ON_ROUTE' && a.status != 'ON_ROUTE') return 1;
      return 0;
    });

    // Sort Tanks (Maintenance > Route > Available)
    tanks.sort((a, b) {
      if (a.status == 'MAINTENANCE' && b.status != 'MAINTENANCE') return -1;
      if (b.status == 'MAINTENANCE' && a.status != 'MAINTENANCE') return 1;
      if (a.status == 'ON_ROUTE' && b.status != 'ON_ROUTE') return -1;
      if (b.status == 'ON_ROUTE' && a.status != 'ON_ROUTE') return 1;
      return 0;
    });

    setState(() {
      _drivers = drivers;
      _tanks = tanks;
      _isLoading = false;
    });
  }

  int get _alertsCount {
    int alerts = 0;
    for (var d in _drivers) {
      if (d.status == 'FATIGUE') alerts++;
    }
    for (var t in _tanks) {
      if (t.status == 'MAINTENANCE' || t.valveStatus != 'CLOSED' || t.smartLockStatus == 'UNLOCKED') alerts++;
    }
    return alerts;
  }

  double get _compliancePercentage {
    // Formula inventada para fines demostrativos
    if (_drivers.isEmpty && _tanks.isEmpty) return 100.0;
    int totalIssues = _alertsCount;
    int totalAssets = _drivers.length + _tanks.length;
    double compliance = 100.0 - ((totalIssues / totalAssets) * 100);
    return compliance.clamp(0.0, 100.0);
  }

  ImageProvider _getDriverImage(DriverModel driver) {
    if (driver.profilePicture != null && driver.profilePicture!.isNotEmpty) {
      try {
        final decodedBytes = base64Decode(driver.profilePicture!);
        return MemoryImage(decodedBytes);
      } catch (e) {}
    }
    final seed = driver.name.isNotEmpty ? Uri.encodeComponent(driver.name) : 'Driver${driver.id}';
    return NetworkImage('https://api.dicebear.com/7.x/bottts/png?seed=$seed&backgroundColor=E0F2F1');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        physics: const AlwaysScrollableScrollPhysics(),
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
                      children: [
                        const Text('Cumplimiento', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${_compliancePercentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF5E7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDEBD0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alertas', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('$_alertsCount', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.error)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Conductores Activos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    Text('Total: ${_drivers.length}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverListScreen()));
                    _loadData();
                  },
                  child: const Text('Ver todos >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_drivers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('Sin conductores activos', style: TextStyle(color: AppColors.textGrey))),
              )
            else
              ..._drivers.take(3).map((d) {
                Color statusColor = AppColors.textGrey;
                Color statusBgColor = const Color(0xFFEAECEE);
                Color borderColor = AppColors.borderLight;
                String statusText = 'DISPONIBLE';
                Widget bottomContent = const SizedBox();

                if (d.status == 'FATIGUE') {
                  statusColor = AppColors.error;
                  statusBgColor = const Color(0xFFFFEBEE);
                  borderColor = const Color(0xFFFFCDD2);
                  statusText = 'ALERTA FATIGA';
                  bottomContent = Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Text('${d.drivingMinutes ~/ 60}h ${d.drivingMinutes % 60}m de conducción continua', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  );
                } else if (d.status == 'ON_ROUTE') {
                  statusColor = const Color(0xFF006D3E);
                  statusBgColor = const Color(0xFFE8F8F5);
                  statusText = 'EN RUTA';
                  bottomContent = Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Text('${d.drivingMinutes ~/ 60}h ${d.drivingMinutes % 60}m conduciendo', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  );
                } else if (d.status == 'RESTING') {
                  statusColor = AppColors.textDark;
                  statusText = 'DESCANSANDO';
                  bottomContent = Row(
                    children: [
                      const Icon(Icons.bed_outlined, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Text('Reanudación en: ${d.restingMinutesLeft ~/ 60}h ${d.restingMinutesLeft % 60}m', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  );
                }

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => DriverFormScreen(driver: d)));
                    _loadData();
                  },
                  child: Container(
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
                                CircleAvatar(radius: 20, backgroundImage: _getDriverImage(d)),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 2),
                                  Text('Licencia: ${d.licenseNumber}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
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
                        if (bottomContent is! SizedBox) ...[
                          const SizedBox(height: 16),
                          bottomContent,
                        ]
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Cisternas Activas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    Text('Total: ${_tanks.length}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const TankListScreen()));
                    _loadData();
                  },
                  child: const Text('Ver todas >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_tanks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('Sin cisternas activas', style: TextStyle(color: AppColors.textGrey))),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: _tanks.take(5).map((t) {
                    double fuelPct = (t.currentFuelGallons / (t.capacityGallons > 0 ? t.capacityGallons : 1));
                    String fuelText = '${(fuelPct * 100).toStringAsFixed(0)}%';
                    String statusStr = 'Estable';
                    Color lockColor = const Color(0xFF006D3E);
                    if (t.status == 'MAINTENANCE') statusStr = 'Mantenimiento';
                    if (t.smartLockStatus == 'UNLOCKED') lockColor = AppColors.error;

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => TankFormScreen(tank: t)));
                        _loadData();
                      },
                      child: Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: t.status == 'MAINTENANCE' ? const Color(0xFFFFCDD2) : AppColors.borderLight),
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
                                    Text(t.plate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                    const SizedBox(height: 4),
                                    Text('${t.model} • ${t.status}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: t.status == 'MAINTENANCE' ? const Color(0xFFFFEBEE) : const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(12)),
                                  child: Text(statusStr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: t.status == 'MAINTENANCE' ? AppColors.error : const Color(0xFF006D3E))),
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
                            LinearProgressIndicator(value: fuelPct, backgroundColor: AppColors.borderLight, color: const Color(0xFF006D3E), minHeight: 4),
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
                                          Text('${t.tirePressurePsi.toStringAsFixed(1)} PSI', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(t.smartLockStatus == 'LOCKED' ? Icons.lock : Icons.lock_open, size: 16, color: lockColor),
                                      const SizedBox(width: 6),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('SMART LOCK', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                                          Text(t.smartLockStatus == 'LOCKED' ? 'Bloqueado' : 'Abierto', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
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
                                      Icon(Icons.swap_vert, size: 16, color: t.valveStatus == 'OPEN' ? AppColors.error : AppColors.textGrey),
                                      const SizedBox(width: 6),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('VÁLVULA', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                                          Text(t.valveStatus == 'OPEN' ? 'Abierta' : 'Cerrada', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.speed, size: 16, color: t.speedKmh > 0 ? const Color(0xFF006D3E) : AppColors.textGrey),
                                      const SizedBox(width: 6),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('VELOCIDAD', style: TextStyle(fontSize: 8, color: AppColors.textGrey, letterSpacing: 0.5)),
                                          Text('${t.speedKmh.toStringAsFixed(0)} km/h', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: t.speedKmh > 0 ? const Color(0xFF006D3E) : AppColors.textGrey)),
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
                  }).toList(),
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}