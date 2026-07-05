import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/fleet_service.dart';
import 'tank_form_screen.dart';

class TankListScreen extends StatefulWidget {
  const TankListScreen({Key? key}) : super(key: key);

  @override
  _TankListScreenState createState() => _TankListScreenState();
}

class _TankListScreenState extends State<TankListScreen> {
  final FleetService _fleetService = FleetService();
  List<TankModel> _tanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTanks();
  }

  Future<void> _loadTanks() async {
    setState(() => _isLoading = true);
    final tanks = await _fleetService.getTanks();
    
    // Sort logic: MAINTENANCE first, then ON_ROUTE, then AVAILABLE
    tanks.sort((a, b) {
      if (a.status == 'MAINTENANCE' && b.status != 'MAINTENANCE') return -1;
      if (b.status == 'MAINTENANCE' && a.status != 'MAINTENANCE') return 1;
      if (a.status == 'ON_ROUTE' && b.status != 'ON_ROUTE') return -1;
      if (b.status == 'ON_ROUTE' && a.status != 'ON_ROUTE') return 1;
      return 0;
    });

    setState(() {
      _tanks = tanks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Todas las Cisternas', style: TextStyle(color: AppColors.textDark, fontSize: 16)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const TankFormScreen()));
          if (result == true) _loadTanks();
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _tanks.isEmpty
              ? const Center(child: Text('No hay cisternas registradas.', style: TextStyle(color: AppColors.textGrey)))
              : RefreshIndicator(
                  onRefresh: _loadTanks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _tanks.length,
                    itemBuilder: (context, index) {
                      final tank = _tanks[index];
                      Color statusColor = AppColors.textGrey;
                      Color statusBgColor = const Color(0xFFEAECEE);
                      String statusText = 'DISPONIBLE';

                      if (tank.status == 'MAINTENANCE') {
                        statusColor = AppColors.error;
                        statusBgColor = const Color(0xFFFFEBEE);
                        statusText = 'MANTENIMIENTO';
                      } else if (tank.status == 'ON_ROUTE') {
                        statusColor = const Color(0xFF006D3E);
                        statusBgColor = const Color(0xFFE8F8F5);
                        statusText = 'EN RUTA';
                      }

                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => TankFormScreen(tank: tank)));
                          if (result == true) _loadTanks();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: tank.status == 'MAINTENANCE' ? const Color(0xFFFFCDD2) : AppColors.borderLight),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.local_shipping, color: AppColors.primary, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${tank.plate} - ${tank.model}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text('Combustible: ${tank.currentFuelGallons} / ${tank.capacityGallons} Gal', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                                child: Text(statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
