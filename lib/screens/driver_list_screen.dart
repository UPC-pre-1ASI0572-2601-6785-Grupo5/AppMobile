import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/fleet_service.dart';
import 'driver_form_screen.dart';
import 'dart:convert';
import 'dart:math';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({Key? key}) : super(key: key);

  @override
  _DriverListScreenState createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final FleetService _fleetService = FleetService();
  List<DriverModel> _drivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    setState(() => _isLoading = true);
    final drivers = await _fleetService.getDrivers();
    
    // Sort logic: FATIGUE first, then ON_ROUTE, then others
    drivers.sort((a, b) {
      if (a.status == 'FATIGUE' && b.status != 'FATIGUE') return -1;
      if (b.status == 'FATIGUE' && a.status != 'FATIGUE') return 1;
      if (a.status == 'ON_ROUTE' && b.status != 'ON_ROUTE') return -1;
      if (b.status == 'ON_ROUTE' && a.status != 'ON_ROUTE') return 1;
      return 0;
    });

    setState(() {
      _drivers = drivers;
      _isLoading = false;
    });
  }

  ImageProvider _getDriverImage(DriverModel driver) {
    if (driver.profilePicture != null && driver.profilePicture!.isNotEmpty) {
      try {
        final decodedBytes = base64Decode(driver.profilePicture!);
        return MemoryImage(decodedBytes);
      } catch (e) {
        // Fallback
      }
    }
    // DiceBear fallback based on name or id
    final seed = driver.name.isNotEmpty ? Uri.encodeComponent(driver.name) : 'Driver${driver.id}';
    return NetworkImage('https://api.dicebear.com/7.x/bottts/png?seed=$seed&backgroundColor=E0F2F1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Todos los Conductores', style: TextStyle(color: AppColors.textDark, fontSize: 16)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverFormScreen()));
          if (result == true) _loadDrivers();
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _drivers.isEmpty
              ? const Center(child: Text('No hay conductores registrados.', style: TextStyle(color: AppColors.textGrey)))
              : RefreshIndicator(
                  onRefresh: _loadDrivers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _drivers.length,
                    itemBuilder: (context, index) {
                      final driver = _drivers[index];
                      Color statusColor = AppColors.textGrey;
                      Color statusBgColor = const Color(0xFFEAECEE);
                      String statusText = 'DISPONIBLE';

                      if (driver.status == 'FATIGUE') {
                        statusColor = AppColors.error;
                        statusBgColor = const Color(0xFFFFEBEE);
                        statusText = 'ALERTA FATIGA';
                      } else if (driver.status == 'ON_ROUTE') {
                        statusColor = const Color(0xFF006D3E);
                        statusBgColor = const Color(0xFFE8F8F5);
                        statusText = 'EN RUTA';
                      } else if (driver.status == 'RESTING') {
                        statusColor = AppColors.textDark;
                        statusText = 'DESCANSANDO';
                      }

                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => DriverFormScreen(driver: driver)));
                          if (result == true) _loadDrivers();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: driver.status == 'FATIGUE' ? const Color(0xFFFFCDD2) : AppColors.borderLight),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 24, backgroundImage: _getDriverImage(driver)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driver.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text('Licencia: ${driver.licenseNumber}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                                child: Text(statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                              ),
                            ],
                          ),
                          if (driver.status == 'FATIGUE' || (driver.status == 'AVAILABLE' && driver.completedTripsSinceRest > 0)) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  int minutes = driver.status == 'FATIGUE' ? 5 : 1;
                                  try {
                                    await _fleetService.setDriverRest(driver.id!, minutes);
                                    _loadDrivers();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFDE8E8),
                                  foregroundColor: AppColors.error,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Poner a descansar', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
